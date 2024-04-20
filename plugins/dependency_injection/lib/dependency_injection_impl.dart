import 'package:dependency_injection/dependency_injection.dart';
import 'package:get/instance_manager.dart';

class DependencyInjectionImpl extends DependencyInjection {
  @override
  void lazyPut<T>(
    T Function() register, {
    String? tag,
    bool fenix = false,
  }) =>
      Get.lazyPut<T>(register, tag: tag, fenix: fenix);

  @override
  void put<S>(
    S dependency, {
    String? tag,
    bool permanent = false,
    S Function()? builder,
  }) =>
      Get.put<S>(dependency, tag: tag, permanent: permanent, builder: builder);

  @override
  S? get<S>({String? tag}) {
    return isRegistred<S>(tag: tag) ? Get.find<S>(tag: tag) : null;
  }

  @override
  bool isRegistred<S>({String? tag}) => Get.isRegistered<S>(tag: tag);
}
