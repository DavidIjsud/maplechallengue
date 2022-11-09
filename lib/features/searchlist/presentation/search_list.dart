import 'package:challenguemaple/features/searchlist/presentation/bloc_search_list/searchlist_bloc.dart';
import 'package:challenguemaple/features/searchlist/presentation/widgets/list_products.dart';
import 'package:debounce_builder/debounce_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListProducts extends StatefulWidget {
  const ListProducts({Key? key}) : super(key: key);

  @override
  State<ListProducts> createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search List'),
        backgroundColor: const Color(0xFF121167),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20.0,
            ),
            DebounceBuilder(
                delay: const Duration(milliseconds: 700),
                builder: (_, debounce) {
                  return TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search Product',
                      prefixIcon: Icon(
                        Icons.search,
                        color: Color(0xFF121167),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          borderSide: BorderSide(color: Color(0xFF121167))),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          borderSide: BorderSide(color: Color(0xFF121167))),
                    ),
                    onSubmitted: (String query) {
                      context
                          .read<SearchlistBloc>()
                          .add(SearchListEvent(query));
                    },
                    onChanged: (String query) {
                      debounce(() {
                        context
                            .read<SearchlistBloc>()
                            .add(SearchListEvent(query));
                      });
                    },
                  );
                }),
            const SizedBox(
              height: 20.0,
            ),
            BlocConsumer<SearchlistBloc, SearchlistState>(
              listener: (context, state) {
                if (state is ErrorOnRequest) {
                  String error = state.errorType == ErrorType.noInternet
                      ? 'No  connection to internet'
                      : 'Unknown Error';
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error),
                    ),
                  );
                }
              },
              listenWhen: (previous, current) => current is ErrorOnRequest,
              buildWhen: (previus, current) =>
                  current is SuccessRequest ||
                  current is SearchlistInitial ||
                  current is LoadingRequest,
              builder: (context, state) {
                if (state is SuccessRequest) {
                  return ListProduct(products: state.products);
                }

                if (state is LoadingRequest) {
                  return const Center(child: CircularProgressIndicator());
                }

                return const ListProduct(products: []);
              },
            )
          ],
        ),
      ),
    );
  }
}
