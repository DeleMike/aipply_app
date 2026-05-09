import 'package:aipply/utils/app_colors.dart';
import 'package:aipply/utils/assets.dart';
import 'package:aipply/utils/dimensions.dart';
import 'package:aipply/widgets/general_elevated_button.dart';
import 'package:aipply/widgets/general_input_field.dart';
import 'package:aipply/widgets/show_error_dialog.dart';
import 'package:aipply/widgets/wait_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/loading_overlay.dart';
import '../../../widgets/quote_block.dart';
import '../../metrics/application/providers.dart';
import '../application/providers.dart';

/// Defines the two primary paths for document generation.
enum ApplyPath { existing, fresh, none }

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  ApplyPath _selectedPath = ApplyPath.none;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = kScreenWidth(context);
    final bool isMobile = screenWidth < 768;
    final isLoading = ref.watch(isGeneratingQuestionsProvider);
    final metricsAsync = ref.watch(metricsStreamProvider);

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 800),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isMobile ? 16 : 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(context, isMobile),
                      const SizedBox(height: 24),
                      _buildMetricsRow(metricsAsync),
                      const SizedBox(height: 32),
                      _buildSectionTitle("The Opportunity"),
                      _buildSharedInputs(context),
                      const SizedBox(height: 32),
                      _buildSectionTitle("Your Starting Point"),
                      _buildPathCards(),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _buildPathSpecificInputs(),
                      ),
                      const SizedBox(height: 48),
                      if (_selectedPath != ApplyPath.none)
                        GeneralElevatedButton(
                          onPressed: _handleGenerate,
                          buttonColor: AppColors.kPrimary,
                          borderRadius: 8,
                          buttonHeight: 60,
                          child: const Text(
                            "GENERATE DOCUMENTS",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          LoadingOverlay(
            isLoading: isLoading,
            headerText: 'Generating Your Documents',
            descriptionText: 'Polishing your CV and Cover Letter...',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: AppColors.kTextSecondary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSharedInputs(BuildContext context) {
    return Column(
      children: [
        GeneralInputField(
          widgetKey: 'target_role',
          fieldName: 'Target Role',
          hintText: "What role are you going for? (e.g. Senior Backend Engineer)",
          keyValueForDict: 'target_role',
          userData: _formData,
          validator: (v) => v!.isEmpty ? "Target role is recommended" : null,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          maxLines: 1,
          enabled: true,
          actionWhenOnChangedisPressed: null,
          textEditingController: null,
          focusNode: null,
          errorProvider: null,
        ),
        const SizedBox(height: 16),
        GeneralInputField(
          widgetKey: 'job_desc',
          fieldName: 'Job Description',
          hintText: "Paste the Job Description here...",
          maxLines: 8,
          keyValueForDict: 'job_description',
          userData: _formData,
          validator: (v) => v!.isEmpty ? "Job description is required" : null,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          enabled: true,
          actionWhenOnChangedisPressed: null,
          textEditingController: null,
          focusNode: null,
          errorProvider: null,
        ),
        const SizedBox(height: 16),
        GeneralInputField(
          widgetKey: 'company_about',
          fieldName: 'About the Company',
          hintText: "Optional: Paste company 'About' info...",
          maxLines: 3,
          keyValueForDict: 'company_about',
          userData: _formData,
          validator: null,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          enabled: true,
          actionWhenOnChangedisPressed: null,
          textEditingController: null,
          focusNode: null,
          errorProvider: null,
        ),
      ],
    );
  }

  Widget _buildPathCards() {
    return Row(
      children: [
        Expanded(
          child: _PathSelectionCard(
            title: "I have a CV",
            subtitle: "Rewrite & tailor existing text",
            icon: Icons.description_outlined,
            isSelected: _selectedPath == ApplyPath.existing,
            onTap: () => setState(() => _selectedPath = ApplyPath.existing),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _PathSelectionCard(
            title: "Starting afresh",
            subtitle: "Build from raw notes",
            icon: Icons.auto_awesome_outlined,
            isSelected: _selectedPath == ApplyPath.fresh,
            onTap: () => setState(() => _selectedPath = ApplyPath.fresh),
          ),
        ),
      ],
    );
  }

  Widget _buildPathSpecificInputs() {
    if (_selectedPath == ApplyPath.existing) {
      return Padding(
        padding: const EdgeInsets.only(top: 24),
        child: GeneralInputField(
          widgetKey: 'existing_cv',
          fieldName: 'Existing CV',
          hintText: "Paste your current CV text here...",
          maxLines: 12,
          keyValueForDict: 'existing_cv',
          userData: _formData,
          validator: (v) => v!.isEmpty ? "Please provide your current CV" : null,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          enabled: true,
          actionWhenOnChangedisPressed: null,
          textEditingController: null,
          focusNode: null,
          errorProvider: null,
        ),
      );
    } else if (_selectedPath == ApplyPath.fresh) {
      return Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Column(
          children: [
            _buildConversationalField(
              "Who is this for?",
              "contact_info",
              "Name, Email, Phone (Optional)",
              1,
            ),
            _buildConversationalField(
              "Any work history?",
              "work_history",
              "Part-time, freelance, internships...",
              5,
            ),
            _buildConversationalField(
              "What are you good at?",
              "skills",
              "List your skills",
              2,
            ),
            _buildConversationalField(
              "Education",
              "education",
              "School, Degree (Optional)",
              2,
            ),
            _buildConversationalField(
              "Anything else?",
              "other",
              "Projects, volunteering, achievements",
              3,
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildConversationalField(String label, String key, String hint, int lines) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GeneralInputField(
        widgetKey: key,
        fieldName: label,
        hintText: hint,
        maxLines: lines,
        keyValueForDict: key,
        userData: _formData,
        validator: null,
        keyboardType: lines > 1 ? TextInputType.multiline : TextInputType.text,
        textInputAction: lines > 1 ? TextInputAction.newline : TextInputAction.next,
        enabled: true,
        actionWhenOnChangedisPressed: null,
        textEditingController: null,
        focusNode: null,
        errorProvider: null,
      ),
    );
  }

  void _handleGenerate() async {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        
      }
    } catch (e) {
      showErrorDialog(context, "Something went wrong. Please try again.");
    }
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Column(
      children: [
        Image.asset(AssetsImages.aipplyIcon, width: isMobile ? 50 : 80),
        const SizedBox(height: 8),
        Text(
          "AIPPLY",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.kPrimary,
          ),
        ),
        const SizedBox(height: 16),
        const QuoteBlock(
          text:
              "Paste a job description and choose whether to tailor your existing CV or build a fresh one from scratch.",
        ),
      ],
    );
  }

  Widget _buildMetricsRow(AsyncValue metricsAsync) {
    return metricsAsync.when(
      data: (metrics) => Row(
        children: [
          Expanded(
            child: _MiniMetric(
              label: "CVs Generated",
              count: metrics?.cvGenerated ?? 0,
              backgroundColor: const Color(0xFFFCE4EC), // Light Pink
              iconColor: Colors.pink[400]!,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _MiniMetric(
              label: "Cover Letters",
              count: metrics?.coverLetterGenerated ?? 0,
              backgroundColor: const Color(0xFFF3E5F5), // Light Purple
              iconColor: Colors.purple[400]!,
            ),
          ),
        ],
      ),
      loading: () => const SingleLineWaitWidget(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _PathSelectionCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PathSelectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_PathSelectionCard> createState() => _PathSelectionCardState();
}

class _PathSelectionCardState extends State<_PathSelectionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.kPrimary.withValues(alpha: 0.08)
                : (_isHovered ? AppColors.kGray200 : Colors.white),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.kPrimary
                  : (_isHovered ? AppColors.kGray400 : AppColors.kGray300),
              width: widget.isSelected ? 2 : 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Column(
            children: [
              Icon(
                widget.icon,
                color: widget.isSelected
                    ? AppColors.kPrimary
                    : (_isHovered ? AppColors.kTextOnAccent : AppColors.kGray600),
                size: 32,
              ),
              const SizedBox(height: 12),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: widget.isSelected ? AppColors.kPrimary : null,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.kGray600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  final String label;
  final int count;
  final Color backgroundColor;
  final Color iconColor;

  const _MiniMetric({
    required this.label,
    required this.count,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: iconColor.withValues(alpha: 0.8),
            ),
          ),
          Text(
            '$count',
            style: TextStyle(fontWeight: FontWeight.bold, color: iconColor, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
