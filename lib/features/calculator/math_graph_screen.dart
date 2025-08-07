import 'package:all_in_one_tool/features/calculator/controller/graph.dart';
import 'package:all_in_one_tool/features/calculator/widget/FunctionParameter.dart';
import 'package:all_in_one_tool/features/calculator/widget/graph_chart.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../app/tool.dart';
import 'model/function_config.dart';

class GraphScreen extends StatefulWidget{
  const GraphScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GraphScreen();
  }

}
class _GraphScreen extends State<GraphScreen>{
  TextEditingController controllerA = TextEditingController(text: '1');
  TextEditingController controllerB = TextEditingController(text: '0');
  TextEditingController controllerC = TextEditingController(text: '0');
  FunctionType selectedType = FunctionType.linear;
  double minX = -10, maxX = 10;
  List<FlSpot> points = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controllerA.dispose();
    controllerB.dispose();
    controllerC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Biểu đồ toán học'),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: DropdownSearch<FunctionType>(
                selectedItem: selectedType,
                itemAsString: functionTypeName,
                items: FunctionType.values.map((e) => e).toList(),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Loại biểu đồ",
                    hintText: "Chọn biểu đồ.",
                  ),
                ),
                popupProps: const PopupProps.menu(
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      hintText: "Tìm kiếm ...",
                    ),
                  ),
                ),
                onChanged: (val){
                  if (val != null) {
                    setState(() {
                      selectedType = val;
                    });
                  }
                },
              ),
            ),
            Text('Nhập dữ liệu', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleSmall,),
            SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
              child: FunctionParameterInput(
                key: ValueKey(selectedType),
                type: selectedType,
                controllerA: controllerA,
                controllerB: controllerB,
                controllerC: controllerC,
              ),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: (){
                    final a = parseInput(controllerA.text);
                    final b = parseInput(controllerB.text);
                    final c = parseInput(controllerC.text);

                    if (selectedType == FunctionType.linear && (a == null || b == null)) {
                      showError(context, 'Lỗi nhập dữ liệu', "Hàm bậc nhất yêu cầu nhập A và B hợp lệ.");
                      return;
                    }

                    if (selectedType == FunctionType.quadratic && (a == null || b == null || c == null)) {
                      showError(context, 'Lỗi nhập dữ liệu', "Hàm bậc hai yêu cầu nhập A, B, C hợp lệ.");
                      return;
                    }

                    final config = FunctionConfig(type: selectedType, a: a ?? 0, b: b ?? 0, c: c ?? 0,);
                    setState(() {
                      points = GraphController(config).generateGraphPoints();
                    });
                  },
                  child: Text('Vẽ biểu đồ')
              ),
                if(selectedType == FunctionType.linear || selectedType == FunctionType.quadratic)
                  ElevatedButton(
                      onPressed: (){
                        final a = parseInput(controllerA.text);
                        final b = parseInput(controllerB.text);
                        final c = parseInput(controllerC.text);

                        if (selectedType == FunctionType.linear && (a == null || b == null)) {
                          showError(context, 'Lỗi nhập dữ liệu', "Hàm bậc nhất yêu cầu nhập A và B hợp lệ.");
                          return;
                        }

                        if (selectedType == FunctionType.quadratic && (a == null || b == null || c == null)) {
                          showError(context, 'Lỗi nhập dữ liệu', "Hàm bậc hai yêu cầu nhập A, B, C hợp lệ.");
                          return;
                        }

                        final config = FunctionConfig(type: selectedType, a: a ?? 0, b: b ?? 0, c: c ?? 0,);
                        String solve = GraphController(config).solveEquation();

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Kết quả giải phương trình'),
                            content: SingleChildScrollView(
                              child: SelectableText(solve),
                            ),
                            actions: [
                              TextButton(
                                child: const Text('Đóng'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text('Giải phương trình')
                  ),
              ],
            ),
            Divider(height: 2,),

            GraphChart(points: points),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
              onPressed: (){
                Navigator.pushNamed(context, '/calculator');
              },
              child: Text('Máy tính cơ bản')
          ),
          ElevatedButton(
              onPressed: (){
                Navigator.pushNamed(context, '/calculator-expression');
              },
              child: Text('Nhập biểu thức')
          ),
        ],
      ),
    );
  }

}