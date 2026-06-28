/// スイングレビュー画面に表示する解析結果1件分を表す表示用インターフェース。
///
/// 新しい解析（クラブスピード、スイングパス等）を追加する際は、このインターフェースを
/// 実装するVOを1つ追加するだけでよく、表示側（PlaybackScreen）の変更は不要にする。
abstract interface class SwingAnalysisAttribute {
  String get label;
  String get displayValue;
}
