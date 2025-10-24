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

class ResultScreen extends ConsumerStatefulWidget {
  final String cvHtml;
  final String coverLetterHtml;
  const ResultScreen({super.key, required this.cvHtml, required this.coverLetterHtml});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  final HtmlEditorController _cvController = HtmlEditorController();
  final HtmlEditorController _coverLetterController = HtmlEditorController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: kPaddingS),
            child: Text(
              AppLocalizations.of(context)!.yourDocs,

              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: AppColors.kTextOnPrimary,
                height: 1.5,
              ),
            ),
          ),
          backgroundColor: AppColors.kPrimary,
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: AppColors.kTextOnPrimary,
            unselectedLabelColor: AppColors.kTextOnPrimary.withValues(alpha: 0.7),
            labelStyle: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w400, fontSize: 16),
            unselectedLabelStyle: Theme.of(context).textTheme.bodyLarge,
            indicatorWeight: 5,
            tabs: [
              Tab(
                icon: Icon(Icons.article, color: AppColors.kTextOnPrimary),
                child: Text(AppLocalizations.of(context)!.cv),
              ),
              Tab(
                icon: Icon(Icons.mail, color: AppColors.kTextOnPrimary),
                child: Text(AppLocalizations.of(context)!.coverLetter),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildEditorTab(
              _cvController,
              widget.cvHtml,
              AppLocalizations.of(context)!.downloadCV,
            ),
            _buildEditorTab(
              _coverLetterController,
              widget.coverLetterHtml,
              AppLocalizations.of(context)!.coverLetter,
            ),
          ],
        ),
      ),
    );
  }

  /// Converts HTML to a PDF and triggers a browser download.
  Future<void> _downloadAsPdf(HtmlEditorController controller, String filename) async {
    // Get the current HTML from the editor
    final htmlContent = await controller.getText();
    final targetFileName = filename.endsWith('.pdf') ? filename : '$filename.pdf';

    try {
      // Create a new PDF document
      final pdf = pw.Document();

      // Convert HTML string to a list of PDF widgets
      final widgets = await html_to_pdf.HTMLToPdf().convert(htmlContent);

      // Add those widgets to your PDF
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          maxPages: 200,
          build: (context) {
            return widgets;
          },
        ),
      );

      await Printing.sharePdf(bytes: await pdf.save(), filename: targetFileName);

      printOut('Download triggered for: $filename');
      showToast('Download started for $filename', textShouldBeInProd: true);
    } catch (e) {
      printOut('Error generating PDF: $e');
      showToast('Failed to generate PDF', textShouldBeInProd: true);
    }
  }

  /// Helper widget to build the content for each tab
  Widget _buildEditorTab(
    HtmlEditorController controller,
    String initialHtml,
    String downloadFilename,
  ) {
    final isDownloading = ref.watch(isDownloadingDocumentProvider);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.cloud_download_outlined),
            label: Text(
              AppLocalizations.of(context)!.downloadAsAPDF,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(color: AppColors.kTextOnPrimary),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kPrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            onPressed: () async {
              if (isDownloading) return;
              ref.read(isDownloadingDocumentProvider.notifier).state = true;
              await _downloadAsPdf(controller, downloadFilename);
              ref.read(isDownloadingDocumentProvider.notifier).state = false;
            },
          ),
          const SizedBox(height: 16),

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
                    htmlToolbarOptions: const HtmlToolbarOptions(
                      toolbarPosition: ToolbarPosition.aboveEditor,
                      defaultToolbarButtons: [
                        StyleButtons(),
                        FontSettingButtons(),
                        ListButtons(),
                        ParagraphButtons(),
                      ],
                    ),
                    otherOptions: const OtherOptions(
                      height: 500, // You can adjust this
                    ),
                  ),
                ),
                LoadingOverlay(
                  isLoading: isDownloading,
                  headerText: 'Downloading...',
                  descriptionText: '',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
