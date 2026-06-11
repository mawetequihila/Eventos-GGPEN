import 'package:flutter/material.dart';
import 'package:ggpen_angotic/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import 'signup_screen.dart';

/// Início de sessão com email + palavra-passe (conta real no Supabase).
class LoginEmailScreen extends StatefulWidget {
  const LoginEmailScreen({super.key});

  @override
  State<LoginEmailScreen> createState() => _LoginEmailScreenState();
}

class _LoginEmailScreenState extends State<LoginEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _submitted = false;
  bool _busy = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  String? _emailValidator(String? v, AppLocalizations l) {
    if (v == null || v.trim().isEmpty) return l.signupValidationRequired;
    final r = RegExp(r'^[\w.\-+]+@[\w\-]+\.[\w.\-]+$');
    if (!r.hasMatch(v.trim())) return l.signupValidationEmail;
    return null;
  }

  Future<void> _submit() async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    setState(() => _submitted = true);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _busy = true);
    try {
      await context
          .read<AppState>()
          .loginWithEmail(email: _email.text, password: _password.text);
      if (!mounted) return;
      navigator.popUntil((r) => r.isFirst); // AuthGate mostra a app
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(_msg(e, l))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _forgot() async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final email = _email.text.trim();
    if (_emailValidator(email, l) != null) {
      setState(() => _submitted = true);
      messenger.showSnackBar(SnackBar(content: Text(l.signupValidationEmail)));
      return;
    }
    try {
      await context.read<AppState>().sendPasswordReset(email);
      messenger.showSnackBar(SnackBar(content: Text(l.passwordResetSent)));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(_msg(e, l))));
    }
  }

  String _msg(Object e, AppLocalizations l) {
    final s = e.toString();
    return s.contains('AuthException') || s.length > 120
        ? l.authGenericError
        : s.replaceFirst('Exception: ', '');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final muted = AppColors.navy.withValues(alpha: 0.6);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.navy,
        elevation: 0,
        title: Text(l.loginTitle),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: _submitted
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.techBlue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(LucideIcons.logIn,
                    color: AppColors.techBlue, size: 26),
              ),
              const SizedBox(height: 16),
              Text(l.loginTitle,
                  style: AppTheme.display(size: 22, color: AppColors.navy)),
              const SizedBox(height: 6),
              Text(l.loginSubtitle,
                  style: TextStyle(fontSize: 13, height: 1.4, color: muted)),
              const SizedBox(height: 22),
              _Field(
                controller: _email,
                label: l.signupEmailLabel,
                icon: LucideIcons.mail,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => _emailValidator(v, l),
              ),
              const SizedBox(height: 14),
              _Field(
                controller: _password,
                label: l.passwordLabel,
                icon: LucideIcons.lock,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                validator: (v) =>
                    (v == null || v.isEmpty) ? l.signupValidationRequired : null,
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: _busy ? null : _forgot,
                  child: Text(l.forgotPassword),
                ),
              ),
              const SizedBox(height: 6),
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
                    : Text(l.loginSubmit),
              ),
              const SizedBox(height: 14),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(l.loginNoAccount,
                      style: TextStyle(fontSize: 13, color: muted)),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const SignupScreen()),
                    ),
                    child: Text(l.loginCreateLink,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.techBlue)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Campo reutilizável (igual ao do signup, mas local a este ecrã).
class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final bool obscureText;

  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon:
            Icon(icon, size: 18, color: AppColors.navy.withValues(alpha: 0.55)),
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE53935)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE53935), width: 1.5),
        ),
      ),
    );
  }
}
