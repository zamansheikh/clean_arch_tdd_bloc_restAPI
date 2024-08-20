import 'package:flutter/material.dart';

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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 25,
              ),
            ),
          ),
        ),
      ),
    );
  }
}