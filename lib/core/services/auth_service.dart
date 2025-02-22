// 管理画面から以下の設定をすることで、emailの確認をしなくて済む
// Supabase > Authentication > Providers > Email
// Confirm email を off

import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {

  // //
  // // 認証状態のチェック
  // //
  // static Future<void> checkAuthStatus(context, supabase) async {
  //   final user = supabase.auth.currentUser;

  //   if (user != null) {
  //     // 認証トークンがある場合、サーバーにユーザ情報があるか確認
  //     final response = await supabase.from('players').select().eq('id', user.id).single();

  //     if (response.error != null) {
  //       // サーバーにユーザ情報がない場合 → サインアウトして登録画面へ
  //       await logout(supabase);
  //       Navigator.pushReplacementNamed(context, '/signup');
  //     } else {
  //       // サーバーにユーザ情報がある → タイトル画面へ
  //       Navigator.pushReplacementNamed(context, '/title');
  //     }
  //   } else {
  //     // 認証トークンがない場合、ユーザ名で検索
  //     final response = await supabase.from('players').select('id').eq('username', username).single();

  //     if (response.error != null) {
  //       // ユーザ情報がない → ユーザ登録画面へ
  //       Navigator.pushReplacementNamed(context, '/signup');
  //     } else {
  //       // ユーザ情報がある → ログイン画面へ
  //       Navigator.pushReplacementNamed(context, '/login');
  //     }
  //   }
  // }
  
  //
  // Sign Up : ユーザ登録
  //  - auth.usersテーブルにはユーザ名をハッシュ値に変換して登録
  //  - playersテーブルに、users.idを指定(外部キー制約のため)して登録
  //
  static Future<void> signUpWithUsername(supabase, username, password) async {
    String fakeEmail = "${username.hashCode}@example.com"; // ハッシュを使ってエラー回避
    final response = await supabase.auth.signUp(email: fakeEmail, password: password);

    if (response.user == null) {
      log("❌ユーザ登録: user.id is null");
      throw Exception("❌ ユーザ登録失敗: user.id is null");
    }

    try {
      // Players テーブルにユーザー名を登録
      await supabase.from('players').insert({
        'id': response.user!.id,
        'username': username,
      });
      log('✅ユーザ登録: ${response.user!.id}');
    } catch (e) {
      log('❌ユーザ登録: $e');
      throw Exception("❌ Playersテーブルへの登録失敗: $e");
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
      log("✅ログイン: ${response.user?.id}");
    } else {
      log("❌ログイン");
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
        try {
          await signUpWithUsername(supabase, username, password);
        } catch (signUpError) {
          throw Exception("ユーザ登録に失敗しました: $signUpError");
        }
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
    final user = supabase.auth.currentUser;

    if (user != null) {
      try {
        // 認証トークンがある場合、サーバーにユーザ情報があるか確認
        await supabase.from('players').select().eq('id', user.id).single();
      } on PostgrestException catch(_) {
        // 認証トークンあり / サーバーにユーザ情報なし
        return false;
      }
      // 認証トークンあり / サーバーにユーザ情報あり
      return true;
    }

    // 認証トークンなし
    return false;
  }

  //
  // ログアウト
  //
  static Future<void> logout(supabase) async {
    await supabase.auth.signOut();
    if (supabase.auth.currentUser == null) {
      log("ログアウトしました");
    } else {
      log("ログアウト失敗");
    }
  }
}
