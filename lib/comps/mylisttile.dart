import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Mylisttile extends StatelessWidget {
  final String title;
  final String trailing;
  final void Function(BuildContext)? onedit;
  final void Function(BuildContext)? ondelete;

  Mylisttile(
      {super.key,
      required this.title,
      required this.trailing,
      required this.onedit,
      required this.ondelete});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(motion: const StretchMotion(), children: [
        SlidableAction(
          onPressed: onedit,
          icon: Icons.edit,
        ),
        SlidableAction(
          onPressed: ondelete,
          icon: Icons.delete,
        )
      ]),
      child: ListTile(
        title: Text(title),
        trailing: Text(trailing),
      ),
    );
  }
}
