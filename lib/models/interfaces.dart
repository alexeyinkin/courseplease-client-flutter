abstract class WithId<T> {
  T get id;
}

abstract class WithTitle {
  String get title;
}

abstract class WithChildren<T> {
  List<T> get children;
}

abstract class WithIdTitle<T> implements WithId<T>, WithTitle {}

abstract class WithIdChildren<I, C> implements WithId<I>, WithChildren<C> {}
