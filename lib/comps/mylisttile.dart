import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, top: 25),
      child: Slidable(
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          CustomSlidableAction(
            onPressed: onedit,
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(10),
            child: Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
          CustomSlidableAction(
            onPressed: ondelete,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(10),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          )
        ]),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.breeSerif(color: Colors.white),
                  ),
                  Text(trailing,
                      style: GoogleFonts.breeSerif(color: Colors.white)),
                ]),
          ),
        ),
      ),
    );
  }
}
