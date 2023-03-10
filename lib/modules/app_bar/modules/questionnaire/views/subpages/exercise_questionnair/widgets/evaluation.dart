import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionsElements extends StatefulWidget {
  const QuestionsElements({Key? key}) : super(key: key);

  @override
  State<QuestionsElements> createState() => _QuestionsElementsState();
}

class _QuestionsElementsState extends State<QuestionsElements> {
  List<String> items = ["00 Rectoria", "01 VRF", "02 VRA", "03 VRE"];
  String? selectedItem = "00 Rectoria";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('select'.trParams({
              'element': 'department'.tr,
            })),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    width: 3,
                    color:Theme.of(context).colorScheme.secondary),
                    
                  ),
                ),
              ),
              value: selectedItem,
              items: items
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item, style: TextStyle(fontSize: 16)),
                      ))
                  .toList(),
              onChanged: (item) => setState(() => selectedItem = item),
            ),
          ],
        ),
      ),
    );
  }
}
