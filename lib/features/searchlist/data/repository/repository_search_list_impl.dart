import 'package:challenguemaple/exceptions/not_internet_exception.dart';
import 'package:challenguemaple/features/searchlist/data/data_sources/data_source_search_list.dart';
import 'package:challenguemaple/features/searchlist/data/dtos/product.dart';
import 'package:challenguemaple/features/searchlist/data/dtos/product_detail.dart';
import 'package:challenguemaple/features/searchlist/data/repository/repository_search_list.dart';
import 'package:challenguemaple/shared/network/network_utils.dart';

class RepositorySearchListImpl implements RepositorySearchList {
  final SearchListDataSource dataSource;

  RepositorySearchListImpl({required this.dataSource});

  @override
  Future<List<ProductDTO>> getSearchList(String query) async {
    if (await NetworkUtils.hasInternetConnection() == false) {
      throw NoInternetException();
    }
    Map<String, dynamic> result = await dataSource.getSearchList(query);
    if (result['status'] == true) {
      return result['data'];
    }

    return [];
  }

  @override
  Future<ProductDetailDTO?> getProductDetail(String idProduct) async {
    if (await NetworkUtils.hasInternetConnection() == false) {
      throw NoInternetException();
    }

    Map<String, dynamic> result = await dataSource.getDetailProduct(idProduct);
    if (result['status'] == true) {
      return ProductDetailDTO.fromJson(result['data']);
    }

    return null;
  }
}
