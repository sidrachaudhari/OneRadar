import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _loading = false;
  bool _sent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _loading = false;
      _sent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton()),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _sent ? _success(cs) : _form(cs),
        ),
      ),
    );
  }

  Widget _form(ColorScheme cs) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: cs.primaryContainer, shape: BoxShape.circle),
          child: Icon(Icons.lock_reset_rounded,
              size: 36, color: cs.onPrimaryContainer),
        ),
        const SizedBox(height: 24),
        Text('Forgot password?',
            style:
                tt.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(
          "No worries! Enter your registered email and we'll send you a reset link.",
          style: tt.bodyLarge
              ?.copyWith(color: cs.onSurfaceVariant, height: 1.5),
        ),
        const SizedBox(height: 32),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'you@example.com',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter your email';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v))
                    return 'Enter a valid email';
                  return null;
                },
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
                    : const Text('Send Reset Link',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, size: 16),
                label: const Text('Back to Sign In'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _success(ColorScheme cs) {
    final tt = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
              color: cs.primaryContainer, shape: BoxShape.circle),
          child: Icon(Icons.mark_email_read_rounded,
              size: 56, color: cs.onPrimaryContainer),
        ),
        const SizedBox(height: 32),
        Text('Check your email',
            style: tt.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        const SizedBox(height: 12),
        Text(
          "We've sent a reset link to\n${_emailCtrl.text}",
          style:
              tt.bodyLarge?.copyWith(color: cs.onSurfaceVariant, height: 1.5),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text('Back to Sign In',
              style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 12),
        TextButton(onPressed: _submit, child: const Text('Resend email')),
      ],
    );
  }
}
