import 'package:aipply/core/questionnaire/application/providers.dart';
import 'package:aipply/core/questionnaire/domain/cover_letter_document.dart';
import 'package:aipply/core/questionnaire/domain/cv_document.dart';
import 'package:aipply/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aipply/utils/app_colors.dart';
import 'package:aipply/utils/dimensions.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/app_router.dart';
import '../../../utils/constants.dart';
import '../../../widgets/loading_overlay.dart';
import '../../../widgets/show_error_dialog.dart';
import '../domain/qa.dart';

class QuestionnaireScreen extends ConsumerStatefulWidget {
  const QuestionnaireScreen({super.key, required this.questions, required this.jobDesc});

  final List<String> questions;
  final String jobDesc;

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
    "First, what's your core contact info? (Full Name, Email, Phone, and your LinkedIn/GitHub URL if you have one).",
    "What's your work history? You can copy-paste this from a CV, or just type it out. (e.g., 'Senior Dev, Google, 2020-Present' or 'Freelance Writer, 2023'). Please put each role on a new line.",
    "Finally, what are your top skills and educational background? Feel free to copy-paste this, or type it. (e.g., 'Skills: Go, Flutter, SQL; Education: B.S. in Computer Science').",
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

    _totalPages = _allQuestions.length + 2;

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

