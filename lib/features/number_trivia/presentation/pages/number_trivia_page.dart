import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_bloc/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:test_bloc/features/number_trivia/presentation/widgets/message_body.dart';
import 'package:test_bloc/features/number_trivia/presentation/widgets/trivia_view.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final numberController = TextEditingController();
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              builder: (context, state) {
                if (state is NumberTriviaInitial) {
                  return const MessageBody(message: 'Start searching!');
                } else if (state is NumberTriviaLoading) {
                  return const CircularProgressIndicator();
                } else if (state is NumberTriviaLoaded) {
                  return TriviaView(
                    message: state.trivia.text,
                    number: state.trivia.number,
                  );
                } else if (state is NumberTriviaError) {
                  return MessageBody(message: state.message);
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                const Text(
                  'Input a number',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: numberController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Input a number',
                  ),
                  onSubmitted: (value) {
                    context
                        .read<NumberTriviaBloc>()
                        .add(GetTriviaForConreteNumber(numberString: value));
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<NumberTriviaBloc>().add(
                              GetTriviaForConreteNumber(
                                  numberString: numberController.text));
                        },
                        child: const Text('Search'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context
                              .read<NumberTriviaBloc>()
                              .add(GetTriviaForRandomNumber());
                        },
                        child: const Text('Random'),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            //Devider
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Divider(
                height: 20,
                thickness: 1,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Made with ❤ by ZaMaN',
              style: TextStyle(
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
