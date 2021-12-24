import 'package:collection/collection.dart';
import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/blocs/tree_position.dart';
import 'package:courseplease/router/abstract_tab_state.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:get_it/get_it.dart';
import 'package:keyed_collection_widgets/keyed_collection_widgets.dart';

enum ExploreTab {
  images,
  lessons,
  teachers,
}

class ExploreTabState extends AbstractTabState {
  int? _currentProductSubjectId;

  final tabController = KeyedStaticTabController<ExploreTab>(
    keys: [],
    currentKey: null,
  );

  final currentTreePositionBloc = TreePositionBloc<int, ProductSubject>(
    modelCacheBloc: GetIt.instance.get<ProductSubjectCacheBloc>(),
  );

  ExploreTabState() {
    tabController.addListener(notifyListeners);
    currentTreePositionBloc.states.listen(_onProductSubjectChanged);
  }

  void _onProductSubjectChanged(TreePositionState<int, ProductSubject> state) {
    final ps = state.currentObject;
    final id = ps?.id;
    if (id == _currentProductSubjectId) return;

    _currentProductSubjectId = id;

    if (ps != null) {
      final keys = _getTabKeysByProductSubject(ps);
      final currentKey = _getNewCurrentTabKey(keys);
      tabController.setKeysAndCurrentKey(keys, currentKey);
    }

    notifyListeners();
  }

  List<ExploreTab> _getTabKeysByProductSubject(ProductSubject ps) {
    final result = <ExploreTab>[];

    if (ps.allowsImagePortfolio) {
      result.add(ExploreTab.images);
    }

    result.add(ExploreTab.lessons);
    result.add(ExploreTab.teachers);

    return result;
  }

  ExploreTab? _getNewCurrentTabKey(List<ExploreTab> keys) {
    final lastKey = tabController.currentKey;

    if (lastKey != null && keys.contains(lastKey)) return lastKey;
    return keys.firstOrNull;
  }

  set tab(ExploreTab? tab) {
    if (tab == tabController.currentKey) return;
    tabController.currentKey = tab;
    notifyListeners();
  }
  ExploreTab? get tab => tabController.currentKey;

  @override
  void dispose() {
    currentTreePositionBloc.dispose();
    tabController.dispose();
    super.dispose();
  }
}
