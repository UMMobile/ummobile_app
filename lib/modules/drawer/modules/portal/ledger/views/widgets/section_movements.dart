import 'package:flutter/material.dart';
import 'package:ummobile/modules/drawer/modules/portal/ledger/views/widgets/item_movement.dart';
import 'package:ummobile_sdk/ummobile_sdk.dart';

class MovementsSection extends StatelessWidget {
  final String header;
  final List<Movement> movements;
  const MovementsSection({
    Key? key,
    required this.header,
    required this.movements,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Text(
              header,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Column(
            children: movements
                .map(
                  (movement) => ItemMovement(movement: movement),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
