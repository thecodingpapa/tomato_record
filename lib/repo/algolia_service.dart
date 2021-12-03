import 'package:algolia/algolia.dart';
import 'package:tomato_record/data/item_model.dart';

const Algolia algolia = Algolia.init(
  applicationId: 'O9Q1TLNUFA',
  apiKey: '9fa70527a465228fb7da3c5cb2a71e70',
);

class AlgoliaService {
  static final AlgoliaService _algoliaService = AlgoliaService._internal();

  factory AlgoliaService() => _algoliaService;

  AlgoliaService._internal();

  Future<List<ItemModel>> queryItems(String queryStr) async {
    AlgoliaQuery query = algolia.instance.index('items').query(queryStr);

    // Perform multiple facetFilters
    // query = query.facetFilter('status:published');
    // query = query.facetFilter('isDelete:false');
    AlgoliaQuerySnapshot algoliaSnapshot = await query.getObjects();
    List<AlgoliaObjectSnapshot> hits = algoliaSnapshot.hits;
    List<ItemModel> items = [];
    hits.forEach((element) {
      ItemModel item =
          ItemModel.fromAlgoliaObject(element.data, element.objectID);
      items.add(item);
    });
    return items;
  }
}
