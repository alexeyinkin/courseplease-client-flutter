import 'dart:async';
import 'dart:collection';

import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/models/product_subject_with_status.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'bloc.dart';

class CurrentProductSubjectBloc implements Bloc {
  // TODO: Start at root when the root screen is developed.
  int _currentId = 7;
  int _lastId = 16;
  var _subjectsByIds = Map<int, ProductSubject>();

  final _productSubjectCacheBloc = GetIt.instance.get<ProductSubjectCacheBloc>();
  late final StreamSubscription _productSubjectCacheBlocSubscription;

  final _outCurrentIdController = BehaviorSubject<int>();
  Stream<int> get outCurrentId => _outCurrentIdController.stream;

  final _outBreadcrumbsController = BehaviorSubject<List<ProductSubjectWithStatus>>();
  Stream<List<ProductSubjectWithStatus>> get outBreadcrumbs => _outBreadcrumbsController.stream;

  final _outChildrenController = BehaviorSubject<List<ProductSubject>>();
  Stream<List<ProductSubject>> get outChildren => _outChildrenController.stream;

  CurrentProductSubjectBloc() {
    _productSubjectCacheBlocSubscription = _productSubjectCacheBloc.outObjectsByIds.listen(_setSubjectsByIds);
  }

  void _setSubjectsByIds(Map<int, ProductSubject> map) {
    _subjectsByIds = map;
    _pushOutput();
  }

  void setCurrentId(int id) {
    if (_currentId == id) return;
    _currentId = id;
    _pushOutput();
  }

  void _pushOutput() {
    if (_currentId != null) {
      _outCurrentIdController.sink.add(_currentId);
      _pushBreadcrumbs();
      _pushChildren();
    }
  }

  void _pushBreadcrumbs() {
    var chain = <ProductSubjectWithStatus>[];
    var subject = _subjectsByIds[_lastId];

    while (subject != null && subject.id != _currentId) {
      chain.insert(
        0,
        ProductSubjectWithStatus(subject: subject, status: ProductSubjectStatus.descendant),
      );
      subject = subject.parent;
    }

    subject = _subjectsByIds[_currentId];
    if (subject != null) {
      chain.insert(
        0,
        ProductSubjectWithStatus(
            subject: subject, status: ProductSubjectStatus.current),
      );
      subject = subject.parent;
    }

    while (subject != null) {
      chain.insert(
        0,
        ProductSubjectWithStatus(subject: subject, status: ProductSubjectStatus.ancestor),
      );
      subject = subject.parent;
    }

    _outBreadcrumbsController.sink.add(UnmodifiableListView(chain));
  }

  void _pushChildren() {
    var subject = _subjectsByIds[_currentId];
    _outChildrenController.sink.add(
        UnmodifiableListView(subject == null ? <ProductSubject>[] : subject.children)
    );
  }

  @override
  void dispose() {
    _productSubjectCacheBlocSubscription.cancel();
    _outChildrenController.close();
    _outBreadcrumbsController.close();
    _outCurrentIdController.close();
  }
}
