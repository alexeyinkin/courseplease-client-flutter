import 'package:collection/collection.dart';
import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/blocs/page.dart';
import 'package:courseplease/blocs/tree_position.dart';
import 'package:courseplease/models/filters/gallery_image.dart';
import 'package:courseplease/models/filters/gallery_lesson.dart';
import 'package:courseplease/models/filters/teacher.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/screens/explore/configurations.dart';
import 'package:courseplease/screens/explore/local_blocs/images_tab.dart';
import 'package:courseplease/screens/explore/local_blocs/lessons_tab.dart';
import 'package:courseplease/screens/explore/local_blocs/teachers_tab.dart';
import 'package:get_it/get_it.dart';
import 'package:keyed_collection_widgets/keyed_collection_widgets.dart';
import 'package:model_interfaces/model_interfaces.dart';

import 'explore_tab_enum.dart';

class ExploreBloc extends AppPageStatefulBloc<ExploreBlocState> {
  late TreePositionState<int, ProductSubject> _treePositionState;

  final tabController = KeyedStaticTabController<ExploreTab>(
    keys: [],
    currentKey: null,
  );

  final currentTreePositionBloc = TreePositionBloc<int, ProductSubject>(
    modelCacheBloc: GetIt.instance.get<ProductSubjectCacheBloc>(),
  );

  final imagesTabCubit = ImagesTabCubit(
    initialFilter: GalleryImageFilter(
      subjectId: null,
      purposeId: ImageAlbumPurpose.portfolio,
    ),
  );

  final lessonsTabCubit = LessonsTabCubit(
    initialFilter: GalleryLessonFilter(
      subjectId: null,
    ),
  );

  final teachersTabCubit = TeachersTabCubit(
    initialFilter: TeacherFilter(
      subjectId: null,
    ),
  );

  ExploreBloc() {
    _treePositionState = currentTreePositionBloc.initialState;
    tabController.addListener(emitState);
    currentTreePositionBloc.states.listen(_onProductSubjectChanged);
  }

  @override
  MyPageConfiguration getConfiguration() {
    final ps = _treePositionState.currentObject;
    if (ps == null) return ExploreRootConfiguration();

    return ExploreSubjectConfiguration(
      tab: tabController.currentKey!,
      subjectId: ps.id,
      subjectPath: ps.slashedPath,
    );
  }

  @override
  setStateMap(Map<String, dynamic> state) {
    final subjectPath = state['subjectPath'];

    if (subjectPath != null) {
      currentTreePositionBloc.setCurrentPath(subjectPath);
    } else {
      final subjectId = state['subjectId'];
      currentTreePositionBloc.setCurrentId(subjectId);
    }

    try {
      final tabName = state['tab'];
      if (tabName != null) {
        final tab = ExploreTab.values.byName(state['tab']);
        tabController.currentKey = tab;
      }
    } catch (ex) {
      // TODO: Log error.
    }
  }

  void _onProductSubjectChanged(TreePositionState<int, ProductSubject> state) {
    final ps = state.currentObject;
    if (ps?.id == _treePositionState.currentId) return;

    _treePositionState = state;

    if (ps != null) {
      final keys = _getTabKeysByProductSubject(ps);
      final currentKey = _getNewCurrentTabKey(keys);
      tabController.setKeysAndCurrentKey(keys, currentKey);
    }

    emitState();
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
    emitState();
  }
  ExploreTab? get tab => tabController.currentKey;

  @override
  void emitState() {
    super.emitState();
    emitConfigurationChanged();
  }

  @override
  ExploreBlocState createState() => const ExploreBlocState();

  @override
  Future<bool> onBackPressed() {
    currentTreePositionBloc.up();
    return Future.value(true);
  }

  @override
  void dispose() {
    currentTreePositionBloc.dispose();
    tabController.dispose();
    imagesTabCubit.dispose();
    lessonsTabCubit.dispose();
    teachersTabCubit.dispose();
    super.dispose();
  }
}

class ExploreBlocState {
  const ExploreBlocState();
}

class ExploreBlocNormalizedState implements Normalizable {
  final int? subjectId;

  ExploreBlocNormalizedState({
    required this.subjectId,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'subjectId': subjectId,
    };
  }
}
