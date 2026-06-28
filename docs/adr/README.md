# Architecture Decision Records

このディレクトリには、GolfSwingAnalyzer アプリの設計上の重要な判断を ADR（Architecture Decision Record）形式で記録する。

## 一覧

| ID | タイトル | ステータス | 日付 |
|----|---------|-----------|------|
| [ADR-001](ADR-001-riverpod-state-management.md) | 状態管理に Riverpod を採用 | 承認済み | 2026-06-27 |
| [ADR-002](ADR-002-gorouter-navigation.md) | ルーティングに GoRouter を採用 | 承認済み | 2026-06-27 |
| [ADR-003](ADR-003-sqflite-and-filesystem-persistence.md) | メタデータは sqflite・動画本体はファイルシステムに保存 | 承認済み | 2026-06-27 |
| [ADR-004](ADR-004-camera-plugin-best-effort-fps-and-playback-slowmo.md) | カメラの高フレームレート撮影は best-effort とし、スロー再生でレビュー体験を実現 | 承認済み | 2026-06-27 |

## ADR の読み方

各 ADR は以下のセクションで構成される。

- **ステータス** — `提案中` / `承認済み` / `非推奨` / `差し替え済み`
- **コンテキスト** — この判断が必要になった背景・制約
- **判断** — 採用した内容
- **根拠** — 選択理由・比較した代替案
- **結果** — 採用による利点・トレードオフ・残課題
