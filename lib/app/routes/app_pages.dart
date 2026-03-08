import 'package:get/get.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/users/bindings/users_binding.dart';
import '../modules/users/views/users_view.dart';
import '../modules/area/bindings/area_binding.dart';
import '../modules/area/views/area_view.dart';
import '../modules/ruang/bindings/ruang_binding.dart';
import '../modules/ruang/views/ruang_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/kategori_sop/bindings/kategori_sop_binding.dart';
import '../modules/kategori_sop/views/kategori_sop_view.dart';
import '../modules/sop/bindings/sop_binding.dart';
import '../modules/sop/views/sop_view.dart';


part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.USERS,
      page: () => const UsersView(),
      binding: UsersBinding(),
    ),
    GetPage(
      name: _Paths.AREA,
      page: () => const AreaView(),
      binding: AreaBinding(),
    ),
    GetPage(
      name: _Paths.RUANG,
      page: () => const RuangView(),
      binding: RuangBinding(),
    ),
    GetPage(
      name: _Paths.KATEGORI_SOP,
      page: () => const KategoriSopView(),
      binding: KategoriSopBinding(),
    ),
    GetPage(
      name: _Paths.SOP,
      page: () => const SopView(),
      binding: SopBinding(),
    ),
  ];
}

