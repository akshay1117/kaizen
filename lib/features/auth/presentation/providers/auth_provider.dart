import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kaizen/services/supabase_config.dart';
import 'package:flutter/foundation.dart';
/// Stream of Supabase Auth state changes
final authStateProvider = StreamProvider<AuthState>((ref) {
  return SupabaseConfig.client.auth.onAuthStateChange;
});

/// Currently authenticated Supabase user (or null if not logged in)
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.value?.session?.user ?? SupabaseConfig.client.auth.currentUser;
});

/// Whether user is currently logged in
final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});

/// Auth controller for handling sign in, sign up, sign out, and password reset
class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController() : super(const AsyncValue.data(null));

  final SupabaseClient _client = SupabaseConfig.client;

  Future<bool> signIn({required String email, required String password}) async {
    state = const AsyncValue.loading();
    try {
      final response = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      if (response.user != null) {
        state = const AsyncValue.data(null);
        return true;
      } else {
        throw const AuthException('Invalid login credentials');
      }
    } catch (e, st) {
      debugPrint('Email Sign-In Error: $e');
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = const AsyncValue.loading();
    try {
      final response = await _client.auth.signUp(
        email: email.trim(),
        password: password,
        data: displayName != null && displayName.trim().isNotEmpty
            ? {'display_name': displayName.trim()}
            : null,
      );
      if (response.user != null) {
        if (response.session == null) {
          throw const AuthException('Account created successfully! Please check your email to confirm your account before signing in.');
        }
        state = const AsyncValue.data(null);
        return true;
      } else {
        throw const AuthException('Failed to create account');
      }
    } catch (e, st) {
      debugPrint('Email Sign-Up Error: $e');
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _client.auth.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> resetPassword(String email) async {
    state = const AsyncValue.loading();
    try {
      await _client.auth.resetPasswordForEmail(email.trim());
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      // NOTE: Replace YOUR_GOOGLE_WEB_CLIENT_ID.apps.googleusercontent.com with your actual Web Client ID!
      const webClientId = 'YOUR_GOOGLE_WEB_CLIENT_ID.apps.googleusercontent.com';
      
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: webClientId,
        serverClientId: webClientId,
      );
      
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        state = const AsyncValue.data(null);
        return false;
      }
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      if (idToken == null) {
        throw const AuthException('No ID Token found from Google Sign In.');
      }

      final response = await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
      
      if (response.user != null) {
        state = const AsyncValue.data(null);
        return true;
      } else {
        throw const AuthException('Failed to sign in with Google');
      }
    } catch (e, st) {
      debugPrint('Google Sign-In Error: $e');
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> signInWithApple() async {
    state = const AsyncValue.loading();
    try {
      final response = await _client.auth.signInWithOAuth(OAuthProvider.apple);
      state = const AsyncValue.data(null);
      return response;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController();
});
