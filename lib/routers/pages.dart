import 'package:game_notion/modules/auth/sign_in/sign_in_bindings.dart';
import 'package:game_notion/modules/auth/sign_in/sign_in_page.dart';
import 'package:game_notion/modules/auth/sign_up/sign_up_bindings.dart';
import 'package:game_notion/modules/auth/sign_up/sign_up_page.dart';
import 'package:game_notion/modules/game_detail/game_detail_bindings.dart';
import 'package:game_notion/modules/game_detail/game_detail_page.dart';
import 'package:game_notion/modules/home/home_bindings.dart';
import 'package:game_notion/modules/home/home_page.dart';
import 'package:game_notion/modules/states_list/states_list_bindings.dart';
import 'package:game_notion/modules/states_list/states_list_page.dart';
import 'package:get/get.dart';

class AppPages {
  static const String home = '/';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String gameDetail = '/game-detail';
  static const String StatesList = '/states-list';

  static final pages = [
    GetPage(
      name: home,
      page: () => const HomePage(),
      binding: HomeBindings(),
    ),
    GetPage(
      name: StatesList,
      page: () => const StatesListPage(),
      binding: StatesListBindings(),
    ),
    GetPage(
      name: '/game-detail/:id',
      page: () => const GameDetailPage(),
      binding: GameDetailBindings(),
      preventDuplicates: false,
    ),
    GetPage(
      name: signIn,
      page: () => const SignInPage(),
      binding: SignInBindings(),
    ),
    GetPage(
      name: signUp,
      page: () => const SignUpPage(),
      binding: SignUpBindings(),
    ),
  ];
}
