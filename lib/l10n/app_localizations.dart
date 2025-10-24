import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// The current language is English
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language;

  /// The name of the app
  ///
  /// In en, this message translates to:
  /// **'AIpply'**
  String get appName;

  /// Job description
  ///
  /// In en, this message translates to:
  /// **'Job Description'**
  String get jobDescription;

  /// hint message for job description text field
  ///
  /// In en, this message translates to:
  /// **'Paste the full job description here...'**
  String get jobDescTextFieldHint;

  /// experience level
  ///
  /// In en, this message translates to:
  /// **'Experience level'**
  String get experienceLevel;

  /// Answer Questions
  ///
  /// In en, this message translates to:
  /// **'Answer Questions'**
  String get answerQuestions;

  /// No description provided for @youAreSet.
  ///
  /// In en, this message translates to:
  /// **'You\'re all set!'**
  String get youAreSet;

  /// No description provided for @youAreSetDesc.
  ///
  /// In en, this message translates to:
  /// **'We\'re ready to build your CV and cover letter.'**
  String get youAreSetDesc;

  /// No description provided for @letsGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get started'**
  String get letsGetStarted;

  /// No description provided for @allDone.
  ///
  /// In en, this message translates to:
  /// **'All done!'**
  String get allDone;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Just a few questions...
  ///
  /// In en, this message translates to:
  /// **'Just a few questions...'**
  String get introDesc1;

  /// We'll use your answers to build a CV and cover letter tailored just for you.
  ///
  /// In en, this message translates to:
  /// **'We\'ll use your answers to build a CV and cover letter tailored just for you.'**
  String get introDesc2;

  /// No description provided for @yourAnswerHere.
  ///
  /// In en, this message translates to:
  /// **'Your answer here...'**
  String get yourAnswerHere;

  /// No description provided for @youAreAllSet.
  ///
  /// In en, this message translates to:
  /// **'You\'re all set!'**
  String get youAreAllSet;

  /// No description provided for @youAreAllSetDesc.
  ///
  /// In en, this message translates to:
  /// **'We\'re ready to build your CV and cover letter.'**
  String get youAreAllSetDesc;

  /// No description provided for @generateMyDocs.
  ///
  /// In en, this message translates to:
  /// **'Generate My Documents'**
  String get generateMyDocs;

  /// No description provided for @errorMessageForQuestionnaire.
  ///
  /// In en, this message translates to:
  /// **'can you help us fill in this field, please? 🥹'**
  String get errorMessageForQuestionnaire;

  /// No description provided for @yourDocs.
  ///
  /// In en, this message translates to:
  /// **'Your Documents'**
  String get yourDocs;

  /// No description provided for @cv.
  ///
  /// In en, this message translates to:
  /// **'CV'**
  String get cv;

  /// No description provided for @coverLetter.
  ///
  /// In en, this message translates to:
  /// **'Cover Letter'**
  String get coverLetter;

  /// No description provided for @downloadCV.
  ///
  /// In en, this message translates to:
  /// **'Download CV.pdf'**
  String get downloadCV;

  /// No description provided for @downloadCoverLetter.
  ///
  /// In en, this message translates to:
  /// **'Download Cover Letter.pdf'**
  String get downloadCoverLetter;

  /// No description provided for @downloadAsAPDF.
  ///
  /// In en, this message translates to:
  /// **'Download as PDF'**
  String get downloadAsAPDF;

  /// No description provided for @yourDoc.
  ///
  /// In en, this message translates to:
  /// **'Your document...'**
  String get yourDoc;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
