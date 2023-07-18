import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylib_app/features/core/base/base_stateless.dart';
import 'package:mylib_app/features/data/datasource/local_repository/impl/book_local_datasource_impl.dart.dart';

import '../../core/constant/padding_constant.dart';
import '../../core/enums/space_sizedbox.dart';
import '../../data/model/bookcase_model.dart';
import 'cubit/bookcase_details_cubit.dart';

class BookcaseDetailsView
    extends BaseBlocStateless<BookcaseDetailsCubit, BookcaseDetailsState> {
  const BookcaseDetailsView({super.key});

  @override
  BookcaseDetailsCubit createBloc(BuildContext context) {
    final BookLocalDatasourceImpl bookLocalDatasourceImpl =
        BookLocalDatasourceImpl();
    return BookcaseDetailsCubit(
      bookLocalDatasourceImpl: bookLocalDatasourceImpl,
    );
  }

  @override
  Widget buildBloc(BuildContext context, state) {
    var cubit = context.read<BookcaseDetailsCubit>();
    var size = MediaQuery.of(context).size;
    final bookcase =
        ModalRoute.of(context)!.settings.arguments as BookcaseModel;
    cubit.getBooks(bookcase.bookIds);
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(bookcase.title),
      ),
      body: ListView.builder(
        itemCount: state.books.length,
        itemBuilder: (context, index) {
          var book = state.books[index];
          return Padding(
            padding: PaddingConstant.appPaddingHor,
            child: SizedBox(
              height: 100,
              width: size.width,
              child: Row(
                children: [
                  const VerticalDivider(
                    indent: 5,
                    endIndent: 5,
                    color: Color(0xffFF9900),
                    thickness: 2,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        book.bookName,
                        style: textTheme.titleLarge,
                      ),
                      Text(
                        book.author,
                        style: textTheme.bodyLarge,
                      ),
                      Text(
                        "${book.page.toString()} sayfa",
                        style: textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios),
                  SpaceVerticalSizedBox.m.value,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
