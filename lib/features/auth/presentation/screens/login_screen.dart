import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import 'package:kaizen/features/auth/presentation/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isSignUp = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _errorMessage = null);

    final authController = ref.read(authControllerProvider.notifier);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    bool success;
    if (_isSignUp) {
      success = await authController.signUp(
        email: email,
        password: password,
        displayName: _nameController.text.trim(),
      );
    } else {
      success = await authController.signIn(
        email: email,
        password: password,
      );
    }

    if (!success && mounted) {
      final state = ref.read(authControllerProvider);
      state.whenOrNull(
        error: (error, _) {
          setState(() {
            _errorMessage = error.toString().replaceFirst('Exception: ', '').replaceFirst('AuthException: ', '');
          });
        },
      );
    }
  }

  void _showForgotPasswordDialog() {
    final resetEmailController = TextEditingController(text: _emailController.text);
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceElevatedLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.lg),
            side: const BorderSide(color: AppColors.borderSpecular),
          ),
          title: Text(
            'Reset Password',
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your email to receive a password reset link.',
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: resetEmailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'name@example.com',
                  hintStyle: const TextStyle(color: AppColors.textTertiary),
                  prefixIcon: const Icon(LucideIcons.mail, color: AppColors.textSecondary, size: 18),
                  filled: true,
                  fillColor: AppColors.surfaceElevatedMid,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadii.md),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () async {
                final email = resetEmailController.text.trim();
                if (email.isEmpty) return;
                Navigator.pop(dialogContext);
                final sent = await ref.read(authControllerProvider.notifier).resetPassword(email);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: sent ? AppColors.semanticPositive : AppColors.semanticUrgent,
                      content: Text(
                        sent ? 'Password reset link sent to $email' : 'Failed to send reset link',
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentViolet,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: const Text('Send Link', style: TextStyle(color: AppColors.surfacePitchBlack, fontWeight: FontWeight.w600)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return GlassScaffold(
      backgroundColor: AppColors.surfacePitchBlack,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 420.w),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Brand Icon / Header
                    Center(
                      child: Container(
                        width: 72.w,
                        height: 72.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [AppColors.accentViolet, Color(0xFF00897B)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accentViolet.withValues(alpha: 0.35),
                              blurRadius: 24,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            LucideIcons.flame,
                            color: AppColors.surfacePitchBlack,
                            size: 36.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Title & Subtitle
                    Text(
                      _isSignUp ? 'Create Account' : 'Welcome Back',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      _isSignUp
                          ? 'Join Kaizen to track your performance'
                          : 'Sign in to access your workouts & habits',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 28.h),

                    // Segmented Toggle: Sign In vs Sign Up
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevatedLow,
                        borderRadius: BorderRadius.circular(AppRadii.lg),
                        border: Border.all(color: AppColors.borderSpecular),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (_isSignUp) {
                                  setState(() {
                                    _isSignUp = false;
                                    _errorMessage = null;
                                  });
                                }
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                decoration: BoxDecoration(
                                  color: !_isSignUp ? AppColors.surfaceElevatedMid : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: !_isSignUp
                                      ? Border.all(color: AppColors.borderActive)
                                      : null,
                                ),
                                child: Text(
                                  'Sign In',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 13.sp,
                                    fontWeight: !_isSignUp ? FontWeight.w700 : FontWeight.w500,
                                    color: !_isSignUp ? AppColors.textPrimary : AppColors.textTertiary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (!_isSignUp) {
                                  setState(() {
                                    _isSignUp = true;
                                    _errorMessage = null;
                                  });
                                }
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                decoration: BoxDecoration(
                                  color: _isSignUp ? AppColors.surfaceElevatedMid : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: _isSignUp
                                      ? Border.all(color: AppColors.borderActive)
                                      : null,
                                ),
                                child: Text(
                                  'Create Account',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 13.sp,
                                    fontWeight: _isSignUp ? FontWeight.w700 : FontWeight.w500,
                                    color: _isSignUp ? AppColors.textPrimary : AppColors.textTertiary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Error Message Banner (if any)
                    if (_errorMessage != null) ...[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: AppColors.semanticUrgent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(AppRadii.md),
                          border: Border.all(color: AppColors.semanticUrgent.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          children: [
                            Icon(LucideIcons.alertCircle, color: AppColors.semanticUrgent, size: 18.sp),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: GoogleFonts.inter(
                                  color: AppColors.semanticUrgent,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],

                    // Full Name (Only on Sign Up)
                    if (_isSignUp) ...[
                      Text(
                        'Full Name',
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(color: AppColors.textPrimary),
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'e.g. Alex Smith',
                          hintStyle: const TextStyle(color: AppColors.textTertiary),
                          prefixIcon: const Icon(LucideIcons.user, color: AppColors.textSecondary, size: 18),
                          filled: true,
                          fillColor: AppColors.surfaceElevatedLow,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadii.md),
                            borderSide: const BorderSide(color: AppColors.borderSpecular),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadii.md),
                            borderSide: const BorderSide(color: AppColors.borderSpecular),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadii.md),
                            borderSide: const BorderSide(color: AppColors.accentViolet, width: 1.5),
                          ),
                        ),
                        validator: (val) {
                          if (_isSignUp && (val == null || val.trim().isEmpty)) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                    ],

                    // Email Field
                    Text(
                      'Email Address',
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: AppColors.textPrimary),
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: 'name@example.com',
                        hintStyle: const TextStyle(color: AppColors.textTertiary),
                        prefixIcon: const Icon(LucideIcons.mail, color: AppColors.textSecondary, size: 18),
                        filled: true,
                        fillColor: AppColors.surfaceElevatedLow,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadii.md),
                          borderSide: const BorderSide(color: AppColors.borderSpecular),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadii.md),
                          borderSide: const BorderSide(color: AppColors.borderSpecular),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadii.md),
                          borderSide: const BorderSide(color: AppColors.accentViolet, width: 1.5),
                        ),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Please enter your email';
                        if (!val.contains('@') || !val.contains('.')) return 'Please enter a valid email';
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Password Field
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Password',
                          style: GoogleFonts.inter(
                            color: AppColors.textSecondary,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (!_isSignUp)
                          GestureDetector(
                            onTap: _showForgotPasswordDialog,
                            child: Text(
                              'Forgot?',
                              style: GoogleFonts.inter(
                                color: AppColors.accentViolet,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: AppColors.textPrimary),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: const TextStyle(color: AppColors.textTertiary),
                        prefixIcon: const Icon(LucideIcons.lock, color: AppColors.textSecondary, size: 18),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? LucideIcons.eyeOff : LucideIcons.eye,
                            color: AppColors.textSecondary,
                            size: 18,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        filled: true,
                        fillColor: AppColors.surfaceElevatedLow,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadii.md),
                          borderSide: const BorderSide(color: AppColors.borderSpecular),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadii.md),
                          borderSide: const BorderSide(color: AppColors.borderSpecular),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadii.md),
                          borderSide: const BorderSide(color: AppColors.accentViolet, width: 1.5),
                        ),
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Please enter your password';
                        if (val.length < 6) return 'Password must be at least 6 characters';
                        return null;
                      },
                    ),
                    SizedBox(height: 28.h),

                    ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentViolet,
                        foregroundColor: AppColors.surfacePitchBlack,
                        disabledBackgroundColor: AppColors.accentViolet.withValues(alpha: 0.5),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadii.md),
                        ),
                        elevation: 4,
                        shadowColor: AppColors.accentViolet.withValues(alpha: 0.4),
                      ),
                      child: isLoading
                          ? SizedBox(
                              width: 22.w,
                              height: 22.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.surfacePitchBlack),
                              ),
                            )
                          : Text(
                              _isSignUp ? 'Create Account' : 'Sign In',
                              style: GoogleFonts.inter(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                    SizedBox(height: 32.h),

                    // Divider
                    Row(
                      children: [
                        const Expanded(child: Divider(color: AppColors.borderSpecular)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            'Or continue with',
                            style: GoogleFonts.inter(
                              color: AppColors.textTertiary,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(color: AppColors.borderSpecular)),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    // Social Auth Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: isLoading
                                ? null
                                : () async {
                                    final authController = ref.read(authControllerProvider.notifier);
                                    await authController.signInWithGoogle();
                                  },
                            icon: FaIcon(FontAwesomeIcons.google, color: AppColors.textPrimary, size: 20.sp),
                            label: const Text('Google', style: TextStyle(color: AppColors.textPrimary)),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              side: const BorderSide(color: AppColors.borderSpecular),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.md)),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: isLoading
                                ? null
                                : () async {
                                    final authController = ref.read(authControllerProvider.notifier);
                                    await authController.signInWithApple();
                                  },
                            icon: FaIcon(FontAwesomeIcons.apple, color: AppColors.textPrimary, size: 20.sp),
                            label: const Text('Apple', style: TextStyle(color: AppColors.textPrimary)),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              side: const BorderSide(color: AppColors.borderSpecular),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.md)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
