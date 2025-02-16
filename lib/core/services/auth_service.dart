// 管理画面から以下の設定をすることで、emailの確認をしなくて済む
// Supabase > Authentication > Providers > Email
// Confirm email を off

class AuthService {

  //
  // Sign Up : ユーザ登録
  //  - auth.usersテーブルにはユーザ名をハッシュ値に変換して登録
  //  - playersテーブルに、users.idを指定(外部キー制約のため)して登録
  //
  static Future<void> signUpWithUsername(supabase, username, password) async {
    String fakeEmail = "${username.hashCode}@example.com"; // ハッシュを使ってエラー回避
    final response = await supabase.auth.signUp(email: fakeEmail, password: password);

    if (response.user == null) {
      print("❌ユーザ登録: user.id is null");
      return;
    }

    try {
      // Players テーブルにユーザー名を登録
      await supabase.from('players').insert({
        'id': response.user!.id,
        'username': username,
      });
      print('✅ユーザ登録: ${response.user!.id}');
    } catch (e) {
      print('❌ユーザ登録: $e');
    }
  }

  //
  // Sign In : ログイン
  //
  static Future<void> signInWithUsername(supabase, username, password) async {
    // ユーザ名からダミーのメールアドレスを作成
    String fakeEmail = "${username.hashCode}@example.com"; // ハッシュを使ってエラー回避

    final response = await supabase.auth.signInWithPassword(
      email: fakeEmail,
      password: password,
    );

    if (response.user != null) {
      print("✅ログイン: ${response.user?.id}");
    } else {
      print("❌ログイン");
    }
  }

  //
  // ログインを試し、ログインできなかったらユーザ登録
  //
  static Future<void> signInOrSignUp(context, supabase, username, password) async {
    try {
      // まずログインを試みる
      await signInWithUsername(supabase, username, password);
    } catch (error) {
      if (error.toString().contains("Invalid login credentials")) {
        // ログイン失敗したら、新規登録を試す
        await signUpWithUsername(supabase, username, password);
      } else {
        // その他のエラーは throw する
        throw error;
      }
    }
  }

  //
  // ログイン済みか？
  //  
  static Future<bool> isUserLoggedIn(supabase) async {
    return supabase.auth.currentUser != null;
  }

  //
  // ログアウト
  //
  static Future<void> logout(supabase) async {
    await supabase.auth.signOut();
    if (supabase.auth.currentUser == null) {
      print("ログアウトしました");
    } else {
      print("ログアウト失敗");
    }
  }
}
