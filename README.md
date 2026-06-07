# point_launcher（ろけらん）

**ろけらん**は、現在地に応じてアプリやURLを提案・起動できる「位置情報ランチャー」アプリです。
よく行く場所にアプリやWebサイトを紐づけておくことで、その場所に近づいたときにホーム画面から素早くアクセスできます。

## 主な機能

- **位置情報に基づくアプリ提案**
  現在地から一定の半径（検索範囲）内に登録された地点があると、ホーム画面にそのアプリ・URLを候補として表示します。
- **アプリ／URLの登録**
  - アプリモード: 端末にインストール済みのアプリを検索・選択し、現在地に紐づけて登録できます。
  - URLモード: 共有機能などからURLを受け取り、メモ（ラベル）を付けて現在地に登録できます（favicon を取得して表示）。
- **登録地点（バインディング）の管理**
  登録済みのアプリ・URLとその位置メモ、利用回数の確認、ラベル編集、削除、Googleマップでの位置確認などができます。
- **よく使うアプリの表示**
  位置登録の回数などをもとに、よく使われているアプリ・URLをホーム画面に表示します。
- **検索範囲（半径）の設定**
  位置情報の判定に使う検索半径をプリセットから選んで変更できます。

## 技術スタック

- [Flutter](https://flutter.dev/) / Dart
- 状態管理: [flutter_riverpod](https://pub.dev/packages/flutter_riverpod)
- ローカルDB: [drift](https://pub.dev/packages/drift)（SQLite）
- 位置情報: [geolocator](https://pub.dev/packages/geolocator) / [permission_handler](https://pub.dev/packages/permission_handler)
- その他: [url_launcher](https://pub.dev/packages/url_launcher), [shared_preferences](https://pub.dev/packages/shared_preferences), [path_provider](https://pub.dev/packages/path_provider)

## 開発環境のセットアップ

```bash
flutter pub get
flutter run
```

コード生成（drift / riverpod）が必要な場合は以下を実行してください。

```bash
dart run build_runner build --delete-conflicting-outputs
```

## ビルド

Android 向けリリースビルドは [.github/workflows/android-release.yml](.github/workflows/android-release.yml) のワークフローでビルドできます。
