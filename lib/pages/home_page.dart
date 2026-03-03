import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _idx = 0;

  static const _navItems = [
    (icon: Icons.home_outlined, active: Icons.home_rounded, label: 'Home'),
    (icon: Icons.explore_outlined, active: Icons.explore_rounded, label: 'Explore'),
    (icon: Icons.assignment_outlined, active: Icons.assignment_rounded, label: 'Tests'),
    (icon: Icons.person_outline, active: Icons.person_rounded, label: 'Profile'),
  ];

  void _openThemeSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) =>
          _ThemeSheet(provider: context.read<ThemeProvider>()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tp = context.watch<ThemeProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(_navItems[_idx].label,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(tp.themeMode == ThemeMode.dark
                ? Icons.dark_mode_rounded
                : Icons.light_mode_rounded),
            onPressed: tp.toggleTheme,
            tooltip: 'Toggle theme',
          ),
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            onPressed: _openThemeSheet,
            tooltip: 'Color theme',
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginPage())),
          ),
        ],
      ),
      body: IndexedStack(
        index: _idx,
        children: const [
          _HomeTab(),
          _Placeholder(Icons.explore_rounded, 'Explore',
              'Discover courses, subjects, and study materials'),
          _Placeholder(Icons.assignment_rounded, 'Mock Tests',
              'Take practice tests and track your performance'),
          _Placeholder(Icons.person_rounded, 'Profile',
              'Manage your account and preferences'),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _idx,
        onDestinationSelected: (i) => setState(() => _idx = i),
        destinations: _navItems
            .map((n) => NavigationDestination(
                icon: Icon(n.icon),
                selectedIcon: Icon(n.active),
                label: n.label))
            .toList(),
      ),
    );
  }
}

// ── Home Tab ────────────────────────────────────────────────────────────────

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  static const _courses = [
    (subject: 'Mathematics', topic: 'Calculus & Integration', progress: 0.65, icon: Icons.calculate_rounded),
    (subject: 'Physics', topic: 'Thermodynamics', progress: 0.40, icon: Icons.science_rounded),
    (subject: 'Chemistry', topic: 'Organic Chemistry', progress: 0.20, icon: Icons.biotech_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome card
          Card(
            color: cs.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good morning! 👋',
                          style: tt.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: cs.onPrimaryContainer)),
                      const SizedBox(height: 4),
                      Text('Ready to continue learning?',
                          style: tt.bodyMedium?.copyWith(
                              color: cs.onPrimaryContainer
                                  .withOpacity(0.8))),
                    ],
                  ),
                ),
                Icon(Icons.school_rounded,
                    size: 48, color: cs.onPrimaryContainer),
              ]),
            ),
          ),
          const SizedBox(height: 24),
          Text('Quick Stats',
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
                child: _StatCard(Icons.check_circle_outline, '12',
                    'Tests Done', cs.secondaryContainer, cs.onSecondaryContainer)),
            const SizedBox(width: 12),
            Expanded(
                child: _StatCard(Icons.stars_rounded, '84%', 'Avg Score',
                    cs.tertiaryContainer, cs.onTertiaryContainer)),
            const SizedBox(width: 12),
            Expanded(
                child: _StatCard(Icons.local_fire_department_rounded, '7',
                    'Day Streak', cs.errorContainer, cs.onErrorContainer)),
          ]),
          const SizedBox(height: 24),
          Text('Continue Learning',
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ..._courses.map((c) => _CourseCard(
              subject: c.subject,
              topic: c.topic,
              progress: c.progress,
              icon: c.icon)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value, label;
  final Color bg, fg;
  const _StatCard(this.icon, this.value, this.label, this.bg, this.fg);

  @override
  Widget build(BuildContext context) => Card(
        color: bg,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(children: [
            Icon(icon, color: fg, size: 20),
            const SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: fg)),
            Text(label,
                style:
                    TextStyle(fontSize: 11, color: fg.withOpacity(0.8))),
          ]),
        ),
      );
}

class _CourseCard extends StatelessWidget {
  final String subject, topic;
  final double progress;
  final IconData icon;
  const _CourseCard(
      {required this.subject,
      required this.topic,
      required this.progress,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cs.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: cs.onSecondaryContainer),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject,
                    style: tt.labelSmall?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.bold)),
                Text(topic,
                    style: tt.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                    value: progress,
                    borderRadius: BorderRadius.circular(4)),
                const SizedBox(height: 2),
                Text('${(progress * 100).toInt()}% complete',
                    style: tt.labelSmall
                        ?.copyWith(color: cs.onSurfaceVariant)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded,
              color: cs.onSurfaceVariant),
        ]),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final IconData icon;
  final String title, description;
  const _Placeholder(this.icon, this.title, this.description);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: cs.surfaceContainerHighest, shape: BoxShape.circle),
            child: Icon(icon, size: 56, color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          Text(title,
              style:
                  tt.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(description,
                style: tt.bodyMedium
                    ?.copyWith(color: cs.onSurfaceVariant),
                textAlign: TextAlign.center),
          ),
          const SizedBox(height: 24),
          FilledButton.tonal(
              onPressed: () {}, child: const Text('Coming Soon')),
        ],
      ),
    );
  }
}

// ── Theme Bottom Sheet ───────────────────────────────────────────────────────

class _ThemeSheet extends StatefulWidget {
  final ThemeProvider provider;
  const _ThemeSheet({required this.provider});
  @override
  State<_ThemeSheet> createState() => _ThemeSheetState();
}

class _ThemeSheetState extends State<_ThemeSheet> {
  late Color _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.provider.seedColor;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 20),
          Text('Theme Settings',
              style: tt.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          // Appearance mode
          Text('Appearance',
              style: tt.labelLarge?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(
                  value: ThemeMode.light,
                  icon: Icon(Icons.light_mode_rounded),
                  label: Text('Light')),
              ButtonSegment(
                  value: ThemeMode.system,
                  icon: Icon(Icons.brightness_auto_rounded),
                  label: Text('System')),
              ButtonSegment(
                  value: ThemeMode.dark,
                  icon: Icon(Icons.dark_mode_rounded),
                  label: Text('Dark')),
            ],
            selected: {widget.provider.themeMode},
            onSelectionChanged: (s) {
              widget.provider.setThemeMode(s.first);
              setState(() {});
            },
          ),
          const SizedBox(height: 24),
          // Seed color picker
          Text('Seed Color',
              style: tt.labelLarge?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: ThemeProvider.presetColors.map((preset) {
              final active = _selected.value == preset.color.value;
              return Tooltip(
                message: preset.name,
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selected = preset.color);
                    widget.provider.setSeedColor(preset.color);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: preset.color,
                      shape: BoxShape.circle,
                      border: active
                          ? Border.all(color: cs.outline, width: 3)
                          : null,
                      boxShadow: active
                          ? [
                              BoxShadow(
                                color: preset.color.withOpacity(0.45),
                                blurRadius: 8,
                                spreadRadius: 2,
                              )
                            ]
                          : null,
                    ),
                    child: active
                        ? const Icon(Icons.check,
                            color: Colors.white, size: 20)
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          // Current color hex preview
          Row(children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  color: _selected, shape: BoxShape.circle),
            ),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Seed Color',
                  style: tt.bodySmall
                      ?.copyWith(color: cs.onSurfaceVariant)),
              Text(
                '#${_selected.value.toRadixString(16).substring(2).toUpperCase()}',
                style: tt.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace'),
              ),
            ]),
          ]),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
