# ADR-002: ルーティングに GoRouter を採用

- **ステータス:** 承認済み
- **日付:** 2026-06-27
- **決定者:** 開発チーム

---

## コンテキスト

本アプリの画面構成は「撮影」「履歴」の2タブ＋「再生レビュー」のフルスクリーン遷移というシンプルな構成。姉妹アプリ PlankTrainingApp は `go_router` の `StatefulShellRoute.indexedStack` でボトムナビのタブ状態を保持しており、本アプリでも一貫性のため同じ仕組みを採用するか検討した。

## 判断

`go_router` を採用し、`StatefulShellRoute.indexedStack` で「撮影」「履歴」の2ブランチを構成する。再生レビュー画面 (`/playback`) はタブ外のフルスクリーン `GoRoute` とし、`state.extra` で型付きの `PlaybackArgs`（`SwingSession` ＋ 新規録画直後かどうかのフラグ）を渡す。

```
/record   (タブ0)
/history  (タブ1)
/playback (フルスクリーン、state.extra: PlaybackArgs)
```

PlankTrainingApp と異なり、起動時のリダイレクト判定が不要なため `SplashScreen` は設けず、`initialLocation` を `/record` とする。

## 根拠

**選んだ理由（GoRouter + StatefulShellRoute.indexedStack）**
- タブが2つのみでも `StatefulShellRoute.indexedStack` の導入コストは低く、姉妹アプリと同じパターンを保つことで保守性が上がる
- 将来「履歴」にフィルタやスクロール位置保持が必要になっても、タブ切り替え時に状態が破棄されない
- `state.extra` による型付きオブジェクト渡しは PlankTrainingApp の `TrainingResultDto` 等と同じパターンで、レビュー担当者が読みやすい

**比較した代替案**

| 案 | 却下理由 |
|----|---------|
| `BottomNavigationBar` + 手動 `IndexedStack`（シェルルートなし） | タブが2つだけなら実装はやや簡潔になるが、姉妹アプリとの構造的な一貫性が失われる |
| `Navigator` 直接操作（go_router不使用） | 型安全なルート定義・`state.extra` によるオブジェクト受け渡しの恩恵がなくなる |

## 結果

**利点**
- PlankTrainingApp の `app.dart` と構造的に並行しており、相互参照・移植がしやすい
- 履歴タブが将来的に状態を持つようになっても拡張コストが低い

**トレードオフ**
- 2タブのみのアプリにはシェルルートの抽象化がやや過剰という見方もできる（意図的なトレードオフとして許容）

**残課題**
- 起動時のDB初期化に時間がかかる場合に備え、SplashScreen相当の起動ガードが将来的に必要になる可能性がある。現時点ではDB初期化は十分高速なため省略。
