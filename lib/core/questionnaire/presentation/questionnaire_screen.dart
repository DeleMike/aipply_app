import 'package:aipply/core/questionnaire/application/providers.dart';
import 'package:aipply/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aipply/utils/app_colors.dart';
import 'package:aipply/utils/dimensions.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/app_router.dart';
import '../../../widgets/loading_overlay.dart';

class QuestionnaireScreen extends ConsumerStatefulWidget {
  const QuestionnaireScreen({super.key, required this.questions});

  final List<String> questions;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends ConsumerState<QuestionnaireScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late List<TextEditingController> _answerControllers;
  late AnimationController _rotationController;
  late AnimationController _linearController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late int _totalPages;
  int _currentPageIndex = 0;

  late List<String> _allQuestions;
  final List<String> _staticQuestions = [
    "First, what is your full name, email address, and phone number?",
    "Briefly describe your relevant experience. This can be jobs, internships, or key projects. (e.g., 'Senior Dev at AIpply, 2020-2023' or 'Final Year Project: AIpply App').",
    "Finally, what is your educational background and your top skills? (e.g., 'B.S. in Computer Science; Skills: Go, Flutter, SQL')",
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _allQuestions = [..._staticQuestions, ...widget.questions];

    _answerControllers = List.generate(
      _allQuestions.length,
      (index) => TextEditingController(),
    );

    // Total pages = 1 (Intro) + N (Questions) + 1 (Final)
    _totalPages = widget.questions.length + 2;

    _rotationController = AnimationController(
      duration: const Duration(seconds: 16),
      vsync: this,
    )..repeat();

    _linearController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pageController.dispose();
    // Dispose all text controllers
    for (final controller in _answerControllers) {
      controller.dispose();
    }
    _rotationController.dispose();
    _linearController.dispose();

    super.dispose();
  }

  void _nextPage() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<Map<String, String>> _generateDocuments() async {
    final answers = <String, String>{};
    for (int i = 0; i < _allQuestions.length; i++) {
      answers[_allQuestions[i]] = _answerControllers[i].text;
    }

    return await _fakeApiCall();
  }

  Future<Map<String, String>> _fakeApiCall() async {
    await Future.delayed(const Duration(seconds: 2));

    return {
      "cv_html": "<h1>Jane Doe</h1><h2>Work Experience</h2><p>...</p>",
      "cover_letter_html": "<h2>Dear Hiring Manager,</h2><p>...</p>",
    };
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isGeneratingCVAndCoverLetterProvider);

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      Text(
                        _getProgressText(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 24),
                      // progress bar
                      Column(
                        children: [
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 150),
                            switchInCurve: Curves.easeIn,
                            switchOutCurve: Curves.easeOut,

                            child: LinearProgressIndicator(
                              key: ValueKey(_currentPageIndex),
                              value: (_currentPageIndex + 1) / _totalPages,
                              backgroundColor: AppColors.kGray300,
                              color: AppColors.kPrimary,
                              borderRadius: BorderRadius.circular(kSmallRadius),
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),

                      // question section
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          physics:
                              const NeverScrollableScrollPhysics(), // Disable swiping
                          itemCount: _totalPages,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPageIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            // Page 0: Intro
                            if (index == 0) {
                              return _buildIntroPage();
                            }
                            // Page N+1: Final
                            if (index == _totalPages - 1) {
                              return _buildFinalPage();
                            }
                            // Pages 1-N: Questions
                            final questionIndex = index - 1;
                            return _buildQuestionPage(
                              _allQuestions[questionIndex],
                              _answerControllers[questionIndex],
                              questionIndex + 1,
                            );
                          },
                        ),
                      ),

                      if (_currentPageIndex != _totalPages - 1) // Hide on final page
                        _buildNavigationRow(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          LoadingOverlay(
            isLoading: isLoading,
            headerText: 'Preparing your documents',
            descriptionText: 'Structuring your CV and Cover Letter...',
          ),
        ],
      ),
    );
  }

  String _getProgressText() {
    if (_currentPageIndex == 0) {
      return AppLocalizations.of(context)!.letsGetStarted;
    }
    if (_currentPageIndex == _totalPages - 1) {
      return AppLocalizations.of(context)!.allDone;
    }
    return "${AppLocalizations.of(context)!.question} $_currentPageIndex of ${_allQuestions.length}";
  }

  Widget _buildNavigationRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back Button
        TextButton(
          onPressed: _currentPageIndex == 0 ? null : _previousPage,
          child: Text(AppLocalizations.of(context)!.back),
        ),
        // Next Button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.kPrimary,
            foregroundColor: AppColors.kWhite,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          ),
          onPressed: _nextPage,
          child: Text(AppLocalizations.of(context)!.next),
        ),
      ],
    );
  }

  Widget _buildIntroPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.edit_document, size: 80, color: AppColors.kPrimary),
        const SizedBox(height: 24),
        Text(
          AppLocalizations.of(context)!.introDesc1,
          style: Theme.of(context).textTheme.displaySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          AppLocalizations.of(context)!.introDesc2,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildQuestionPage(
    String question,
    TextEditingController controller,
    int questionNumber,
  ) {
    final bool isStaticQuestion = questionNumber <= _staticQuestions.length;
    final String storyHintText =
        "e.g., 'I was tasked with refactoring our Go backend, which I "
        "completed in 3 weeks and improved API speed by 30%.'";

    final String hintText = isStaticQuestion ? "Your answer here..." : storyHintText;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   "${AppLocalizations.of(context)!.question} $questionNumber of ${widget.questions.length}",
          //   style: Theme.of(context).textTheme.labelLarge,
          // ),
          const SizedBox(height: 12),
          SelectableText(question, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          TextFormField(
            controller: controller,
            maxLines: isStaticQuestion ? 5 : 8,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: AppColors.kGray300,
              hintStyle: TextStyle(
                color: AppColors.kGray600.withValues(alpha: 0.7),
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kSmallRadius),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || (value.trim().isEmpty)) {
                return AppLocalizations.of(context)!.errorMessageForQuestionnaire;
              }
              if (!isStaticQuestion &&
                  value.split(' ').where((s) => s.isNotEmpty).length < 25) {
                return AppLocalizations.of(context)!.errorMessageForQuestionnaire2;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFinalPage() {
    final buttonText = AppLocalizations.of(context)!.generateMyDocs;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _rotationController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationController.value * 2 * 3.14159,
              child: child,
            );
          },
          child: Icon(Icons.auto_awesome, size: 80, color: Colors.green[600]),
        ),
        const SizedBox(height: 24),
        Text(
          AppLocalizations.of(context)!.youAreAllSet,
          style: Theme.of(context).textTheme.displaySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          AppLocalizations.of(context)!.youAreAllSetDesc,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[600],
            foregroundColor: AppColors.kWhite,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 24),
            textStyle: Theme.of(context).textTheme.titleLarge,
          ),
          onPressed: () async {
            ref.read(isGeneratingCVAndCoverLetterProvider.notifier).state = true;
            final response = await _generateDocuments();
            ref.read(isGeneratingCVAndCoverLetterProvider.notifier).state = false;
            if (mounted) {
              context.goNamed(
                AppRouter.resultsScreen.substring(1),
                extra: {
                  'cv_html': response['cv_html'],
                  'cover_letter_html': response['cover_letter_html'],
                },
              );
            }
          },
          child: Text(buttonText),
        ),
      ],
    );
  }
}
