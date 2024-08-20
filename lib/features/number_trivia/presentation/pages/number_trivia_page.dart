import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_bloc/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
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
                  return MessageBody(message: state.trivia.text);
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
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<NumberTriviaBloc>().add(
                              GetTriviaForConreteNumber(
                                  numberString: 1.toString()));
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
          ],
        ),
      ),
    ));
  }
}

class MessageBody extends StatelessWidget {
  final String message;
  const MessageBody({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: SingleChildScrollView(
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 25,
            ),
          ),
        ),
      ),
    );
  }
}
