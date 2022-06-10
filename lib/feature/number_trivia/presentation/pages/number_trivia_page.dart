import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_first_project/feature/number_trivia/presentation/widgets/trivia_controls.dart';
import '../widgets/widgets.dart';
import 'package:tdd_first_project/feature/number_trivia/presentation/blocs/bloc/number_trivia_bloc.dart';
import 'package:tdd_first_project/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              builder: (context, state) {
                if (state is NumberTriviaInitial) {
                  return const MessageDisplay(
                    message: 'Start searching!',
                  );
                } else if (state is NumberTriviaError) {
                  return MessageDisplay(message: state.error);
                } else if (state is NumberTriviaLoading) {
                  return const LoadingWidget();
                } else if (state is NumberTriviaLoaded) {
                  return TriviaDisplay(numberTrivia: state.numberTrivia);
                }

                return Container();
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const TriviaControls()
          ],
        ),
      ),
    );
  }
}
