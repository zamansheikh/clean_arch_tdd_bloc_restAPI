import 'package:flutter/material.dart';

class TriviaView extends StatelessWidget {
  final String message;
  final int number;
  const TriviaView({
    super.key,
    required this.message,
    required this.number,
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  number.toString(),
                  style: const TextStyle(
                    fontSize: 35,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
