import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/expense_providers.dart';
import '../../data/expense_database.dart';

class AccountSelectorBottomSheet extends ConsumerStatefulWidget {
  final Function(ExpenseAccount? account)? onAccountSelected;
  const AccountSelectorBottomSheet({super.key, this.onAccountSelected});

  @override
  ConsumerState<AccountSelectorBottomSheet> createState() => _AccountSelectorBottomSheetState();
}

class _AccountSelectorBottomSheetState extends ConsumerState<AccountSelectorBottomSheet> {
  final TextEditingController _accountNameController = TextEditingController();

  void _showAddAccountDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1C1C1E),
          title: const Text('Add Account', style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: _accountNameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Account Name',
              hintStyle: const TextStyle(color: Color(0xFF8E8E93)),
              filled: true,
              fillColor: const Color(0xFF2C2C2E),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF8E8E93))),
            ),
            TextButton(
              onPressed: () async {
                if (_accountNameController.text.isNotEmpty) {
                  final dao = ref.read(expenseDaoProvider);
                  await dao.insertAccount(
                    ExpenseAccountsCompanion.insert(
                      name: _accountNameController.text,
                    ),
                  );
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text('Add', style: TextStyle(color: Color(0xFF0A84FF))),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(accountsProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF3A3A3C),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Done', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                const Text(
                  'Accounts',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2C2C2E),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.add, color: Colors.white, size: 20),
                    onPressed: _showAddAccountDialog,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFF2C2C2E), height: 1),
          Expanded(
            child: accountsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF3A3A3C))),
              error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
              data: (accounts) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: accounts.length + 1, // +1 for "No Account"
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return ListTile(
                        leading: const Icon(Icons.account_balance_wallet, color: Color(0xFF8E8E93)),
                        title: const Text('No account (optional)', style: TextStyle(color: Color(0xFF8E8E93), fontSize: 16)),
                        onTap: () {
                          if (widget.onAccountSelected != null) widget.onAccountSelected!(null);
                          Navigator.pop(context);
                        },
                      );
                    }
                    final account = accounts[index - 1];
                    return ListTile(
                      leading: const Icon(Icons.account_balance_wallet, color: Colors.white),
                      title: Text(account.name, style: const TextStyle(color: Colors.white, fontSize: 16)),
                      onTap: () {
                        if (widget.onAccountSelected != null) widget.onAccountSelected!(account);
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
