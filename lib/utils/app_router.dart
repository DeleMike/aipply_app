import 'package:go_router/go_router.dart';

import '../init_screen.dart';
import 'constants.dart';
import 'custom_page_transition.dart';

class AppRouter {
  static const initialScreen = '/';

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
      ],
    );
  }
}
