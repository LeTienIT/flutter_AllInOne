import 'package:all_in_one_tool/home/home_controller.dart';
import 'package:all_in_one_tool/widget/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widget/feature_button.dart';
import '../widget/welcomePopup.dart';

class HomeScreen extends ConsumerStatefulWidget{
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HomeScreen();
  }

}

class _HomeScreen extends ConsumerState<HomeScreen>{

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WelcomePopup.showIfFirstTime(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final features = ref.watch(featureListProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Tiện ích')),
      drawer: Drawer(child: Menu(),),
      body: features.isEmpty ? const Center(child: CircularProgressIndicator()) : GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: features.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
        ),
        itemBuilder: (context, index) {
          final feature = features[index];
          return FeatureTile(
            feature: feature,
            onTap: () => Navigator.pushNamed(context, feature.route),
          );
        },
      ),
    );

  }

}