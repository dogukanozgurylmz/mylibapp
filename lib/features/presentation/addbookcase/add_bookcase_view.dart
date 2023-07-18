import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylib_app/features/core/base/base_stateless.dart';
import 'package:mylib_app/features/core/widgets/loading_widget.dart';
import 'package:mylib_app/features/data/datasource/local_repository/impl/user_local_datasource_impl.dart';
import 'package:mylib_app/features/data/repository/impl/bookcase_repository_impl.dart';

import '../../core/constant/padding_constant.dart';
import '../../core/enums/space_sizedbox.dart';
import '../../core/widgets/custom_button.dart';
import 'cubit/add_bookcase_cubit.dart';

class AddBookcaseView
    extends BaseBlocStateless<AddBookcaseCubit, AddBookcaseState> {
  const AddBookcaseView({super.key});

  @override
  AddBookcaseCubit createBloc(BuildContext context) {
    final UserLocalDatasourceImpl userLocalDatasourceImpl =
        UserLocalDatasourceImpl();
    final BookcaseRepositoryImpl bookcaseRepositoryImpl =
        BookcaseRepositoryImpl();
    return AddBookcaseCubit(
      userLocalDatasourceImpl: userLocalDatasourceImpl,
      bookcaseRepositoryImpl: bookcaseRepositoryImpl,
    );
  }

  @override
  Widget buildBloc(BuildContext context, state) {
    var cubit = context.read<AddBookcaseCubit>();
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kitaplık ekle"),
      ),
      body: Form(
          child: Padding(
        padding: PaddingConstant.formPadding,
        child: Column(
          children: [
            TextFormField(
              controller: cubit.titleController,
              decoration: InputDecoration(
                labelText: 'Kitaplığın adı',
                labelStyle: TextStyle(
                  color: Colors.grey[500],
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(45),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(45),
                  borderSide: const BorderSide(color: Color(0xFF273043)),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            SpaceVerticalSizedBox.m.value,
            state.isSubmit
                ? const LoadingWidget()
                : CustomButton(
                    text: "Ekle",
                    onPressed: cubit.submitForm,
                  )
          ],
        ),
      )),
    );
  }
}
