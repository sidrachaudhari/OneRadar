import 'package:flutter/material.dart';
import 'login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _ctrl = PageController();
  int _page = 0;

  static const _slides = [
    (
      icon: Icons.school_rounded,
      title: 'Learn Smarter',
      body:
          'Access thousands of mock tests and study materials crafted to help you excel in every exam.',
    ),
    (
      icon: Icons.groups_rounded,
      title: 'Collaborate Together',
      body:
          'Join study groups, share notes, and track your collective progress in real time.',
    ),
    (
      icon: Icons.trending_up_rounded,
      title: 'Track Your Growth',
      body:
          'Detailed analytics and personalised insights guide you toward your goals every day.',
    ),
  ];

  void _next() {
    if (_page < _slides.length - 1) {
      _ctrl.nextPage(
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      _goLogin();
    }
  }

  void _goLogin() => Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isLast = _page == _slides.length - 1;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                    onPressed: _goLogin, child: const Text('Skip')),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _ctrl,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) => _Slide(data: _slides[i]),
              ),
            ),
            // Animated dot indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _page == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _page == i ? cs.primary : cs.outlineVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: FilledButton(
                onPressed: _next,
                style: FilledButton.styleFrom(
                  elevation: 5,
                  
                ),
                child: Text(
                  isLast ? 'Get Started' : 'Next',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final ({IconData icon, String title, String body}) data;
  const _Slide({required this.data});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 48),
          Text(data.title,
              style: tt.headlineMedium?.copyWith(fontWeight: FontWeight.bold),),
          const SizedBox(height: 16),
          Text(data.body,
              style: tt.bodyLarge
                  ?.copyWith(color: cs.onSurfaceVariant, height: 1.5),),
        ],
      ),
    );
  }
}
