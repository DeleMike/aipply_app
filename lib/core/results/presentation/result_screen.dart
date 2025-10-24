import 'package:aipply/core/results/application/providers.dart';
import 'package:aipply/l10n/app_localizations.dart';
import 'package:aipply/utils/constants.dart';
import 'package:aipply/utils/debug_fns.dart';
import 'package:aipply/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:path_provider/path_provider.dart';

import '../../../utils/app_colors.dart';

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

  /// Converts HTML to a PDF and triggers a download.
  Future<void> _downloadAsPdf(HtmlEditorController controller, String filename) async {
    final htmlContent = await controller.getText();
    final directory = await getApplicationDocumentsDirectory();
    final targetPath = directory.path;
    final targetFileName = filename.endsWith('.pdf') ? filename : '$filename.pdf';

    // Generate PDF from HTML
    final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
      htmlContent,
      targetPath,
      targetFileName,
    );

    printOut('PDF saved at: ${generatedPdfFile.path}');
    showToast('PDF saved at: ${generatedPdfFile.path}', textShouldBeInProd: true);
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
            label: isDownloading
                ? CircularProgressIndicator()
                : Text(
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
            child: Container(
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
          ),
        ],
      ),
    );
  }
}
