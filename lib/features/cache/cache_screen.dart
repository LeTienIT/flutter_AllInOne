import 'package:flutter/material.dart';

import '../../app/tool.dart';

class CacheCleanerScreen extends StatefulWidget {
  @override
  State<CacheCleanerScreen> createState() => _CacheCleanerScreenState();
}

class _CacheCleanerScreenState extends State<CacheCleanerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text(
            'Xác nhận xóa bộ nhớ tạm thời của ứng dụng.\n'
                'Việc này không ảnh hưởng đến ứng dụng hiện tại.\n '
                'Và các ứng dụng khác.',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Xóa'),
            ),
          ],
        ),
      );

      if (confirm == true) {
        await cleanOnlyCache();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã xóa cache thành công!')),
          );
        }
      }

      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
