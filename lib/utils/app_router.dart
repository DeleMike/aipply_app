import 'package:aipply/core/results/presentation/result_screen.dart';
import 'package:aipply/core/questionnaire/presentation/questionnaire_screen.dart';
import 'package:go_router/go_router.dart';

import '../init_screen.dart';
import 'constants.dart';
import 'custom_page_transition.dart';

class AppRouter {
  static const initialScreen = '/';
  static const homeScreen = '/home-screen';
  static const questionnaireScreen = '/questionnaire-screen';
  static const resultsScreen = '/result-screen';

  static GoRouter getRouter() {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: initialScreen,
      routes: [
        GoRoute(
          path: initialScreen,
          builder: (context, state) => const InitScreen(),
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: const InitScreen(),
          ),
        ),
        GoRoute(
          path: homeScreen,
          builder: (context, state) => const InitScreen(),
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: const InitScreen(),
          ),
        ),

        GoRoute(
          path: questionnaireScreen,
          name: questionnaireScreen.substring(1),
          builder: (context, state) {
            final arguments = state.extra as Map;
            final questions = arguments['questions'];
            return QuestionnaireScreen(questions: questions);
          },
          pageBuilder: (context, state) {
            final arguments = state.extra as Map;
            final questions = arguments['questions'];
            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: QuestionnaireScreen(questions: questions),
            );
          },
        ),

        GoRoute(
          path: resultsScreen,
          name: resultsScreen.substring(1),
          builder: (context, state) {
            final arguments = state.extra as Map;
            final cvHTML = arguments['cv_html'];
            final coverLetterHTML = arguments['cover_letter_html'];
            return ResultScreen(cvHtml: cvHTML, coverLetterHtml: coverLetterHTML);
          },
          pageBuilder: (context, state) {
            final arguments = state.extra as Map;
            final cvHTML = arguments['cv_html'];
            final coverLetterHTML = arguments['cover_letter_html'];
            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: ResultScreen(cvHtml: cvHTML, coverLetterHtml: coverLetterHTML),
            );
          },
        ),
      ],
    );
  }
}
