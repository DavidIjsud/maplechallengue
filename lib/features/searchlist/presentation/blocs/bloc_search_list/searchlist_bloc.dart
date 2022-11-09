import 'package:bloc/bloc.dart';
import 'package:challenguemaple/exceptions/not_internet_exception.dart';
import 'package:challenguemaple/features/searchlist/domain/entities/product_entity.dart';
import 'package:challenguemaple/features/searchlist/domain/usecases/search_list_case.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'searchlist_event.dart';
part 'searchlist_state.dart';

class SearchlistBloc extends Bloc<SearchlistEvent, SearchlistState> {
  final SearchListCase searchListCase;

  SearchlistBloc({required this.searchListCase}) : super(SearchlistInitial()) {
    on<SearchListEvent>(_onSearchListProducts);
  }

  Future<void> _onSearchListProducts(
      SearchListEvent event, Emitter<SearchlistState> emit) async {
    try {
      emit(LoadingRequest());
      List<ProductEntity> products =
          await searchListCase.searchListCase(event.query);
      emit(SuccessRequest(products: products));
    } on NoInternetException {
      emit(ErrorOnRequest(errorType: ErrorType.noInternet));
    } catch (e) {
      emit(ErrorOnRequest(errorType: ErrorType.unknownError));
    }
  }
}
