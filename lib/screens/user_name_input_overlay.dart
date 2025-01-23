import 'package:flutter/material.dart';

class UserNameInputOverlay extends StatelessWidget {
  final Function(String) onSave;

  UserNameInputOverlay({required this.onSave});

  final TextEditingController _controller = TextEditingController(); // コントローラーを管理

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 5),
          color: Colors.lightGreen,
        ),
        padding: const EdgeInsets.all(16),
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter Your Name',
              style: TextStyle(
                fontFamily: 'PixelFont', // ドット絵風フォントを指定
                color: Colors.brown,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller, // コントローラーをTextFieldに設定
              style: TextStyle(
                fontFamily: 'PixelFont',
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: 'Your name',
                hintStyle: TextStyle(
                  fontFamily: 'PixelFont',
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final value = _controller.text.trim(); // コントローラーからテキストを取得
                if (value.isNotEmpty) {
                  onSave(value); // 入力値を保存
                } else {
                  // 必要に応じてエラー表示
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("ユーザー名を入力してください")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
