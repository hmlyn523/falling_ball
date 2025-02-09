import 'package:flutter/material.dart';

class UserNameInputOverlay extends StatelessWidget {
  final Function(String, String) onSave;

  UserNameInputOverlay({required this.onSave});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                fontFamily: 'PixelFont',
                color: Colors.brown,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _nameController,
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
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Enter Your Password',
              style: TextStyle(
                fontFamily: 'PixelFont',
                color: Colors.brown,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: TextStyle(
                fontFamily: 'PixelFont',
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(
                  fontFamily: 'PixelFont',
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();
                final password = _passwordController.text.trim();

                if (name.isNotEmpty && password.isNotEmpty) {
                  onSave(name, password);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("ユーザー名とパスワードを入力してください")),
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
