import 'package:all_in_one_tool/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widget/feature_button.dart';

class HomeScreen extends ConsumerWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(featureListProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Tiện ích'),),
      body: SingleChildScrollView(
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 cột
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2, // Tùy chỉnh chiều cao
          ),
          itemBuilder: (context, index) {
            final feature = state[index];
            return FeatureTile(
              feature: feature,
              onTap: () => Navigator.pushNamed(context, feature.route),
            );
          },
        ),
      )
    );
  }

}