import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:animations/animations.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:async';

class PortfolioProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  set selectedIndex(int value) {
    if (_selectedIndex != value) {
      _selectedIndex = value;
      notifyListeners();
    }
  }

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }

  final List<Map<String, dynamic>> projects = [
    {
      'title': 'E-Commerce App',
      'description':
          'A full-featured e-commerce mobile application with payment integration, user authentication, and real-time inventory management.',
      'technologies': ['Flutter', 'Firebase', 'Stripe'],
      'icon': Icons.shopping_cart,
    },
    {
      'title': 'Task Manager',
      'description':
          'A productivity app for managing tasks and projects with team collaboration features and progress tracking.',
      'technologies': ['Flutter', 'Node.js', 'MongoDB'],
      'icon': Icons.task_alt,
    },
    {
      'title': 'Weather App',
      'description':
          'A beautiful weather application with location-based forecasts, hourly updates, and weather alerts.',
      'technologies': ['Flutter', 'OpenWeather API'],
      'icon': Icons.wb_sunny,
    },
    {
      'title': 'Fitness Tracker',
      'description':
          'A comprehensive fitness tracking app with workout plans, progress monitoring, and social features.',
      'technologies': ['Flutter', 'Firebase', 'Health Kit'],
      'icon': Icons.fitness_center,
    },
  ];
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PortfolioProvider(),
      child: const PortfolioApp(),
    ),
  );
}

class AnimatedIntroScreen extends StatefulWidget {
  const AnimatedIntroScreen({super.key, required this.onFinish});
  final VoidCallback onFinish;

  @override
  State<AnimatedIntroScreen> createState() => _AnimatedIntroScreenState();
}

class _AnimatedIntroScreenState extends State<AnimatedIntroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _rotationAnim;

  // For animated gradient
  late Timer _timer;
  int _gradientIndex = 0;
  final List<List<Color>> _gradients = [
    [Color(0xFF232526), Color(0xFF39FF14), Color(0xFF232526)],
    [Color(0xFF232526), Color(0xFF6366F1), Color(0xFF232526)],
    [Color(0xFF232526), Color(0xFF39FF14), Color(0xFF6366F1)],
    [Color(0xFF232526), Color(0xFF39FF14), Color(0xFF232526)],
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _scaleAnim = Tween<double>(
      begin: 0.8,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _rotationAnim = Tween<double>(
      begin: -0.08,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();
    Future.delayed(const Duration(seconds: 2), widget.onFinish);
    _timer = Timer.periodic(const Duration(milliseconds: 2500), (timer) {
      setState(() {
        _gradientIndex = (_gradientIndex + 1) % _gradients.length;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 1600),
        curve: Curves.easeInOut,
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: ScaleTransition(
              scale: _scaleAnim,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _rotationAnim,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationAnim.value,
                        child: child,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.secondary.withOpacity(0.1),
                            blurRadius: 60,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.flutter_dash,
                        size: 72,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Pulsing neon dot accent
                  // TweenAnimationBuilder<double>(
                  //   tween: Tween(begin: 0.7, end: 1.0),
                  //   duration: const Duration(milliseconds: 900),
                  //   curve: Curves.easeInOut,
                  //   builder: (context, value, child) {
                  //     return Opacity(
                  //       opacity: value,
                  //       child: Container(
                  //         width: 14 * value,
                  //         height: 14 * value,
                  //         decoration: BoxDecoration(
                  //           color: theme.colorScheme.secondary,
                  //           shape: BoxShape.circle,
                  //           boxShadow: [
                  //             BoxShadow(
                  //               color: theme.colorScheme.secondary.withOpacity(
                  //                 0.5,
                  //               ),
                  //               blurRadius: 12,
                  //               spreadRadius: 1,
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     );
                  //   },
                  //   onEnd: () {
                  //     setState(() {}); // Loop the animation
                  //   },
                  // ),
                  const SizedBox(height: 24),
                  AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                        'Welcome to My Portfolio',
                        textStyle: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: theme.colorScheme.secondary.withOpacity(
                                0.2,
                              ),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        speed: const Duration(milliseconds: 60),
                      ),
                    ],
                    isRepeatingAnimation: false,
                    totalRepeatCount: 1,
                    pause: const Duration(milliseconds: 400),
                    displayFullTextOnTap: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  bool _showIntro = true;

  void _finishIntro() {
    setState(() {
      _showIntro = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PortfolioProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Portfolio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
          surface: Color(0xFFF8F9FA),
        ),
        useMaterial3: true,
        fontFamily: 'Poppins',
        textTheme: TextTheme(
          displayLarge: TextStyle(fontFamily: 'BoldFont'),
          displayMedium: TextStyle(fontFamily: 'BoldFont'),
          displaySmall: TextStyle(fontFamily: 'BoldFont'),
          headlineLarge: TextStyle(fontFamily: 'BoldFont'),
          headlineMedium: TextStyle(fontFamily: 'BoldFont'),
          headlineSmall: TextStyle(fontFamily: 'BoldFont'),
          titleLarge: TextStyle(fontFamily: 'BoldFont'),
          titleMedium: TextStyle(fontFamily: 'BoldFont'),
          titleSmall: TextStyle(fontFamily: 'BoldFont'),
          bodyLarge: TextStyle(fontFamily: 'SubFont'),
          bodyMedium: TextStyle(fontFamily: 'SubFont'),
          bodySmall: TextStyle(fontFamily: 'SubFont'),
          labelLarge: TextStyle(fontFamily: 'SubFont'),
          labelMedium: TextStyle(fontFamily: 'SubFont'),
          labelSmall: TextStyle(fontFamily: 'SubFont'),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        cardColor: Color(0xFF181A20),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF39FF14), // neon green
          brightness: Brightness.dark,
          secondary: Color(0xFF39FF14), // neon green accent
          onPrimary: Colors.white,
          onSurface: Colors.white,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          // ...other text styles
        ),
        useMaterial3: true,
        fontFamily: 'SubFont',
      ),
      themeMode: provider.themeMode,
      home: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 900),
        transitionBuilder: (child, animation, secondaryAnimation) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
        child:
            _showIntro
                ? AnimatedIntroScreen(
                  key: const ValueKey('intro'),
                  onFinish: _finishIntro,
                )
                : PortfolioHomePage(key: const ValueKey('home')),
      ),
    );
  }
}

