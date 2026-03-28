import 'package:flutter/material.dart';
import 'signup_page.dart';
import 'forgot_password_page.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  String? _emailError;
  String? _passError;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  bool _validate() {
    String? emailErr;
    String? passErr;

    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;

    if (email.isEmpty) {
      emailErr = 'Enter your email';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      emailErr = 'Enter a valid email';
    }

    if (pass.isEmpty) {
      passErr = 'Enter your password';
    } else if (pass.length < 6) {
      passErr = 'Password must be at least 6 characters';
    }

    setState(() {
      _emailError = emailErr;
      _passError = passErr;
    });

    return emailErr == null && passErr == null;
  }

  Future<void> _submit() async {
    if (!_validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.surface,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text('Welcome back',
                  style:
                      tt.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Sign in to continue your journey',
                  style: tt.bodyLarge?.copyWith(color: cs.onSurfaceVariant)),
              const SizedBox(height: 40),

              // ── Email ──────────────────────────────────────────────────
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onChanged: (_) {
                  if (_emailError != null) setState(() => _emailError = null);
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  isDense: true,
                  hintText: 'you@example.com',
                  prefixIcon: const Icon(Icons.email_outlined),
                  errorText: _emailError,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50)),
                ),
              ),
              const SizedBox(height: 16),

              // ── Password ───────────────────────────────────────────────
              TextField(
                controller: _passCtrl,
                obscureText: _obscure,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                onChanged: (_) {
                  if (_passError != null) setState(() => _passError = null);
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: '••••••••',
                  isDense: true,
                  prefixIcon: const Icon(Icons.lock_outline),
                  errorText: _passError,
                  suffixIcon: IconButton(
                    icon: Icon(_obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50)),
                ),
              ),

              // ── Forgot Password ────────────────────────────────────────
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ForgotPasswordPage())),
                  child: const Text('Forgot password?'),
                ),
              ),
              const SizedBox(height: 8),

              // ── Sign In Button ─────────────────────────────────────────
              FilledButton(
                onPressed: _loading ? null : _submit,
                style: FilledButton.styleFrom(
                  elevation: 8, // Adds the shadow
                  shadowColor: cs.primary.withOpacity(0.5), // Colors the shadow
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                ),
                child: _loading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2.5))
                    : const Text('Sign In',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),

              // ── Divider ────────────────────────────────────────────────
              Row(children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('or',
                      style:
                          tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
                ),
                const Expanded(child: Divider()),
              ]),
              const SizedBox(height: 16),

              // ── Create Account ─────────────────────────────────────────
              OutlinedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SignupPage())),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                ),
                child: const Text('Create an Account',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
