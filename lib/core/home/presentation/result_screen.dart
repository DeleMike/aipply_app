import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html_editor_enhanced/html_editor.dart';

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
          title: const Text("Your Documents"),
          backgroundColor: AppColors.kPrimary,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.article), text: "CV"),
              Tab(icon: Icon(Icons.mail), text: "Cover Letter"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildEditorTab(_cvController, widget.cvHtml, "Download CV.pdf"),
            _buildEditorTab(
              _coverLetterController,
              widget.coverLetterHtml,
              "Download CoverLetter.pdf",
            ),
          ],
        ),
      ),
    );
  }

  /// Helper widget to build the content for each tab
  Widget _buildEditorTab(
    HtmlEditorController controller,
    String initialHtml,
    String downloadFilename,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.download),
            label: Text("Download as PDF"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kPrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            onPressed: () {
              // _downloadAsPdf(controller, downloadFilename);
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
                  hint: "Your document...",
                  initialText: initialHtml, 
                ),
                htmlToolbarOptions: const HtmlToolbarOptions(
                  // Configure the toolbar
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
