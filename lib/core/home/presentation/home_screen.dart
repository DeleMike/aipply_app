import 'package:aipply/l10n/app_localizations.dart';
import 'package:aipply/utils/app_colors.dart';
import 'package:aipply/utils/app_router.dart';
import 'package:aipply/utils/assets.dart';
import 'package:aipply/utils/dimensions.dart';
import 'package:aipply/widgets/general_elevated_button.dart';
import 'package:aipply/widgets/general_input_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/loading_overlay.dart';
import '../../../widgets/quote_block.dart';
import '../application/providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isPanelExpanded = true;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final List<String> _experienceLevels = [
    'Just Starting Out',
    'Some Experience',
    'Highly Experienced',
  ];
  // final List<String> _experienceLevels = ['Entry Level', 'Mid Level', 'Senior Level'];

  late String _selectedExperienceLevel;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> formData = {};

  @override
  void initState() {
    super.initState();
    _selectedExperienceLevel = _experienceLevels.first;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = kScreenWidth(context);
    final double panelWidth = _isPanelExpanded ? screenWidth * 0.5 : 90.0;
    final isLoading = ref.watch(isGeneratingQuestionsProvider);
    return Scaffold(
      body: Row(
        children: [
          AnimatedContainer(
            duration: _animationDuration,
            curve: Curves.easeInOut,
            height: kScreenHeight(context),
            width: panelWidth,
            decoration: BoxDecoration(
              color: AppColors.kPrimary,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(kSmallRadius),
                bottomRight: Radius.circular(kSmallRadius),
              ),
            ),

            child: Stack(
              children: [
                AnimatedOpacity(
                  duration: _animationDuration,
                  opacity: _isPanelExpanded ? 1.0 : 0.0,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AssetsImages.aipplyIcon),
                        Text(
                          AppLocalizations.of(context)!.appName.toUpperCase(),
                          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            fontSize: 65,
                            color: AppColors.kAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      splashColor: AppColors.kAccent.withValues(alpha: 0.3),
                      highlightColor: AppColors.kAccent.withValues(alpha: 0.2),
                      icon: Icon(
                        _isPanelExpanded
                            ? Icons.keyboard_double_arrow_left_rounded
                            : Icons.keyboard_double_arrow_right_rounded,
                        color: AppColors.kAccent,
                        size: 30,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPanelExpanded = !_isPanelExpanded;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.jobDescription.toUpperCase(),
                                  style: Theme.of(context).textTheme.headlineLarge,
                                ),
                                AnimatedSlide(
                                  offset: !_isPanelExpanded
                                      ? Offset.zero
                                      : const Offset(1, 0),
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  child: AnimatedOpacity(
                                    opacity: !_isPanelExpanded ? 1.0 : 0.0,
                                    duration: const Duration(milliseconds: 300),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            AssetsImages.aipplyIcon,
                                            width: 50,
                                            height: 50,
                                          ),
                                          Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.appName.toUpperCase(),
                                            style: Theme.of(
                                              context,
                                            ).textTheme.labelLarge!.copyWith(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0, bottom: 20.0),
                              child: QuoteBlock(
                                text:
                                    "1. Paste the job description and select your experience.\n"
                                    "2. We'll generate key questions based on what the company is looking for.\n"
                                    "3. You'll answer those, and we'll write your CV and cover letter.",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: GeneralInputField(
                            widgetKey: 'jd_field',
                            needsFieldName: false,
                            fieldName: '',
                            hintText: AppLocalizations.of(context)!.jobDescTextFieldHint,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your job description';
                              }
                              return null;
                            },
                            keyValueForDict: 'job_desc',
                            userData: formData,
                            keyboardType: TextInputType.multiline,
                            errorProvider: null,
                            enabled: true,
                            actionWhenOnChangedisPressed: (value) {},
                            textEditingController: null,
                            textInputAction: TextInputAction.newline,
                            focusNode: null,
                            maxLines: null,
                            expands: true,
                          ),
                        ),

                        const SizedBox(height: 24),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.experienceLevel.toUpperCase(),
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField2<String>(
                              value: _selectedExperienceLevel,
                              items: _experienceLevels.map((String level) {
                                return DropdownMenuItem<String>(
                                  value: level,
                                  child: Text(level, style: TextStyle(height: 1.5)),
                                );
                              }).toList(),

                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selectedExperienceLevel = newValue;
                                    formData['experience_level'] = newValue;
                                  });
                                }
                              },
                              onSaved: (newValue) {
                                formData['experience_level'] = newValue;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.kGray300, // Or your preferred color
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(kSmallRadius),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        GeneralElevatedButton(
                          onPressed: () async {
                            final isValid = _formKey.currentState!.validate();
                            if (isValid) {
                              _formKey.currentState!.save();
                              ref.read(isGeneratingQuestionsProvider.notifier).state =
                                  true;

                              final questions = await ref
                                  .read(questionGeneratorController)
                                  .generateQuestions(
                                    formData['job_desc'],
                                    formData['experience_level'],
                                  );

                              ref.read(isGeneratingQuestionsProvider.notifier).state =
                                  false;
                              if (context.mounted) {
                                context.goNamed(
                                  AppRouter.questionnaireScreen.substring(1),
                                  extra: {
                                    'questions': questions,
                                    'jd': formData['job_desc'],
                                  },
                                );
                              }
                            }
                          },
                          borderRadius: 8,
                          buttonHeight: 65,
                          buttonColor: AppColors.kPrimary,
                          child: Text(
                            AppLocalizations.of(context)!.answerQuestions,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge!.copyWith(color: AppColors.kWhite),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                LoadingOverlay(
                  isLoading: isLoading,
                  headerText: 'Generating Your Questions',
                  descriptionText: 'Analyzing your job description...',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
