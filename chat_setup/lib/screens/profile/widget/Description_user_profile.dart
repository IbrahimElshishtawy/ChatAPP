// =====================
// Description Section Widget
// =====================
import 'package:flutter/material.dart';

class DescriptionSection extends StatelessWidget {
  const DescriptionSection({super.key, required this.descriptionCtrl});

  final TextEditingController descriptionCtrl;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: descriptionCtrl,
      maxLength: 70,
      maxLines: 4,
      decoration: const InputDecoration(labelText: 'Description'),
      enabled: false,
    );
  }
}
