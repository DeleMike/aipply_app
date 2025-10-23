// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'English';

  @override
  String get appName => 'AIpply';

  @override
  String get jobDescription => 'Job Description';

  @override
  String get jobDescTextFieldHint => 'Paste the full job description here...';

  @override
  String get experienceLevel => 'Experience level';

  @override
  String get answerQuestions => 'Answer Questions';
}
