// lib/widgets/follow_button.dart

import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final String text;
  final VoidCallback? function;
  final bool isLoading;

  const FollowButton({
    Key? key,
    required this.text,
    required this.function,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: text == 'Unfollow' ? Colors.red : Colors.blue,
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: isLoading
            ? SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
