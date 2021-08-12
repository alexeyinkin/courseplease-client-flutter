abstract class WithId<T> {
  T get id;
}

abstract class WithTitle {
  String get title;
}

abstract class WithChildren<T> {
  List<T> get children;
}

abstract class WithParent<T> {
  T? get parent;
}

abstract class WithIdTitle<T> implements
    WithId<T>,
    WithTitle
{}

abstract class WithIdChildrenParent<I, C, P> implements
    WithId<I>,
    WithChildren<C>,
    WithParent<P>
{}

abstract class WithIdTitleChildrenParent<I, C, P> implements
    WithId<I>,
    WithTitle,
    WithIdTitle<I>,
    WithChildren<C>,
    WithParent<P>,
    WithIdChildrenParent<I, C, P>
{}
