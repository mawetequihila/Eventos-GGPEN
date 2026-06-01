import 'package:flutter/material.dart';
import 'package:ggpen_angotic/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

/// Após login Google: pede telefone, empresa e cargo (nome+email já vêm do
/// Google via trigger). Grava na tabela `profiles` do Supabase.
class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _phone;
  late final TextEditingController _company;
  late final TextEditingController _role;
  bool _submitted = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<AppState>();
    _phone = TextEditingController(text: state.profilePhone ?? '');
    _company = TextEditingController(text: state.profileCompany ?? '');
    _role = TextEditingController(text: state.profileRole ?? '');
  }

  @override
  void dispose() {
    _phone.dispose();
    _company.dispose();
    _role.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await context.read<AppState>().saveProfileExtra(
            telefone: _phone.text,
            empresa: _company.text,
            cargo: _role.text,
          );
      // O AuthGate passa a "ready" e entra na HomeShell automaticamente.
    } catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        messenger.showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    final muted = AppColors.navy.withValues(alpha: 0.6);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: _submitted
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.techBlue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(LucideIcons.idCard,
                    color: AppColors.techBlue, size: 26),
              ),
              const SizedBox(height: 16),
              Text(l.completeProfileTitle,
                  style: AppTheme.display(size: 22, color: AppColors.navy)),
              const SizedBox(height: 6),
              Text(l.completeProfileSubtitle,
                  style: TextStyle(fontSize: 13, height: 1.4, color: muted)),
              const SizedBox(height: 4),
              // Nome/email já vêm do Google — mostrados só para contexto.
              if ((state.userName ?? '').isNotEmpty ||
                  (state.userEmail ?? '').isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.userCheck,
                            size: 18, color: AppColors.techBlue),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if ((state.userName ?? '').isNotEmpty)
                                Text(state.userName!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700)),
                              if ((state.userEmail ?? '').isNotEmpty)
                                Text(state.userEmail!,
                                    style:
                                        TextStyle(fontSize: 12, color: muted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              _Field(
                controller: _phone,
                label: l.profileFieldPhone,
                icon: LucideIcons.phone,
                keyboardType: TextInputType.phone,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? l.signupValidationRequired
                    : null,
              ),
              const SizedBox(height: 14),
              _Field(
                controller: _company,
                label: l.profileFieldCompany,
                icon: LucideIcons.building2,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? l.signupValidationRequired
                    : null,
              ),
              const SizedBox(height: 14),
              _Field(
                controller: _role,
                label: l.profileFieldRole,
                icon: LucideIcons.briefcase,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? l.signupValidationRequired
                    : null,
              ),
              const SizedBox(height: 22),
              FilledButton(
                onPressed: _busy ? null : _submit,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
                child: _busy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : Text(l.qaSave),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: _busy
                      ? null
                      : () => context.read<AppState>().dismissProfilePrompt(),
                  child: Text(l.profileSaveLater),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon,
            size: 18, color: AppColors.navy.withValues(alpha: 0.55)),
        filled: true,
        fillColor: AppColors.bg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.techBlue, width: 1.5),
        ),
      ),
    );
  }
}
