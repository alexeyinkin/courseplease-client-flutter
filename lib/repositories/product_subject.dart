import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/utils/utils.dart';

class ProductSubjectRepository extends AbstractRepository<int, ProductSubject> {
  final _provider = NetworkMapDataProvider();

  Future<List<ProductSubject>> loadAll() {
    var uri = Uri.https(
      'courseplease.com',
      '/api1/en/gallery/subjects',
    );

    return _provider.loadList(uri, null).then(_denormalize);
  }

  List<ProductSubject> _denormalize(LoadResult<Map<String, dynamic>> mapResult) {
    var objects = <ProductSubject>[];

    for (var obj in mapResult.objects) {
      objects.add(ProductSubject.fromMap(obj));
    }

    return objects;
  }

  @override
  Future<ProductSubject> loadById(int id) {
    throw UnimplementedError();
  }

  @override
  Future<List<ProductSubject>> loadByIds(List<int> ids) {
    // TODO: Do we need a specific IDs loader?
    loadAll().then((objects) => whereIds(objects, ids));
  }

  List<ProductSubject> _whereIds(List<ProductSubject> subjects, List<int> ids) {
    final idsMap = ids.asMap();
    final result = <ProductSubject>[];


  }
}


/// This repository allows querying product subjects by IDs
/// although it actually gets them from [ProductSubjectsBloc]
/// because the entire tree is stored there anyway.
// class ProductSubjectRepository extends AbstractRepositoryWithId<int, ProductSubject> {
//   final ProductSubjectsBloc bloc;
//   var _subjectsByIds = Map<int, ProductSubject>();
//
//   ProductSubjectRepository({
//     @required this.bloc,
//   }) {
//     //bloc.outSubjectsByIds.listen(_handleAnythingChanged);
//   }
//
//   void _handleAnythingChanged(Map<int, ProductSubject> subjectsByIds) {
//     _subjectsByIds = subjectsByIds;
//   }
//
//   @override
//   Future<ProductSubject> loadById(int id) {
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<List<ProductSubject>> loadByIds(List<int> ids) {
//     return _subjectsByIds.isEmpty
//         ? _getFutureOfFirstOutput(ids)
//         : _getCompletedFuture(ids);
//   }
//
//   Future<List<ProductSubject>> _getFutureOfFirstOutput(List<int> ids) {
//     bloc.outSubjectsByIds
//         .first
//         .then((map) {
//           _handleAnythingChanged(map);
//           return _pickWithAllIds(ids);
//         });
//   }
//
//   Future<List<ProductSubject>> _getCompletedFuture(List<int> ids) {
//     return Future.value(_pickWithAllIds(ids));
//   }
//
//   List<ProductSubject> _pickWithAllIds(List<int> ids) {
//     final result = <ProductSubject>[];
//
//     for (final id in ids) {
//       final object = _subjectsByIds[id];
//       if (object == null) throw Exception('ProductSubject not found: ' + id.toString());
//       result.add(object);
//     }
//
//     return result;
//   }
// }
