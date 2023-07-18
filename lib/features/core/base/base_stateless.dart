import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseBlocStateless<B extends BlocBase<S>, S>
    extends StatelessWidget {
  const BaseBlocStateless({Key? key}) : super(key: key);

  B createBloc(BuildContext context);
  Widget buildBloc(BuildContext context, S state);

  @override
  Widget build(BuildContext context) {
    final bloc = createBloc(context);
    return BlocProvider<B>(
      create: (context) => bloc,
      child: BlocBuilder<B, S>(
        builder: (context, state) {
          return buildBloc(context, state);
        },
      ),
    );
  }
}
