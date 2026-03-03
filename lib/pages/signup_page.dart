import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _loading = false;
  bool _accepted = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_accepted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please accept the Terms & Privacy Policy'),
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create account',
                  style: tt.headlineLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Start your learning journey today',
                  style:
                      tt.bodyLarge?.copyWith(color: cs.onSurfaceVariant)),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _field(
                      controller: _nameCtrl,
                      label: 'Full Name',
                      hint: 'John Doe',
                      icon: Icons.person_outline,
                      action: TextInputAction.next,
                      caps: TextCapitalization.words,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'Enter your name';
                        if (v.trim().length < 2)
                          return 'Name must be at least 2 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _field(
                      controller: _emailCtrl,
                      label: 'Email',
                      hint: 'you@example.com',
                      icon: Icons.email_outlined,
                      keyboard: TextInputType.emailAddress,
                      action: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Enter your email';
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v))
                          return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passCtrl,
                      obscureText: _obscurePass,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: '••••••••',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePass
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                          onPressed: () =>
                              setState(() => _obscurePass = !_obscurePass),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return 'Enter a password';
                        if (v.length < 8)
                          return 'Password must be at least 8 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmCtrl,
                      obscureText: _obscureConfirm,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        hintText: '••••••••',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirm
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                          onPressed: () => setState(
                              () => _obscureConfirm = !_obscureConfirm),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return 'Confirm your password';
                        if (v != _passCtrl.text)
                          return 'Passwords do not match';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    // Terms checkbox
                    Row(
                      children: [
                        Checkbox(
                            value: _accepted,
                            onChanged: (v) =>
                                setState(() => _accepted = v ?? false)),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: 'I agree to the ',
                              style: tt.bodyMedium
                                  ?.copyWith(color: cs.onSurfaceVariant),
                              children: [
                                TextSpan(
                                  text: 'Terms of Service',
                                  style: TextStyle(
                                      color: cs.primary,
                                      fontWeight: FontWeight.bold),
                                ),
                                const TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                      color: cs.primary,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _loading ? null : _submit,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2.5))
                          : const Text('Create Account',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account? ',
                            style: tt.bodyMedium
                                ?.copyWith(color: cs.onSurfaceVariant)),
                        TextButton(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                          onPressed: () => Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (_) => const LoginPage())),
                          child: const Text('Sign In'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    TextInputAction action = TextInputAction.next,
    TextCapitalization caps = TextCapitalization.none,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      textInputAction: action,
      textCapitalization: caps,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator,
    );
  }
}
