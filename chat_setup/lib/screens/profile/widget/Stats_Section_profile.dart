import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _StatColumn(label: 'Posts', value: '58'),
        _StatColumn(label: 'Followers', value: '1,078'),
        _StatColumn(label: 'Following', value: '221'),
      ],
    );
  }

  Widget _StatColumn({required String label, required String value}) {
    return Column(
      children: [
        Text(value, style: Theme.of(Get.context!).textTheme.headlineSmall),
        Text(label),
      ],
    );
  }
}
