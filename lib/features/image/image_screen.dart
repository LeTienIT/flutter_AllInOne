import 'package:all_in_one_tool/features/image/service/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pro_image_editor/core/models/editor_callbacks/pro_image_editor_callbacks.dart';
import 'package:pro_image_editor/features/main_editor/main_editor.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  Uint8List? imageBytes;
  bool enableBtn = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chỉnh sửa ảnh")),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final file = await ImagePickerService().pickImageFromGallery();
                if (file != null) {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProImageEditor.file(
                          file,
                          callbacks: ProImageEditorCallbacks(
                            onImageEditingComplete: (byte) async {
                              Navigator.pop(context, byte);
                            }
                          )
                      ),
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      imageBytes = result;
                    });
                  }
                }
              },
              child: const Text("Chọn & chỉnh sửa ảnh"),
            ),
            if (imageBytes != null)...[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                child: Image.memory(
                  imageBytes!,
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (imageBytes != null) {
                        final editedBytes = await Navigator.push<Uint8List>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProImageEditor.memory(
                              imageBytes!,
                              callbacks: ProImageEditorCallbacks(
                                onImageEditingComplete: (bytes) async {
                                  Navigator.pop(context, bytes);
                                },
                              ),
                            ),
                          ),
                        );

                        if (editedBytes != null) {
                          setState(() {
                            imageBytes = editedBytes;
                          });
                        }
                      }
                    },
                    child: const Text("Chỉnh sửa"),
                  ),
                  ElevatedButton(
                    onPressed: enableBtn ? () async {
                      if(imageBytes!=null){
                        setState(() {
                          enableBtn = false;
                        });
                        final rs = await ImagePickerService().saveImageToGallery(imageBytes!);
                        if(rs == 1){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã lưu ảnh vào thư viên'), backgroundColor: Colors.green,));
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Không lưu được ảnh'), backgroundColor: Colors.redAccent,));
                        }
                        setState(() {
                          enableBtn = true;
                        });
                      }

                    } : null,
                    child: const Text("Lưu ảnh"),
                  ),
                ],
              )
            ]
            else
              const Text("Chưa có ảnh nào được chọn"),

            Divider(height: 5,),
          ],
        ),
      )
    );
  }
}
