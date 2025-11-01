import 'package:aipply/core/results/application/providers.dart';
import 'package:aipply/l10n/app_localizations.dart';
import 'package:aipply/utils/constants.dart';
import 'package:aipply/utils/debug_fns.dart';
import 'package:aipply/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart' as html_to_pdf;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../utils/app_colors.dart';
import '../../../widgets/loading_overlay.dart';
import '../../../widgets/show_error_dialog.dart';
import '../../questionnaire/application/providers.dart';

/// Keeps child widgets alive when switching tabs
class KeepAlive extends StatefulWidget {
  final Widget child;
  const KeepAlive({super.key, required this.child});

  @override
  State<KeepAlive> createState() => _KeepAliveState();
}

class _KeepAliveState extends State<KeepAlive> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

class ResultScreen extends ConsumerStatefulWidget {
  final String cvHtml;
  final String coverLetterHtml;
  final String jobDesc;
  final List<Map<String, dynamic>> qaListJson;

  const ResultScreen({
    super.key,
    required this.cvHtml,
    required this.coverLetterHtml,
    required this.jobDesc,
    required this.qaListJson,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  final HtmlEditorController _cvController = HtmlEditorController();
  final HtmlEditorController _coverLetterController = HtmlEditorController();
  late String _currentCvHtml;
  late String _currentCoverLetterHtml;

  final _isRefetchingCv = StateProvider<bool>((ref) => false);
  final _isRefetchingCoverLetter = StateProvider<bool>((ref) => false);

  @override
  void initState() {
    super.initState();
    _currentCvHtml = widget.cvHtml;
    _currentCoverLetterHtml = widget.coverLetterHtml;
  }

  Future<void> _refetchDocument(String docType) async {
    final provider = (docType == 'cv') ? _isRefetchingCv : _isRefetchingCoverLetter;
    ref.read(provider.notifier).state = true;

    try {
      String newHtml;
      String error;
      if (docType == 'cv') {
        final (cvDoc, cvError) = await ref
            .read(cvDocumentProvider)
            .generateCV(widget.jobDesc, widget.qaListJson);
        newHtml = cvDoc.text;
        error = cvError;
        if (error.isEmpty) {
          setState(() => _currentCvHtml = newHtml);
          _cvController.setText(newHtml);
        }
      } else {
        final (clDoc, clError) = await ref
            .read(coverLetterDocumentProvider)
            .generateCoverLetter(widget.jobDesc, widget.qaListJson);
        newHtml = clDoc.text;
        error = clError;
        if (error.isEmpty) {
          setState(() => _currentCoverLetterHtml = newHtml);
          _coverLetterController.setText(newHtml);
        }
      }

      if (error.isNotEmpty) {
        if (mounted) {
          if (error == "429") {
            showErrorDialog(context, tooManyRequests);
          } else {
            showErrorDialog(context, somethingWentWrong);
          }
        }
      } else {
        showToast('Document regenerated successfully!', textShouldBeInProd: true);
      }
    } catch (e) {
      printOut('Error refetching document: $e');
      if (mounted) {
        showErrorDialog(context, somethingWentWrong);
      }
    } finally {
      ref.read(provider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = kScreenWidth(context);
    final bool isMobile = screenWidth < 768;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.only(top: isMobile ? 8 : kPaddingS),
            child: Text(
              AppLocalizations.of(context)!.yourDocs,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: AppColors.kTextOnPrimary,
                height: 1.5,
                fontSize: isMobile ? 20 : null,
              ),
            ),
          ),
          backgroundColor: AppColors.kPrimary,
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: AppColors.kTextOnPrimary,
            unselectedLabelColor: AppColors.kTextOnPrimary.withValues(alpha: 0.7),
            labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: isMobile ? 14 : 16,
            ),
            unselectedLabelStyle: Theme.of(context).textTheme.bodyLarge,
            indicatorWeight: 5,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.article,
                  color: AppColors.kTextOnPrimary,
                  size: isMobile ? 20 : 24,
                ),
                child: Text(AppLocalizations.of(context)!.cv),
              ),
              Tab(
                icon: Icon(
                  Icons.mail,
                  color: AppColors.kTextOnPrimary,
                  size: isMobile ? 20 : 24,
                ),
                child: Text(AppLocalizations.of(context)!.coverLetter),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            KeepAlive(
              child: _buildEditorTab(
                controller: _cvController,
                initialHtml: _currentCvHtml,
                downloadFilename: AppLocalizations.of(context)!.downloadCV,
                docType: 'cv',
                isRefetchingProvider: _isRefetchingCv,
                isMobile: isMobile,
              ),
            ),
            KeepAlive(
              child: _buildEditorTab(
                controller: _coverLetterController,
                initialHtml: _currentCoverLetterHtml,
                downloadFilename: AppLocalizations.of(context)!.coverLetter,
                docType: 'cl',
                isRefetchingProvider: _isRefetchingCoverLetter,
                isMobile: isMobile,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Converts HTML to a PDF and triggers a browser download.
  Future<void> _downloadAsPdf(HtmlEditorController controller, String filename) async {
    final htmlContent = await controller.getText();
    final targetFileName = filename.endsWith('.pdf') ? filename : '$filename.pdf';

    try {
      final pdf = pw.Document();
      final widgets = await html_to_pdf.HTMLToPdf().convert(htmlContent);

      pdf.addPage(
        pw.MultiPage(pageFormat: PdfPageFormat.a4, maxPages: 200, build: (_) => widgets),
      );

      await Printing.sharePdf(bytes: await pdf.save(), filename: targetFileName);
      printOut('Download triggered for: $filename');
      showToast('Download started for $filename', textShouldBeInProd: true);
    } catch (e) {
      printOut('Error generating PDF: $e');
      showToast('Failed to generate PDF', textShouldBeInProd: true);
    }
  }

  Widget _buildEditorTab({
    required HtmlEditorController controller,
    required String initialHtml,
    required String downloadFilename,
    required String docType,
    required StateProvider<bool> isRefetchingProvider,
    required bool isMobile,
  }) {
    final isDownloading = ref.watch(isDownloadingDocumentProvider);
    final isRefetching = ref.watch(isRefetchingProvider);
    final bool hasContent = initialHtml.trim().isNotEmpty;

    if (!hasContent) {
      return Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 24.0 : 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: isMobile ? 50 : 60, color: Colors.red[400]),
              SizedBox(height: isMobile ? 12 : 16),
              Text(
                'Generation Failed',
                style:
                    (isMobile
                            ? Theme.of(context).textTheme.titleLarge
                            : Theme.of(context).textTheme.headlineMedium)
                        ?.copyWith(fontSize: isMobile ? 20 : null),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isMobile ? 6 : 8),
              Text(
                'There was an issue generating this document. Please try again.',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontSize: isMobile ? 14 : null),
              ),
              SizedBox(height: isMobile ? 20 : 24),
              if (isRefetching)
                const CircularProgressIndicator()
              else
                ElevatedButton.icon(
                  icon: Icon(Icons.refresh, size: isMobile ? 18 : 20),
                  label: Text(
                    'Retry Generation',
                    style: TextStyle(fontSize: isMobile ? 14 : 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kPrimary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 24 : 30,
                      vertical: isMobile ? 12 : 15,
                    ),
                  ),
                  onPressed: () => _refetchDocument(docType),
                ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(isMobile ? 12.0 : 16.0),
      child: Column(
        children: [
          // Download Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: Icon(Icons.cloud_download_outlined, size: isMobile ? 18 : 20),
              label: Text(
                AppLocalizations.of(context)!.downloadAsAPDF,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.kTextOnPrimary,
                  fontSize: isMobile ? 14 : 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kPrimary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : 30,
                  vertical: isMobile ? 12 : 15,
                ),
              ),
              onPressed: () async {
                if (isDownloading) return;
                ref.read(isDownloadingDocumentProvider.notifier).state = true;
                await _downloadAsPdf(controller, downloadFilename);
                ref.read(isDownloadingDocumentProvider.notifier).state = false;
              },
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),

          // Editor
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.kGray300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: HtmlEditor(
                    controller: controller,
                    htmlEditorOptions: HtmlEditorOptions(
                      hint: AppLocalizations.of(context)!.yourDoc,
                      initialText: initialHtml,
                    ),
                    htmlToolbarOptions: HtmlToolbarOptions(
                      toolbarPosition: ToolbarPosition.aboveEditor,
                      toolbarType: isMobile
                          ? ToolbarType.nativeScrollable
                          : ToolbarType.nativeGrid,
                      defaultToolbarButtons: [
                        StyleButtons(),
                        FontSettingButtons(),
                        ListButtons(),
                        ParagraphButtons(),
                      ],
                    ),
                    otherOptions: OtherOptions(height: isMobile ? 400 : 500),
                  ),
                ),
                LoadingOverlay(
                  isLoading: isDownloading,
                  headerText: 'Downloading...',
                  descriptionText: '',
                ),
                LoadingOverlay(
                  isLoading: isRefetching,
                  headerText: 'Regenerating...',
                  descriptionText: 'Please wait...',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
