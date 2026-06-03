import 'package:flutter/material.dart';
import 'package:ggpen_angotic/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../widgets/legal.dart';

/// Inscrição manual: nome, email, telefone, empresa, cargo + termos.
/// Persistido apenas localmente (SharedPreferences) via [AppState.signUpLocal].
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _company = TextEditingController();
  final _role = TextEditingController();
  bool _acceptedTerms = false;
  bool _submitted = false;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _company.dispose();
    _role.dispose();
    super.dispose();
  }

  String? _required(String? v, AppLocalizations l) =>
      (v == null || v.trim().isEmpty) ? l.signupValidationRequired : null;

  String? _emailValidator(String? v, AppLocalizations l) {
    final req = _required(v, l);
    if (req != null) return req;
    final r = RegExp(r'^[\w.\-+]+@[\w\-]+\.[\w.\-]+$');
    if (!r.hasMatch(v!.trim())) return l.signupValidationEmail;
    return null;
  }

  Future<void> _submit() async {
    final l = AppLocalizations.of(context);
    setState(() => _submitted = true);
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.signupMustAcceptTerms)),
      );
      return;
    }
    setState(() => _busy = true);
    try {
      await context.read<AppState>().signUpLocal(
            name: _name.text,
            email: _email.text,
            phone: _phone.text,
            company: _company.text,
            role: _role.text,
          );
      // Desempilha SignupScreen (e qualquer outra rota empurrada) para
      // expor o AuthGate, que já está pronto a mostrar a HomeShell.
      if (!mounted) return;
      Navigator.of(context).popUntil((r) => r.isFirst);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagem de fundo + véu escuro (mesma linguagem do LoginScreen).
          Image.asset(
            'assets/banners/perfil.jpg',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const DecoratedBox(
              decoration: BoxDecoration(gradient: AppColors.bannerFallback),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.navy.withValues(alpha: 0.55),
                  AppColors.navyDeep.withValues(alpha: 0.95),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header com botão de voltar + título sobre a imagem.
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(LucideIcons.arrowLeft,
                            color: Colors.white, size: 22),
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.signupTitle,
                        style: AppTheme.display(size: 24, color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l.signupHelper,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                // Card branco com o formulário (parece uma "folha" que sobe).
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(28)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x33000000),
                          blurRadius: 24,
                          offset: Offset(0, -6),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: _submitted
                          ? AutovalidateMode.onUserInteraction
                          : AutovalidateMode.disabled,
                      child: ListView(
                        padding:
                            const EdgeInsets.fromLTRB(24, 24, 24, 24),
                        children: [
                          // Handle decorativo no topo da folha.
                          Center(
                            child: Container(
                              width: 36,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppColors.line,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          _Field(
                            controller: _name,
                            label: l.signupNameLabel,
                            icon: LucideIcons.user,
                            validator: (v) => _required(v, l),
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 14),
                          _Field(
                            controller: _email,
                            label: l.signupEmailLabel,
                            icon: LucideIcons.mail,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) => _emailValidator(v, l),
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 14),
                          _Field(
                            controller: _phone,
                            label: l.signupPhoneLabel,
                            icon: LucideIcons.phone,
                            keyboardType: TextInputType.phone,
                            validator: (v) => _required(v, l),
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 14),
                          _Field(
                            controller: _company,
                            label: l.signupCompanyLabel,
                            icon: LucideIcons.building2,
                            validator: (v) => _required(v, l),
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 14),
                          _Field(
                            controller: _role,
                            label: l.signupRoleLabel,
                            icon: LucideIcons.briefcase,
                            validator: (v) => _required(v, l),
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _submit(),
                          ),
                          const SizedBox(height: 20),
                          _TermsCheckbox(
                            value: _acceptedTerms,
                            onChanged: (v) =>
                                setState(() => _acceptedTerms = v ?? false),
                            onTapTerms: () => showTermsDialog(context),
                            onTapPrivacy: () => showPrivacyDialog(context),
                          ),
                          const SizedBox(height: 20),
                          FilledButton(
                            onPressed: _busy ? null : _submit,
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(52),
                              textStyle: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                            child: _busy
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white))
                                : Text(l.signupSubmit),
                          ),
                          const SizedBox(height: 14),
                          // Footer: "Já tens conta? Entrar" — volta ao login.
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                l.signupHaveAccount,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.navy.withValues(alpha: 0.7),
                                ),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).maybePop(),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  minimumSize: const Size(0, 32),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  l.signupSignInLink,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.techBlue,
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
              ],
            ),
          ),
        ],
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE53935)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: Color(0xFFE53935), width: 1.5),
        ),
      ),
    );
  }
}

class _TermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onTapTerms;
  final VoidCallback onTapPrivacy;

  const _TermsCheckbox({
    required this.value,
    required this.onChanged,
    required this.onTapTerms,
    required this.onTapPrivacy,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: SizedBox(
            width: 22,
            height: 22,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => onChanged(!value),
                child: Text(
                  '${l.signupTermsPrefix}${l.signupTermsLink}${l.signupTermsAnd}${l.signupPrivacyLink}${l.signupTermsSuffix}',
                  style: TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      color: AppColors.navy.withValues(alpha: 0.8)),
                ),
                ),
              const SizedBox(height: 2),
              Wrap(
                spacing: 16,
                children: [
                  _LegalLink(label: l.signupTermsLink, onTap: onTapTerms),
                  _LegalLink(label: l.signupPrivacyLink, onTap: onTapPrivacy),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LegalLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _LegalLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 28),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: AppColors.techBlue,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
