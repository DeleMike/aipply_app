import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../utils/debug_fns.dart';
import '../domain/api_repository.dart';
import '../domain/documents.dart';

/// Handles the primary document generation flow.
/// Replaces the old [GenerateCvController] and [GenerateCoverLetterController],
/// which called separate endpoints that no longer exist.
class DocumentGeneratorController with ChangeNotifier {
  final _apiRepo = ApiRepository();

  /// Generates both a CV and a cover letter in a single API call.
  ///
  /// [payload] must conform to the [GenerateDocumentsRequest] shape:
  /// {
  ///   "job_description": required,
  ///   "mode": "existing_cv" | "fresh",
  ///   "company_about": optional,
  ///   "target_role": optional,
  ///   "existing_cv": required when mode = existing_cv,
  ///   "fresh_data": { contact_info, work_history, skills, education, other }
  ///                 required when mode = fresh,
  /// }
  Future<(Documents, String)> generateDocuments({
    required Map<String, dynamic> payload,
  }) async {
    printOut('DocumentGeneratorController payload: ${jsonEncode(payload)}');
    final (documents, errorMsg) = await _apiRepo.generateDocuments(payload: payload);
    return (documents, errorMsg);
  }
}
