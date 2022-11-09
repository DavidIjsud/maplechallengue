import 'package:challenguemaple/features/searchlist/data/dtos/product.dart';
import 'package:challenguemaple/features/searchlist/data/dtos/product_detail.dart';

abstract class RepositorySearchList {
  Future<List<ProductDTO>> getSearchList(String query);
  Future<ProductDetailDTO?> getProductDetail(String idProduct);
}
