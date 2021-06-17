class Breadcrumbs<T> {
  final List<Breadcrumb<T>> list;

  Breadcrumbs({
    required this.list,
  });
}

class Breadcrumb<T> {
  final T item;
  final BreadcrumbStatus status;

  Breadcrumb({
    required this.item,
    required this.status,
  });
}

enum BreadcrumbStatus {
  ancestor,   // Above the current one.
  current,    // Currently being viewed.
  descendant, // Below the current one, if we viewed some subject below and then navigated upwards.
}
