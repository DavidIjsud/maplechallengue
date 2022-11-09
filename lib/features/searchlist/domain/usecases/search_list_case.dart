import 'package:challenguemaple/features/searchlist/domain/entities/product_detail_entity.dart';
import 'package:challenguemaple/features/searchlist/domain/entities/product_entity.dart';

abstract class SearchListCase {
  Future<List<ProductEntity>> searchListCase(String query);
  Future<ProductDetailEntity?> getProductDetailCase(String idProduct);
}
