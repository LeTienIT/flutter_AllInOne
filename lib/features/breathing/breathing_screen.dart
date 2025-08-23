import 'package:flutter/material.dart';

class BreathingScreen extends StatefulWidget{
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() {
    return _BreathingScreen();
  }
}
class _BreathingScreen extends State<BreathingScreen>{
  int selectE = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Các bài hít thở"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Text('Chọn bài',textAlign: TextAlign.center,style: Theme.of(context).textTheme.titleMedium,),
            SizedBox(height: 10,),
            _buildOption(),
            SizedBox(height: 10,),
            _buildContent(),
            SizedBox(height: 10,),
            ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/breathing-run', arguments: selectE);
                },
                child: Text("Bắt đầu")
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOption(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildOptionItem(0, 'Bài 1', ''),
        _buildOptionItem(1, 'Bài 2', ''),
        _buildOptionItem(2, 'Bài 3', ''),
      ],
    );
  }
  Widget _buildOptionItem(int stt,String title, String content){
    return GestureDetector(
      onTap: () => setState(() {
        selectE = stt;
      }),
      child: Card(
        color: selectE == stt ? Colors.blue : Colors.white ,
        elevation: selectE==stt?4:1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(16),
          side: BorderSide(color: selectE==stt?Colors.blue:Colors.grey),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(title,style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center,),
        ),
      ),
    );
  }
  Widget _buildContent(){
    String content = "", sub = "";
    switch(selectE){
      case 0: content = "Giảm áp lực nhanh chóng"; sub = "Hít vào trong 5 giây.\nThở ra trong 5 giây";break;
      case 1: content = "Hữu ích khi một cảm xúc bị chặn lại, khi mà bạn cần có một cuộc trò chuyện quan trọng, hoặc khi bạn cảm thấy sợ hãi"; sub="Hít vào trong 5 giây.\nGiữ hơi trong 5 giây (phổi đầy).\nThở ra trong 5 giây.\nGiữ hơi trong 5 giây (phổi trống)";break;
      case 2: content = "Trong trường hợp mệt mỏi tạm thời, tập thở có thể thực sự là một động lực, giúp lấy lại năng lượng";sub='Hít vào qua mũi trong 4 giây.\nGiữ hơi trong 7 giây.\nThở ra qua miệng với âm thanh \'vút\' trong khi đếm đến 8.';break;
    }
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(content,style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 10,),
            Text(
              sub,
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.green
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}