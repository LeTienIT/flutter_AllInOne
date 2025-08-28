import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/unit_library/shared_pref.dart';
import '../../home/home_controller.dart';

class FeatureReorderPage extends ConsumerWidget {
  const FeatureReorderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final features = ref.watch(featureListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sắp xếp tiện ích'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              // Lưu thứ tự hiện tại
              await saveFeatureOrder(features);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ReorderableListView.builder(
        itemCount: features.length,
        onReorder: (oldIndex, newIndex) {
          ref.read(featureListProvider.notifier).reorder(oldIndex, newIndex);
        },
        itemBuilder: (context, index) {
          final feature = features[index];
          return ListTile(
            key: ValueKey(feature.type),
            leading: Image.asset(feature.iconPath, width: 32, height: 32),
            title: Text(feature.title),
            subtitle: Text(feature.descr),
            trailing: const Icon(Icons.drag_handle),
            selectedColor: feature.color as Color
          );
        },
      ),
    );
  }
}
