# ADR-004: カメラの高フレームレート撮影は best-effort とし、スロー再生でレビュー体験を実現

- **ステータス:** 承認済み
- **日付:** 2026-06-27
- **決定者:** 開発チーム

---

## コンテキスト

本アプリの中核機能は「ボールの真上から撮影したスイング動画をスローモーションで確認する」こと。スマートフォン標準カメラアプリの多くは Android の Camera2 API における `createConstrainedHighSpeedCaptureSession`（高速撮影セッション）を使い、真の120fps/240fps撮影を実現している。

一方、Flutterの `camera` プラグインはこの高速撮影セッションAPIを公開していない。`CameraController` の `fps` パラメータは `MediaRecorder`／通常の撮影セッションに対する目標値の指定であり、実際に何fpsで撮影されたかを撮影後に検証する手段も提供されない。真の高速撮影を実現するには、`StreamConfigurationMap.getHighSpeedVideoFpsRanges()` 等を用いたネイティブKotlin実装（プラットフォームチャンネル）が必要になり、MVPの開発コストとして見合わない。

## 判断

MVPでは以下の方針を採用する。

1. **撮影**: `CameraController(camera, ResolutionPreset.high, enableAudio: false, fps: 60)` で60fpsを目標値として要求し、通常の録画フローで撮影する（`lib/data/services/camera_recording_service.dart`）。実際の達成fpsは検証せず、要求値を `SwingSession.targetFps` として「目標値」の扱いでUIに表示する。
2. **スロー再生**: 撮影自体は通常速度のまま行い、`video_player` の `setPlaybackSpeed()` で 1.0 / 0.5 / 0.25 / 0.1 倍速の再生を提供することで「スローモーションで確認する」というユーザー体験を実現する（`lib/presentation/screens/playback/playback_screen.dart`）。再生音声は録画時に `enableAudio: false`、再生時に `setVolume(0)` の両方でミュートする。
3. **フレームステップ送り**: `video_player` にフレーム精度のシークAPIがないため、`1000 / targetFps` ミリ秒を1フレーム相当として `seekTo(現在位置 ± フレーム長)` で近似する。H.264のキーフレーム間隔により、実際の移動量が1フレームより大きくなる場合があることを既知の制約として受け入れる。

## 根拠

**選んだ理由（camera プラグインのbest-effort fps + 再生側スロー化）**
- 追加のネイティブ実装が不要で、MVPの開発期間内で「撮影→スロー確認」という核心体験を提供できる
- `camera`／`video_player` という公式メンテナンスのFlutterプラグインのみで完結し、保守性が高い

**比較した代替案**

| 案 | 却下理由 |
|----|---------|
| ネイティブKotlinで `CameraConstrainedHighSpeedCaptureSession` を実装する独自プラグイン | 真の120/240fps撮影が可能になる一方、機種ごとの高速撮影サイズ・fps範囲の問い合わせ・`MediaRecorder`再構成など実装範囲が大きく、MVPのスコープを超える |
| サードパーティの「スローモーション撮影」Flutterプラグインを利用 | 調査時点でAndroidの高速撮影セッションAPIを直接公開する、広く使われている保守的なFlutterプラグインは見当たらず、依存先として採用するリスクが高い |
| `video_thumbnail`/FFmpeg等でフレーム精度シークを実装 | MVPの「スロー再生で確認できればよい」という要件に対して過剰な実装コストであり、将来フェーズに切り出す |

## 結果

**利点**
- 開発コストを抑えつつ、ユーザーが求める「スイングをスローで確認する」体験のコア部分を提供できる
- 録音を無効化したことで `RECORD_AUDIO` 権限が不要になり、権限要求がカメラのみに簡素化された

**トレードオフ**
- 表示される目標fpsは実際の撮影fpsを保証しない近似値
- フレームステップ送りの精度はキーフレーム間隔に依存し、真の1フレーム単位ではない

**残課題**
- 将来的に打ち出し角の自動解析（本MVPでは明確に対象外）を実装する場合、実際の撮影fpsの精度が重要になる可能性がある。その時点でネイティブ高速撮影実装、もしくはfps検証手段の追加を再検討する。
- 撮影解像度プリセット（`ResolutionPreset.high` 固定）とfps目標値（60固定）の最適な組み合わせは実機依存のため、実機検証後に調整が必要。