class PortfolioHomePage extends StatelessWidget {
  PortfolioHomePage({super.key});

  final List<Widget> _pages = [
    HomeSection(),
    AboutSection(),
    SkillsSection(),
    ProjectsSection(),
    ContactSection(),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PortfolioProvider>(context);
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile: AppBar + BottomNavigationBar only
            return Scaffold(
              appBar: AppBar(
                title: const Text('My Portfolio'),
                backgroundColor: Theme.of(context).colorScheme.surface,
                foregroundColor: Theme.of(context).colorScheme.onSurface,
                actions: [_ThemeModeButton()],
              ),
              body: PageTransitionSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation, secondaryAnimation) {
                  return FadeThroughTransition(
                    animation: animation,
                    secondaryAnimation: secondaryAnimation,
                    child: child,
                  );
                },
                child: _pages[provider.selectedIndex],
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: provider.selectedIndex,
                onTap: (index) => provider.selectedIndex = index,
                backgroundColor: Theme.of(context).colorScheme.surface,
                selectedItemColor: Theme.of(context).colorScheme.secondary,
                unselectedItemColor: Theme.of(
                  context,
                ).colorScheme.onSurface.withOpacity(0.7),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'About',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.psychology),
                    label: 'Skills',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.work),
                    label: 'Projects',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.mail),
                    label: 'Contact',
                  ),
                ],
              ),
            );
          }
          // Tablet/Desktop: Top navigation bar
          return Column(
            children: [
              Container(
                color: Theme.of(context).colorScheme.surface,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _NavBarItem(
                      icon:
                          provider.selectedIndex == 0
                              ? Icons.home
                              : Icons.home_outlined,
                      label: 'Home',
                      selected: provider.selectedIndex == 0,
                      onTap: () => provider.selectedIndex = 0,
                    ),
                    const SizedBox(width: 24),
                    _NavBarItem(
                      icon:
                          provider.selectedIndex == 1
                              ? Icons.person
                              : Icons.person_outline,
                      label: 'About',
                      selected: provider.selectedIndex == 1,
                      onTap: () => provider.selectedIndex = 1,
                    ),
                    const SizedBox(width: 24),
                    _NavBarItem(
                      icon:
                          provider.selectedIndex == 2
                              ? Icons.psychology
                              : Icons.psychology_outlined,
                      label: 'Skills',
                      selected: provider.selectedIndex == 2,
                      onTap: () => provider.selectedIndex = 2,
                    ),
                    const SizedBox(width: 24),
                    _NavBarItem(
                      icon:
                          provider.selectedIndex == 3
                              ? Icons.work
                              : Icons.work_outline,
                      label: 'Projects',
                      selected: provider.selectedIndex == 3,
                      onTap: () => provider.selectedIndex = 3,
                    ),
                    const SizedBox(width: 24),
                    _NavBarItem(
                      icon:
                          provider.selectedIndex == 4
                              ? Icons.mail
                              : Icons.mail_outline,
                      label: 'Contact',
                      selected: provider.selectedIndex == 4,
                      onTap: () => provider.selectedIndex = 4,
                    ),
                    const Spacer(),
                    _ThemeModeButton(),
                  ],
                ),
              ),
              Expanded(
                child: PageTransitionSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation, secondaryAnimation) {
                    return FadeThroughTransition(
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      child: child,
                    );
                  },
                  child: _pages[provider.selectedIndex],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class HomeSection extends StatelessWidget {
  const HomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.1),
                Theme.of(context).colorScheme.secondary.withOpacity(0.1),
              ],
            ),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(constraints.maxWidth < 600 ? 16 : 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: constraints.maxWidth < 600 ? 60 : 80,
                    backgroundImage: const AssetImage(
                      'assets/images/profile.png',
                    ),
                  ),
                  SizedBox(height: constraints.maxWidth < 600 ? 24 : 32),
                  Text(
                    'Suos Seyha',
                    style: (constraints.maxWidth < 600
                            ? Theme.of(context).textTheme.headlineLarge
                            : Theme.of(context).textTheme.displayLarge)
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                        'Flutter Developer',
                        textStyle: (constraints.maxWidth < 600
                                ? Theme.of(context).textTheme.titleLarge
                                : Theme.of(context).textTheme.headlineSmall)
                            ?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.7),
                            ),
                        speed: const Duration(milliseconds: 180),
                      ),
                    ],
                    isRepeatingAnimation: false,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Passionate about creating beautiful and functional mobile applications with Flutter',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  const HomeStats(),
                  SizedBox(height: constraints.maxWidth < 600 ? 32 : 48),
                  if (constraints.maxWidth < 600)
                    // Mobile layout - stacked buttons
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final url =
                                  '/Seyha_Suos.pdf'; // For web, this will work if the PDF is in the web/ directory
                              final uri = Uri.parse(url);
                              if (await launcher.canLaunchUrl(uri)) {
                                await launcher.launchUrl(
                                  uri,
                                  mode: launcher.LaunchMode.externalApplication,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Could not open CV'),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.download),
                            label: const Text('Download CV'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Provider.of<PortfolioProvider>(
                                    context,
                                    listen: false,
                                  ).selectedIndex =
                                  4;
                            },
                            icon: const Icon(Icons.mail),
                            label: const Text('Contact Me'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    // Desktop layout - side by side buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            final url =
                                '/Seyha_Suos.pdf'; // For web, this will work if the PDF is in the web/ directory
                            final uri = Uri.parse(url);
                            if (await launcher.canLaunchUrl(uri)) {
                              await launcher.launchUrl(
                                uri,
                                mode: launcher.LaunchMode.externalApplication,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Could not open CV'),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.download),
                          label: const Text('Download CV'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton.icon(
                          onPressed: () {
                            Provider.of<PortfolioProvider>(
                                  context,
                                  listen: false,
                                ).selectedIndex =
                                4;
                          },
                          icon: const Icon(Icons.mail),
                          label: const Text('Contact Me'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class HomeStats extends StatelessWidget {
  const HomeStats({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = [
      {'label': 'YEARS OF EXPERIENCE', 'value': '8', 'icon': Icons.timeline},
      {
        'label': 'SATISFACTION CLIENTS',
        'value': '100%',
        'icon': Icons.emoji_emotions,
      },
      {'label': 'CLIENTS ON WORLDWIDE', 'value': '+80', 'icon': Icons.public},
      {'label': 'PROJECTS DONE', 'value': '675', 'icon': Icons.check_circle},
    ];
    final width = MediaQuery.of(context).size.width;
    double labelFontSize;
    double valueFontSize;
    if (width < 400) {
      labelFontSize = 9;
      valueFontSize = 22;
    } else if (width < 600) {
      labelFontSize = 11;
      valueFontSize = 28;
    } else if (width < 900) {
      labelFontSize = 13;
      valueFontSize = 32;
    } else {
      labelFontSize = 15;
      valueFontSize = 36;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.07)
                      : Colors.white.withOpacity(0.22),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withOpacity(0.18),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 32,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Always use horizontal scrollable row for all screen sizes
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        stats
                            .map(
                              (stat) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 8,
                                ),
                                child: _HoverableStatItem(
                                  stat: stat,
                                  labelFontSize: labelFontSize,
                                  valueFontSize: valueFontSize,
                                ),
                              ),
                            )
                            .toList(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _HoverableStatItem extends StatefulWidget {
  final Map<String, dynamic> stat;
  final double labelFontSize;
  final double valueFontSize;
  const _HoverableStatItem({
    required this.stat,
    required this.labelFontSize,
    required this.valueFontSize,
  });

  @override
  State<_HoverableStatItem> createState() => _HoverableStatItemState();
}

class _HoverableStatItemState extends State<_HoverableStatItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.secondary;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? 1.08 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: BoxDecoration(
            color: _hovering ? accent.withOpacity(0.10) : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            boxShadow:
                _hovering
                    ? [
                      BoxShadow(
                        color: accent.withOpacity(0.0),
                        blurRadius: 18,
                        spreadRadius: 1,
                      ),
                    ]
                    : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow:
                      _hovering
                          ? [
                            BoxShadow(
                              color: accent.withOpacity(0.7),
                              blurRadius: 24,
                              spreadRadius: 2,
                            ),
                          ]
                          : [],
                ),
                child: Icon(
                  widget.stat['icon'],
                  color:
                      _hovering
                          ? accent.withOpacity(0.95)
                          : accent.withOpacity(0.85),
                  size: 32,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.stat['label'],
                style: theme.textTheme.labelMedium?.copyWith(
                  letterSpacing: 2,
                  fontSize: widget.labelFontSize,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  fontFamily: 'SubFont',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                widget.stat['value'],
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: widget.valueFontSize,
                  fontFamily: 'BoldFont',
                  color: theme.colorScheme.onSurface,
                  shadows: [
                    Shadow(color: accent.withOpacity(0.2), blurRadius: 8),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final isTablet = constraints.maxWidth < 900;
        return SingleChildScrollView(
          padding: EdgeInsets.all(
            isMobile
                ? 12
                : isTablet
                ? 24
                : 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About Me',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: isMobile ? 24 : 32,
                ),
              ),
              const SizedBox(height: 32),
              if (isMobile)
                Column(
                  children: [
                    _buildAboutContent(context, isMobile: true),
                    const SizedBox(height: 24),
                    _buildEducationTimeline(context, isMobile: true),
                    const SizedBox(height: 32),
                    _buildWorkExperienceTimeline(context, isMobile: true),
                  ],
                )
              else if (isTablet)
                Column(
                  children: [
                    _buildAboutContent(context, isMobile: false),
                    const SizedBox(height: 24),
                    _buildEducationTimeline(context, isMobile: false),
                    const SizedBox(height: 32),
                    _buildWorkExperienceTimeline(context, isMobile: false),
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildAboutContent(context, isMobile: false),
                    ),
                    const SizedBox(width: 48),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildEducationTimeline(context, isMobile: false),
                          const SizedBox(height: 32),
                          _buildWorkExperienceTimeline(
                            context,
                            isMobile: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAboutContent(BuildContext context, {bool isMobile = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Who I Am',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          'I am a passionate Flutter developer with over 3 years of experience in mobile app development. '
          'I love creating intuitive and beautiful user interfaces that provide exceptional user experiences. '
          'My journey in software development started with web development, and I transitioned to mobile '
          'development when I discovered Flutter\'s power and flexibility.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        Text(
          'What I Do',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          'I specialize in building cross-platform mobile applications using Flutter and Dart. '
          'My expertise includes state management, API integration, database design, and UI/UX design. '
          'I also have experience with backend development using Node.js and Firebase.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildEducationTimeline(
    BuildContext context, {
    bool isMobile = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.grey[700],
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            'EDUCATION',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 15 : 18,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _TimelineItem(
          year: '2020 - 2024',
          title: 'BACHELORES DEGREE',
          subtitle: 'Computer science at ',
          highlight: 'Royal University of Phnom Penh',
          isMobile: isMobile,
        ),
        const SizedBox(height: 12),
        _TimelineItem(
          year: '2020 - 2021',
          title: 'STUDY COURSE',
          subtitle:
              'Learn programming language such as C, C++, OOP, Java, MySQL and Flutter at ',
          highlight: 'ETEC CENTER',
          subtitle2: ' and learn more Flutter at ',
          highlight2: 'SALA-IT',
          isMobile: isMobile,
        ),
      ],
    );
  }

  Widget _buildWorkExperienceTimeline(
    BuildContext context, {
    bool isMobile = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.grey[700],
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            'WORK EXPERIENCE',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 15 : 18,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _TimelineItem(
          year: '2021 - 2022',
          title: 'TEACHER CODING',
          subtitle:
              'Teaching programming language such as C, C++, OOP, Java, MySQL and Flutter at ',
          highlight: 'ETEC CENTER',
          duration: '(1 year)',
          isMobile: isMobile,
        ),
        const SizedBox(height: 12),
        _TimelineItem(
          year: '2022 - 2023',
          title: 'FLUTTER GAME DEVELOPMENT',
          subtitle: 'Develop game at ',
          highlight: 'PHOENIX MEDIA',
          duration: '(1 year 7 months)',
          isMobile: isMobile,
        ),
        const SizedBox(height: 12),
        _TimelineItem(
          year: '2023 - 2024',
          title: 'FLUTTER DEVELOPER',
          subtitle: 'Develop ecommerce app at ',
          highlight: 'CODINGATE TECHNOLOGY.',
          duration: '(1 year)',
          isMobile: isMobile,
        ),
        const SizedBox(height: 12),
        _TimelineItem(
          year: '2023 - 2024',
          title: 'OUTSOURCE FLUTTER DEVELOPER',
          subtitle: 'Maintenance BROW Reward App at ',
          highlight: 'BROW COMPANY',
          subtitle2: ' as outsource Flutter Developer of ',
          highlight2: 'CODINGATE TECHNOLOGY.',
          duration: '(3 months)',
          isMobile: isMobile,
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String year;
  final String title;
  final String subtitle;
  final String highlight;
  final String? subtitle2;
  final String? highlight2;
  final String? duration;
  final bool isMobile;
  const _TimelineItem({
    required this.year,
    required this.title,
    required this.subtitle,
    required this.highlight,
    this.subtitle2,
    this.highlight2,
    this.duration,
    this.isMobile = false,
  });
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: Theme.of(context).colorScheme.onSurface,
      fontSize: isMobile ? 13 : null,
    );
    final titleStyle = TextStyle(
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
      fontSize: isMobile ? 14 : 16,
    );
    final yearStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: isMobile ? 13 : 15,
    );
    final durationStyle = TextStyle(
      fontSize: isMobile ? 11 : 13,
      color: Colors.grey,
    );
    if (isMobile) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(year, style: yearStyle),
            const SizedBox(height: 2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.circle, size: 8, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(title, style: titleStyle),
                          if (duration != null) ...[
                            const SizedBox(width: 6),
                            Text(duration!, style: durationStyle),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      RichText(
                        text: TextSpan(
                          style: textStyle,
                          children: [
                            TextSpan(text: subtitle),
                            TextSpan(
                              text: highlight,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (subtitle2 != null && highlight2 != null) ...[
                              TextSpan(text: subtitle2),
                              TextSpan(
                                text: highlight2,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 90, child: Text(year, style: yearStyle)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  runSpacing: 2,
                  children: [
                    Icon(Icons.circle, size: 10, color: Colors.grey),
                    Text(title, style: titleStyle),
                    if (duration != null) Text(duration!, style: durationStyle),
                  ],
                ),
                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    style: textStyle,
                    children: [
                      TextSpan(text: subtitle),
                      TextSpan(
                        text: highlight,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (subtitle2 != null && highlight2 != null) ...[
                        TextSpan(text: subtitle2),
                        TextSpan(
                          text: highlight2,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(constraints.maxWidth < 600 ? 16 : 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Skills & Expertise',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 32),
              if (constraints.maxWidth < 900)
                // Mobile/Tablet layout
                Column(
                  children: [
                    _buildSkillCategory(context, 'Programming Languages', [
                      {'name': 'Dart', 'level': 0.95},
                      {'name': 'JavaScript', 'level': 0.85},
                      {'name': 'Python', 'level': 0.75},
                      {'name': 'Java', 'level': 0.70},
                    ]),
                    const SizedBox(height: 24),
                    _buildSkillCategory(context, 'Frameworks & Tools', [
                      {'name': 'Flutter', 'level': 0.95},
                      {'name': 'React Native', 'level': 0.80},
                      {'name': 'Node.js', 'level': 0.85},
                      {'name': 'Firebase', 'level': 0.90},
                    ]),
                  ],
                )
              else
                // Desktop layout
                Row(
                  children: [
                    Expanded(
                      child: _buildSkillCategory(
                        context,
                        'Programming Languages',
                        [
                          {'name': 'Dart', 'level': 0.95},
                          {'name': 'JavaScript', 'level': 0.85},
                          {'name': 'Python', 'level': 0.75},
                          {'name': 'Java', 'level': 0.70},
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: _buildSkillCategory(
                        context,
                        'Frameworks & Tools',
                        [
                          {'name': 'Flutter', 'level': 0.95},
                          {'name': 'React Native', 'level': 0.80},
                          {'name': 'Node.js', 'level': 0.85},
                          {'name': 'Firebase', 'level': 0.90},
                        ],
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 32),
              Text(
                'Other Skills',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    [
                          'UI/UX Design',
                          'RESTful APIs',
                          'Git & GitHub',
                          'Agile/Scrum',
                          'Database Design',
                          'Cloud Services',
                          'Testing',
                          'CI/CD',
                        ]
                        .map(
                          (skill) => Chip(
                            label: Text(skill),
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                        )
                        .toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSkillCategory(
    BuildContext context,
    String title,
    List<Map<String, dynamic>> skills,
  ) {
    return _HoverableSkillCard(title: title, skills: skills);
  }

  Widget _buildSkillBar(BuildContext context, String skill, double level) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(skill), Text('${(level * 100).toInt()}%')],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: level,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectsSection extends StatelessWidget {
  ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PortfolioProvider>(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(constraints.maxWidth < 600 ? 16 : 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Projects',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 32),
              if (constraints.maxWidth < 600)
                // Mobile layout - single column
                Column(
                  children:
                      provider.projects
                          .map(
                            (project) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: ProjectCard(
                                project: project,
                                maxWidth: constraints.maxWidth,
                              ),
                            ),
                          )
                          .toList(),
                )
              else
                // Tablet and Desktop layout - grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _getCrossAxisCount(constraints.maxWidth),
                    crossAxisSpacing: constraints.maxWidth < 900 ? 20 : 24,
                    mainAxisSpacing: constraints.maxWidth < 900 ? 20 : 24,
                    childAspectRatio: _getChildAspectRatio(
                      constraints.maxWidth,
                    ),
                  ),
                  itemCount: provider.projects.length,
                  itemBuilder: (context, index) {
                    final project = provider.projects[index];
                    return ProjectCard(
                      project: project,
                      maxWidth: constraints.maxWidth,
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  // Update grid aspect ratio for more vertical space
  int _getCrossAxisCount(double width) {
    if (width < 900) return 2; // Tablet
    if (width < 1200) return 2; // Medium desktop
    return 3; // Large desktop
  }

  double _getChildAspectRatio(double width) {
    if (width < 900) return 0.95; // Tablet - more vertical space
    if (width < 1200) return 1.05; // Medium desktop
    return 1.1; // Large desktop
  }

  Widget _buildProjectCard(BuildContext context, Map<String, dynamic> project) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          elevation: 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // Remove fixed height for better flexibility
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Icon(
                    project['icon'],
                    size: constraints.maxWidth < 600 ? 36 : 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(constraints.maxWidth < 600 ? 12 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project['title'],
                      style: (constraints.maxWidth < 600
                              ? Theme.of(context).textTheme.titleMedium
                              : Theme.of(context).textTheme.titleLarge)
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      project['description'],
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: constraints.maxWidth < 600 ? 4 : 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children:
                          (project['technologies'] as List<String>)
                              .map(
                                (tech) => Chip(
                                  label: Text(
                                    tech,
                                    style: TextStyle(
                                      fontSize:
                                          constraints.maxWidth < 600 ? 10 : 12,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        constraints.maxWidth < 600 ? 6 : 8,
                                    vertical:
                                        constraints.maxWidth < 600 ? 2 : 4,
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProjectCard extends StatefulWidget {
  final Map<String, dynamic> project;
  final double maxWidth;
  const ProjectCard({Key? key, required this.project, required this.maxWidth})
    : super(key: key);

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? 1.04 : 1.0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        child: Card(
          elevation: _hovering ? 12 : 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Icon(
                    widget.project['icon'],
                    size: widget.maxWidth < 600 ? 36 : 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(widget.maxWidth < 600 ? 12 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.project['title'],
                      style: (widget.maxWidth < 600
                              ? Theme.of(context).textTheme.titleMedium
                              : Theme.of(context).textTheme.titleLarge)
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.project['description'],
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: widget.maxWidth < 600 ? 4 : 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children:
                          (widget.project['technologies'] as List<String>)
                              .map(
                                (tech) => Chip(
                                  label: Text(
                                    tech,
                                    style: TextStyle(
                                      fontSize: widget.maxWidth < 600 ? 10 : 12,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: widget.maxWidth < 600 ? 6 : 8,
                                    vertical: widget.maxWidth < 600 ? 2 : 4,
                                  ),
                                ),
                              )
                              .toList(),
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
}

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(constraints.maxWidth < 600 ? 16 : 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Get In Touch',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 32),
              if (constraints.maxWidth < 900)
                // Mobile/Tablet layout
                Column(
                  children: [
                    _buildContactInfo(context),
                    const SizedBox(height: 32),
                    _buildContactForm(context),
                  ],
                )
              else
                // Desktop layout
                Row(
                  children: [
                    Expanded(child: _buildContactInfo(context)),
                    const SizedBox(width: 48),
                    Expanded(child: _buildContactForm(context)),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Information',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        _buildContactItem(
          context,
          Icons.email,
          'Email',
          'seyhasuos1202@gmail.com',
        ),
        _buildContactItem(
          context,
          Icons.location_on,
          'Location',
          'Street Betong, Sangkat Tuek Thla, Khan Sen Sok, Phnom Penh, Cambodia',
        ),
        const SizedBox(height: 32),
        Text(
          'Follow Me',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildSocialButton(
              context,
              Icons.ondemand_video,
              'YouTube',
              'https://www.youtube.com/@suos_seyha',
            ),
            _buildSocialButton(
              context,
              Icons.code,
              'GitHub',
              'https://github.com/SuosSeyha?tab=repositories',
            ),
            _buildSocialButton(
              context,
              Icons.storage,
              'GitLab',
              'https://gitlab.com/seyhasuos',
            ),
            _buildSocialButton(
              context,
              Icons.telegram,
              'Telegram',
              'https://t.me/seyha_app',
            ),
            _buildSocialButton(
              context,
              Icons.facebook,
              'Facebook',
              'https://www.facebook.com/suos.seyha.2025',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactForm(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send Message',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Open email client with pre-filled message
                  final Uri emailUri = Uri(
                    scheme: 'mailto',
                    path: 'seyhasuos1202@gmail.com',
                    query:
                        'subject=Portfolio Contact&body=Hello Suos Seyha,%0D%0A%0D%0AI would like to get in touch with you regarding your portfolio.%0D%0A%0D%0ABest regards,',
                  );

                  if (await launcher.canLaunchUrl(emailUri)) {
                    await launcher.launchUrl(emailUri);
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Opening email client...'),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  } else {
                    // Show error message if email client cannot be opened
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Could not open email client'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Send Message'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(value, softWrap: true, overflow: TextOverflow.visible),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context,
    IconData icon,
    String label, [
    String? url,
  ]) {
    return OutlinedButton.icon(
      onPressed:
          url != null
              ? () async {
                if (await launcher.canLaunchUrl(Uri.parse(url))) {
                  await launcher.launchUrl(
                    Uri.parse(url),
                    mode: launcher.LaunchMode.externalApplication,
                  );
                }
              }
              : null,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Icon(
              icon,
              color:
                  selected
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(
                        context,
                      ).colorScheme.onPrimary.withOpacity(0.7),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color:
                    selected
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(
                          context,
                        ).colorScheme.onPrimary.withOpacity(0.7),
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeModeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PortfolioProvider>(context);
    return PopupMenuButton<ThemeMode>(
      tooltip: 'Theme Mode',
      icon: Icon(
        provider.themeMode == ThemeMode.light
            ? Icons.light_mode
            : provider.themeMode == ThemeMode.dark
            ? Icons.dark_mode
            : Icons.brightness_auto,
        color: Theme.of(context).iconTheme.color,
      ),
      onSelected: (mode) => provider.themeMode = mode,
      itemBuilder:
          (context) => [
            PopupMenuItem(
              value: ThemeMode.system,
              child: Row(
                children: const [
                  Icon(Icons.brightness_auto),
                  SizedBox(width: 8),
                  Text('System'),
                ],
              ),
            ),
            PopupMenuItem(
              value: ThemeMode.light,
              child: Row(
                children: const [
                  Icon(Icons.light_mode),
                  SizedBox(width: 8),
                  Text('Light'),
                ],
              ),
            ),
            PopupMenuItem(
              value: ThemeMode.dark,
              child: Row(
                children: const [
                  Icon(Icons.dark_mode),
                  SizedBox(width: 8),
                  Text('Dark'),
                ],
              ),
            ),
          ],
    );
  }
}

Widget blurredCard({
  required Widget child,
  double blur = 16,
  double opacity = 0.2,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(24),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(opacity), // Adjust for dark mode
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: child,
      ),
    ),
  );
}

Widget blurredButton({required String label, required VoidCallback onPressed}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.2),
          foregroundColor: Colors.black,
          shadowColor: Colors.transparent,
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    ),
  );
}

class _HoverableSkillCard extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> skills;
  const _HoverableSkillCard({
    Key? key,
    required this.title,
    required this.skills,
  }) : super(key: key);

  @override
  State<_HoverableSkillCard> createState() => _HoverableSkillCardState();
}

class _HoverableSkillCardState extends State<_HoverableSkillCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? 1.04 : 1.0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        child: Card(
          elevation: _hovering ? 12 : 4,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...widget.skills.map(
                  (skill) => SkillsSection()._buildSkillBar(
                    context,
                    skill['name'],
                    skill['level'],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
