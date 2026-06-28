# ADR-003: メタデータは sqflite・動画本体はファイルシステムに保存

- **ステータス:** 承認済み
- **日付:** 2026-06-27
- **決定者:** 開発チーム

---

## コンテキスト

撮影したスイング動画（数MB〜数十MB）と、その付帯情報（撮影日時・再生時間・目標fps・メモ）を永続化する必要がある。姉妹アプリ PlankTrainingApp は `sqflite` を採用しており（ADR-003-sqflite-over-isar 参照）、本アプリでも同じDBエンジンを使う方針自体は前提とした上で、「動画本体もDBに含めるか」を新たに判断する必要があった。

## 判断

`SwingSession` のメタデータ（id・videoPath・recordedAt・durationMs・targetFps・note）のみを sqflite の `swing_sessions` テーブルに保存する。動画ファイル本体は `path_provider` のアプリドキュメントディレクトリ配下 `<appDocsDir>/swings/<timestamp>.mp4` に保存し、DBには絶対パス文字列のみを記録する。

```sql
CREATE TABLE swing_sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  videoPath TEXT NOT NULL,
  recordedAt TEXT NOT NULL,
  durationMs INTEGER NOT NULL,
  targetFps INTEGER NOT NULL,
  note TEXT
)
```

セッション削除時は `VideoStorageService` でファイルを削除した後、DB行を削除する（`SwingSessionRepository.delete` が両方を担う）。

## 根拠

**動画をDBのBLOBに保存しない理由**
- 数MB〜数十MBの動画をSQLiteのBLOBに格納すると、ページキャッシュの肥大化・クエリ速度の劣化を招く
- `camera`（録画）・`video_player`（再生）はいずれもファイルパスを起点に動作するため、ファイルシステム保存の方が両プラグインとの統合が自然
- アプリ専用ドキュメントディレクトリに保存すればアプリ削除時に自動的にクリーンアップされ、追加のストレージ権限も不要

**比較した代替案**

| 案 | 却下理由 |
|----|---------|
| 動画をBLOBとしてsqfliteに保存 | クエリ性能劣化・メモリ使用量増加のリスクが高く、再生時に毎回ファイルへ書き出す手間が発生する |
| 外部（公開）ストレージに保存 | Android スコープドストレージ対応・追加の実行時権限が必要になり、MVPの複雑度を不必要に上げる |

## 結果

**利点**
- DBは小さな構造化データのみを扱うため高速かつシンプル
- アプリ専用ディレクトリのためストレージ権限が不要

**トレードオフ**
- DB行とファイルの整合性を手動で保つ必要がある（削除時に両方を確実に消す実装が必要）

**残課題**
- アプリの異常終了等でファイルだけが孤立する（DB行はないがファイルは残る）ケースのクリーンアップ処理は未実装。利用規模が増えた場合は起動時の整合性チェックを追加することを検討する。
