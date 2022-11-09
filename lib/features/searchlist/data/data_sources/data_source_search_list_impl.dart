import 'dart:convert';
import 'dart:developer';

import 'package:challenguemaple/exceptions/not_internet_exception.dart';
import 'package:challenguemaple/features/searchlist/data/data_sources/data_source_search_list.dart';
import 'package:challenguemaple/features/searchlist/data/dtos/product.dart';
import 'package:challenguemaple/shared/constants/error_constants.dart';
import 'package:challenguemaple/shared/constants/network_constants.dart';
import 'package:challenguemaple/shared/constants/success_consts.dart';
import 'package:challenguemaple/shared/network/network_utils.dart';
import 'package:http/http.dart';

class SearchSourceListImpl implements SearchListDataSource {
  @override
  Future<Map<String, dynamic>> getSearchList(String query) async {
    String url = '${NetworkUtils.host}?q=$query#json';
    try {
      final Response resultResponse = await get(Uri.parse(url))
          .timeout(const Duration(seconds: 10), onTimeout: () async {
        throw NoInternetException();
      });
      if (resultResponse.statusCode == 200) {
        Map<String, dynamic> bodyResponse = jsonDecode(resultResponse.body);
        List<ProductDTO> listProducts = bodyResponse['results']
            .map<ProductDTO>((product) => ProductDTO.fromJson(product))
            .toList();
        return {
          'status': true,
          'data': listProducts,
          'message': successDataFound
        };
      }

      return {'status': false, 'data': [], 'message': errorDataNoFound};
    } catch (e) {
      if (e.toString() == connectionResetByPeer) {
        throw NoInternetException();
      }

      log("Error on obtaing ${e.toString()}");
      return {'status': false, 'data': [], 'message': errorDataNoFound};
    }
  }

  @override
  Future<Map<String, dynamic>> getDetailProduct(String idProduct) async {
    String url = '${NetworkUtils.detailHost}/$idProduct';

    try {
      final Response resulResponse = await get(Uri.parse(url))
          .timeout(const Duration(seconds: 10), onTimeout: () async {
        throw NoInternetException();
      });

      if (resulResponse.statusCode == 200) {
        Map<String, dynamic> bodyResponse = jsonDecode(resulResponse.body);
        return {
          'status': true,
          'data': bodyResponse,
          'message': successDataFound
        };
      }

      return {'status': false, 'data': {}, 'message': errorDataNoFound};
    } catch (e) {
      if (e.toString() == connectionResetByPeer) {
        throw NoInternetException();
      }
      log("Error on obtaing ${e.toString()}");
      return {'status': false, 'data': {}, 'message': errorDataNoFound};
    }
  }
}
