import 'package:aipply/core/results/presentation/result_screen.dart';
import 'package:aipply/core/questionnaire/presentation/questionnaire_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../init_screen.dart';
import '../widgets/not_found_screen.dart';
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
      errorPageBuilder: (context, state) {
        return buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const NotFoundScreen(),
        );
      },
      redirect: (BuildContext context, GoRouterState state) {
        // Check if the user is trying to access a protected route
        final goingToQuestionnaire = state.matchedLocation == questionnaireScreen;
        final goingToResults = state.matchedLocation == resultsScreen;

        // If they are going to a page that requires data,
        // but no data is being passed (e.g., direct URL or refresh).
        if ((goingToQuestionnaire || goingToResults) && state.extra == null) {
          // Redirect them back to the initial screen to start over.
          // We use initialScreen since both it and homeScreen point to InitScreen.
          return initialScreen;
        }

        return null;
      },
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
            final questions = List<String>.from(arguments['questions'] as List);
            final jd = arguments['jd'];

            return QuestionnaireScreen(questions: questions, jobDesc: jd);
          },
          pageBuilder: (context, state) {
            final arguments = state.extra as Map;
            final questions = List<String>.from(arguments['questions'] as List);
            final jd = arguments['jd'];

            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: QuestionnaireScreen(questions: questions, jobDesc: jd),
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
            final jobDesc = arguments['job_desc'];
            final qaListJson = List<Map<String, dynamic>>.from(
              arguments['qa_list_json'] as List,
            );
            return ResultScreen(
              cvHtml: cvHTML,
              coverLetterHtml: coverLetterHTML,
              jobDesc: jobDesc,
              qaListJson: qaListJson,
            );
          },
          pageBuilder: (context, state) {
            final arguments = state.extra as Map;
            final cvHTML = arguments['cv_html'];
            final coverLetterHTML = arguments['cover_letter_html'];
            final jobDesc = arguments['job_desc'];
            final qaListJson = List<Map<String, dynamic>>.from(
              arguments['qa_list_json'] as List,
            );
            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: ResultScreen(
                cvHtml: cvHTML,
                coverLetterHtml: coverLetterHTML,
                jobDesc: jobDesc,
                qaListJson: qaListJson,
              ),
            );
          },
        ),
      ],
    );
  }
}
