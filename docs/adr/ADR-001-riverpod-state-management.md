# ADR-001: 状態管理に Riverpod を採用

- **ステータス:** 承認済み
- **日付:** 2026-06-27
- **決定者:** 開発チーム

---

## コンテキスト

GolfSwingAnalyzer はカメラ撮影・ローカルDB・動画ファイルアクセスといった非同期処理を多く扱う。これらの依存性注入（DI）と非同期状態（読み込み中／成功／失敗）を一貫した方法で扱う仕組みが必要。

姉妹アプリ PlankTrainingApp では `flutter_riverpod` を手動 Provider 宣言（コード生成なし）で採用しており、本アプリでも同じ規約を踏襲する方針とした。

## 判断

`flutter_riverpod` を採用する。`riverpod_generator`／`build_runner` は使用せず、すべての Provider は `lib/presentation/providers/providers.dart` に手動で宣言する。

- DI: `Provider`（`DatabaseService`、`CameraRecordingService`、`VideoStorageService`、リポジトリ、UseCase）
- 非同期データ取得: `FutureProvider` / `FutureProvider.family`（履歴一覧、ID指定のセッション取得）
- UI単純状態: `StateProvider`（再生速度選択）

画面は `ConsumerWidget` / `ConsumerStatefulWidget` で実装し、非同期データは `AsyncValue.when(data:, loading:, error:)` で網羅的に扱う。

なお、依存解決の結果 `flutter_riverpod` は ^3.3.2（Riverpod 3系）が導入された。`Provider`・`FutureProvider`・`FutureProvider.family`・`StateProvider`・`ConsumerWidget`・`AsyncValue` の基本APIは Riverpod 2系から変更なく利用できることを確認済み。

## 根拠

**選んだ理由（Riverpod・手動Provider）**
- compile-time安全な DI とテスト容易性（Provider の差し替えが容易）
- `build_runner` を使わないことでビルド手順がシンプルになる（姉妹アプリの方針と一致）
- カメラ・DB・ファイルI/Oといった非同期処理を `FutureProvider` + `AsyncValue.when` で統一的に扱える

**比較した代替案**

| 案 | 却下理由 |
|----|---------|
| Provider パッケージ単体 | 非同期状態の扱いが薄く、`AsyncValue` のような統一的な Loading/Error 表現がない |
| riverpod_generator（`@riverpod`） | コード生成ステップが増え、姉妹アプリの「`build_runner` 不使用」方針と矛盾する |
| setState のみ（状態管理パッケージ不使用） | DIの一貫した手段がなく、サービス層のテスト時にモック注入がしづらい |

## 結果

**利点**
- PlankTrainingApp と同じ書き方で画面・サービス間の依存を解決できる
- `AsyncValue.when` によりカメラ初期化・DB読み込みなどの失敗状態をUIに必ず反映させられる

**トレードオフ**
- Riverpod 3系への移行に伴うAPI変更（例: `StateNotifierProvider` は legacy 扱い）を将来的に追従する必要がある。本MVPでは `StateNotifierProvider` を使用していないため影響なし。

**残課題**
- 将来的にカメラの録画状態（録画中／停止）をより複雑な状態機械として扱う必要が出た場合、Riverpod 3 の `Notifier`/`AsyncNotifier` への移行を検討する。
