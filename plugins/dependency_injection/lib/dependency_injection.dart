library dependency_injection;

abstract class DependencyInjection {
  void lazyPut<T>(
    T Function() register, {
    String? tag,
    bool fenix = false,
  });

  void put<S>(
    S dependency, {
    String? tag,
    bool permanent = false,
    S Function()? builder,
  });

  S? get<S>({String? tag});

  bool isRegistred<S>({String? tag});
}

late DependencyInjection di;
