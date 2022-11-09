import 'package:challenguemaple/features/searchlist/data/dtos/product.dart';
import 'package:challenguemaple/features/searchlist/data/dtos/product_detail.dart';
import 'package:challenguemaple/features/searchlist/domain/entities/product_detail_entity.dart';

abstract class RepositorySearchList {
  Future<List<ProductDTO>> getSearchList(String query);
  Future<ProductDetailDTO?> getProductDetail(String idProduct);
}
