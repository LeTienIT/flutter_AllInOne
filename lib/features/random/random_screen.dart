import 'package:flutter/material.dart';

enum RandomType { coin, wheel }//, dice

class RandomScreen extends StatefulWidget {
  const RandomScreen({super.key});

  @override
  State<RandomScreen> createState() => _RandomScreenState();
}

class _RandomScreenState extends State<RandomScreen> {
  RandomType _selectedType = RandomType.coin;

  final ScrollController _scrollController = ScrollController();

  final _coinSide1 = TextEditingController(text: 'Đúng');
  final _coinSide2 = TextEditingController(text: 'Sai');

  //int _diceCount = 1;

  final List<TextEditingController> _wheelValues = [
    TextEditingController(text: 'Đúng'),
    TextEditingController(text: 'Sai'),
  ];

  int _wheelTimes = 1;

  @override
  void dispose() {
    _coinSide1.dispose();
    _coinSide2.dispose();
    for (var c in _wheelValues) {
      c.dispose();
    }
    super.dispose();
  }

  List<String> getWheelValues() {
    return _wheelValues.map((controller) => controller.text.trim()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chọn ngẫu nhiên")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSelector(),

            const SizedBox(height: 16),

            Expanded(child: _buildInputForm()),

            ElevatedButton(
              onPressed: () {
                if(_selectedType == RandomType.coin){
                  Navigator.pushNamed(context, '/coin_animation');
                }

                if(_selectedType == RandomType.wheel){
                  final values = _wheelValues.map((c) => c.text.trim()).toList();
                  Navigator.pushNamed(context, '/wheel_animation', arguments: values);
                }
              },
              child: const Text("Xác nhận"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInputForm() {
    switch (_selectedType) {
      case RandomType.coin:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
                "assets/coin_front.png", width: 150
            ),

            Image.asset(
                "assets/coin_back.png", width: 150
            ),
          ],
        );

      // case RandomType.dice:
      //   return Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       const Text("Chọn số xúc xắc", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      //       const SizedBox(height: 12),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         children: List.generate(3, (i) {
      //           final value = i + 1;
      //           final isSelected = _diceCount == value;
      //           return GestureDetector(
      //             onTap: () => setState(() => _diceCount = value),
      //             child: Card(
      //               color: isSelected ? Colors.blue.shade100 : Colors.white,
      //               elevation: isSelected ? 4 : 1,
      //               shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(12),
      //                 side: BorderSide(color: isSelected ? Colors.blue : Colors.grey),
      //               ),
      //               child: Padding(
      //                 padding: const EdgeInsets.all(16),
      //                 child: Column(
      //                   children: [
      //                     Image.asset(
      //                       "assets/dice_$value.png",
      //                       width: 48,
      //                       height: 48,
      //                       color: isSelected ? null : Colors.grey.withValues(alpha: 0.6),
      //                       colorBlendMode: isSelected ? null : BlendMode.modulate,
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //           );
      //         }),
      //       ),
      //     ],
      //   );

      case RandomType.wheel:
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _wheelValues.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _wheelValues[index],
                            decoration: InputDecoration(labelText: "Giá trị ${index + 1}"),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle),
                          onPressed: () {
                            setState(() {
                              if (_wheelValues.length > 2) {
                                _wheelValues[index].dispose();
                                _wheelValues.removeAt(index);
                              }
                            });
                          },
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _wheelValues.add(TextEditingController());
                  });

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  });
                },
                child: const Text("+"),
              ),
            )
          ],
        );
    }
  }

  Widget _buildSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildOption(RandomType.coin, "assets/coin_random.png", "Đồng xu"),
        // _buildOption(RandomType.dice, "assets/dices.png", "Xúc xắc"),
        _buildOption(RandomType.wheel, "assets/wheel.png", "Vòng quay"),
      ],
    );
  }

  Widget _buildOption(RandomType type, String imageAssets, String label) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Card(
        color: isSelected ? Colors.blue.shade100 : Colors.white,
        elevation: isSelected ? 4 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: isSelected ? Colors.blue : Colors.grey),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                imageAssets,
                width: 48,
                height: 48,
              ),
              const SizedBox(height: 8),
              Text(label, style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.grey
              )),
            ],
          ),
        ),
      ),
    );
  }
}
