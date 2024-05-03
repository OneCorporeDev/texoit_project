import 'package:get/get.dart';
import 'package:texoit/movies/bindings/movies_bindings.dart';
import 'package:texoit/movies/ui/movies_page.dart';
part './routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.MOVIES,
      page: () => MoviesPage(),
      binding: MoviesBinding(),
    )
  ];
}