  Future<(Map<String, String>, String)> _generateDocuments(
    List<Map<String, dynamic>> qaJsonList, {
    int retryCount = 0,
  }) async {
    const maxRetries = 3;

    try {
      final cvFuture = ref
          .read(cvDocumentProvider)
          .generateCV(widget.jobDesc, qaJsonList);
      final coverLetterFuture = ref
          .read(coverLetterDocumentProvider)
          .generateCoverLetter(widget.jobDesc, qaJsonList);

      final results = await Future.wait([cvFuture, coverLetterFuture]);

      final (cv, cvError) = results[0] as (CVDocument, String);
      final (coverLetter, clError) = results[1] as (CoverLetterDocument, String);

      if (cvError == "429" || clError == "429") {
        return (<String, String>{}, "429");
      }
      if (cvError.isNotEmpty || clError.isNotEmpty) {
        return (<String, String>{}, "500");
      }

      return ({"cv_html": cv.text, "cover_letter_html": coverLetter.text}, "");
    } catch (e) {
      if (retryCount < maxRetries) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Connection issue. Retrying... (${retryCount + 1}/$maxRetries)',
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }

        await Future.delayed(Duration(seconds: 2 * (retryCount + 1)));
        return _generateDocuments(qaJsonList, retryCount: retryCount + 1);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to generate documents. Please try again.'),
              duration: const Duration(seconds: 4),
              backgroundColor: Colors.red,
            ),
          );
        }
        rethrow;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isGeneratingCVAndCoverLetterProvider);
    final double screenWidth = kScreenWidth(context);
    final bool isMobile = screenWidth < 768;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 800),
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        // Progress Text
                        Text(
                          _getProgressText(),
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: isMobile ? 16 : 24),

                        // Progress Bar
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

                        // Question Section
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _totalPages,
                            onPageChanged: (index) {
                              setState(() {
                                _currentPageIndex = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return _buildIntroPage(isMobile);
                              }
                              if (index == _totalPages - 1) {
                                return _buildFinalPage(isMobile);
                              }
                              final questionIndex = index - 1;
                              return _buildQuestionPage(
                                _allQuestions[questionIndex],
                                _answerControllers[questionIndex],
                                questionIndex + 1,
                                isMobile,
                              );
                            },
                          ),
                        ),

                        if (_currentPageIndex != _totalPages - 1)
                          _buildNavigationRow(isMobile),
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

  Widget _buildNavigationRow(bool isMobile) {
    return Padding(
      padding: EdgeInsets.only(top: isMobile ? 12 : 16),
      child: Row(
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
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 30 : 40,
                vertical: isMobile ? 16 : 20,
              ),
            ),
            onPressed: _nextPage,
            child: Text(AppLocalizations.of(context)!.next),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroPage(bool isMobile) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: isMobile ? 40 : 60),
          Icon(Icons.edit_document, size: isMobile ? 60 : 80, color: AppColors.kPrimary),
          SizedBox(height: isMobile ? 16 : 24),
          Text(
            AppLocalizations.of(context)!.introDesc1,
            style:
                (isMobile
                        ? Theme.of(context).textTheme.headlineMedium
                        : Theme.of(context).textTheme.displaySmall)
                    ?.copyWith(fontSize: isMobile ? 24 : null),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 0),
            child: Text(
              AppLocalizations.of(context)!.introDesc2,
              style:
                  (isMobile
                          ? Theme.of(context).textTheme.titleMedium
                          : Theme.of(context).textTheme.titleLarge)
                      ?.copyWith(fontSize: isMobile ? 16 : null),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionPage(
    String question,
    TextEditingController controller,
    int questionNumber,
    bool isMobile,
  ) {
    final bool isStaticQuestion = questionNumber <= _staticQuestions.length;
    final String storyHintText =
        "e.g., Share a brief example or explanation that highlights your experience, approach, or results.";
    final String hintText = isStaticQuestion ? "Your answer here..." : storyHintText;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 8.0 : 16.0,
        vertical: isMobile ? 16.0 : 24.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: isMobile ? 20 : 40),
          SelectableText(
            question,
            style:
                (isMobile
                        ? Theme.of(context).textTheme.titleLarge
                        : Theme.of(context).textTheme.headlineMedium)
                    ?.copyWith(fontSize: isMobile ? 18 : null, height: 1.4),
          ),
          SizedBox(height: isMobile ? 16 : 24),
          TextFormField(
            controller: controller,
            maxLines: isStaticQuestion ? (isMobile ? 4 : 5) : (isMobile ? 6 : 8),
            textInputAction: TextInputAction.newline,
            style: TextStyle(fontSize: isMobile ? 14 : 16),
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: AppColors.kGray300,
              hintStyle: TextStyle(
                color: AppColors.kGray600.withValues(alpha: 0.7),
                fontSize: isMobile ? 13 : 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kSmallRadius),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.all(isMobile ? 12 : 16),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || (value.trim().isEmpty)) {
                return AppLocalizations.of(context)!.errorMessageForQuestionnaire;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFinalPage(bool isMobile) {
    final buttonText = AppLocalizations.of(context)!.generateMyDocs;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: isMobile ? 40 : 60),
          AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationController.value * 2 * 3.14159,
                child: child,
              );
            },
            child: Icon(
              Icons.auto_awesome,
              size: isMobile ? 60 : 80,
              color: Colors.green[600],
            ),
          ),
          SizedBox(height: isMobile ? 16 : 24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 0),
            child: Text(
              AppLocalizations.of(context)!.youAreAllSet,
              style:
                  (isMobile
                          ? Theme.of(context).textTheme.headlineMedium
                          : Theme.of(context).textTheme.displaySmall)
                      ?.copyWith(fontSize: isMobile ? 24 : null),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 0),
            child: Text(
              AppLocalizations.of(context)!.youAreAllSetDesc,
              style:
                  (isMobile
                          ? Theme.of(context).textTheme.titleMedium
                          : Theme.of(context).textTheme.titleLarge)
                      ?.copyWith(fontSize: isMobile ? 16 : null),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: isMobile ? 32 : 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: AppColors.kWhite,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 40 : 50,
                vertical: isMobile ? 18 : 24,
              ),
              textStyle:
                  (isMobile
                          ? Theme.of(context).textTheme.titleMedium
                          : Theme.of(context).textTheme.titleLarge)
                      ?.copyWith(fontSize: isMobile ? 16 : null),
            ),
            onPressed: () async {
              final List<QA> qaList = [
                for (int i = 0; i < _allQuestions.length; i++)
                  QA(
                    question: _allQuestions[i],
                    answer: _answerControllers[i].text.trim(),
                  ),
              ];
              final qaJsonList = qaList.map((qa) => qa.toJson()).toList();
              ref.read(isGeneratingCVAndCoverLetterProvider.notifier).state = true;
              try {
                final (response, error) = await _generateDocuments(qaJsonList);
                ref.read(isGeneratingCVAndCoverLetterProvider.notifier).state = false;

                if (error.isNotEmpty) {
                  if (mounted) {
                    if (error == "429") {
                      showErrorDialog(context, tooManyRequests);
                    } else {
                      showErrorDialog(context, somethingWentWrong);
                    }
                  }
                  return;
                }

                if (mounted) {
                  context.goNamed(
                    AppRouter.resultsScreen.substring(1),
                    extra: {
                      'cv_html': response['cv_html'],
                      'cover_letter_html': response['cover_letter_html'],
                      'job_desc': widget.jobDesc,
                      'qa_list_json': qaJsonList,
                    },
                  );
                }
              } catch (e) {
                ref.read(isGeneratingCVAndCoverLetterProvider.notifier).state = false;
                if (mounted) {
                  showErrorDialog(context, somethingWentWrong);
                }
              }
            },
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}
