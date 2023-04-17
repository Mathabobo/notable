import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Notetile extends StatelessWidget {
  final Decoration decoration;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final DocumentSnapshot documentSnapshot;

  const Notetile({
    super.key,
    required this.documentSnapshot,
    required this.onTap,
    required this.onLongPress,
    required this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 30),
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onLongPress: onLongPress,
        onTap: onTap,
        child: AnimatedContainer(
          curve: Curves.linearToEaseOut,
          duration: const Duration(milliseconds: 30),
          decoration: decoration,
          height: 125,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  documentSnapshot['title'],
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  documentSnapshot['note'],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
