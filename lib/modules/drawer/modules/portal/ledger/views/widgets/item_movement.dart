import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

class ItemMovement extends StatelessWidget {
  final Movement movement;
  const ItemMovement({
    Key? key,
    required this.movement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final String date = (movement.date != null)
        ? DateFormat("dd-MMMM-yyyy").format(movement.date!)
        : "No date available";

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(vertical: 3.0),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          height: double.infinity,
          child: Icon(
            movement.amount > 0
                ? Icons.call_received_rounded
                : Icons.call_made_rounded,
            color: theme.colorScheme.secondary,
          ),
        ),
        title: Text(
          movement.description,
          style: theme.textTheme.subtitle1!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          date,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "\$${movement.amount}",
              style: TextStyle(
                color: movement.amount > 0 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
