// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'swing_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SwingSession {

 int get id; VideoPath get videoPath; DateTime get recordedAt; SwingDuration get duration; Fps get targetFps; String? get note; bool get impactDetected; List<SwingAnalysisAttribute> get analysisAttributes;
/// Create a copy of SwingSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SwingSessionCopyWith<SwingSession> get copyWith => _$SwingSessionCopyWithImpl<SwingSession>(this as SwingSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SwingSession&&(identical(other.id, id) || other.id == id)&&(identical(other.videoPath, videoPath) || other.videoPath == videoPath)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.targetFps, targetFps) || other.targetFps == targetFps)&&(identical(other.note, note) || other.note == note)&&(identical(other.impactDetected, impactDetected) || other.impactDetected == impactDetected)&&const DeepCollectionEquality().equals(other.analysisAttributes, analysisAttributes));
}


@override
int get hashCode => Object.hash(runtimeType,id,videoPath,recordedAt,duration,targetFps,note,impactDetected,const DeepCollectionEquality().hash(analysisAttributes));

@override
String toString() {
  return 'SwingSession(id: $id, videoPath: $videoPath, recordedAt: $recordedAt, duration: $duration, targetFps: $targetFps, note: $note, impactDetected: $impactDetected, analysisAttributes: $analysisAttributes)';
}


}

/// @nodoc
abstract mixin class $SwingSessionCopyWith<$Res>  {
  factory $SwingSessionCopyWith(SwingSession value, $Res Function(SwingSession) _then) = _$SwingSessionCopyWithImpl;
@useResult
$Res call({
 int id, VideoPath videoPath, DateTime recordedAt, SwingDuration duration, Fps targetFps, String? note, bool impactDetected, List<SwingAnalysisAttribute> analysisAttributes
});




}
/// @nodoc
class _$SwingSessionCopyWithImpl<$Res>
    implements $SwingSessionCopyWith<$Res> {
  _$SwingSessionCopyWithImpl(this._self, this._then);

  final SwingSession _self;
  final $Res Function(SwingSession) _then;

/// Create a copy of SwingSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? videoPath = null,Object? recordedAt = null,Object? duration = null,Object? targetFps = null,Object? note = freezed,Object? impactDetected = null,Object? analysisAttributes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,videoPath: null == videoPath ? _self.videoPath : videoPath // ignore: cast_nullable_to_non_nullable
as VideoPath,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as SwingDuration,targetFps: null == targetFps ? _self.targetFps : targetFps // ignore: cast_nullable_to_non_nullable
as Fps,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,impactDetected: null == impactDetected ? _self.impactDetected : impactDetected // ignore: cast_nullable_to_non_nullable
as bool,analysisAttributes: null == analysisAttributes ? _self.analysisAttributes : analysisAttributes // ignore: cast_nullable_to_non_nullable
as List<SwingAnalysisAttribute>,
  ));
}

}


/// Adds pattern-matching-related methods to [SwingSession].
extension SwingSessionPatterns on SwingSession {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SwingSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SwingSession() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SwingSession value)  $default,){
final _that = this;
switch (_that) {
case _SwingSession():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SwingSession value)?  $default,){
final _that = this;
switch (_that) {
case _SwingSession() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  VideoPath videoPath,  DateTime recordedAt,  SwingDuration duration,  Fps targetFps,  String? note,  bool impactDetected,  List<SwingAnalysisAttribute> analysisAttributes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SwingSession() when $default != null:
return $default(_that.id,_that.videoPath,_that.recordedAt,_that.duration,_that.targetFps,_that.note,_that.impactDetected,_that.analysisAttributes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  VideoPath videoPath,  DateTime recordedAt,  SwingDuration duration,  Fps targetFps,  String? note,  bool impactDetected,  List<SwingAnalysisAttribute> analysisAttributes)  $default,) {final _that = this;
switch (_that) {
case _SwingSession():
return $default(_that.id,_that.videoPath,_that.recordedAt,_that.duration,_that.targetFps,_that.note,_that.impactDetected,_that.analysisAttributes);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  VideoPath videoPath,  DateTime recordedAt,  SwingDuration duration,  Fps targetFps,  String? note,  bool impactDetected,  List<SwingAnalysisAttribute> analysisAttributes)?  $default,) {final _that = this;
switch (_that) {
case _SwingSession() when $default != null:
return $default(_that.id,_that.videoPath,_that.recordedAt,_that.duration,_that.targetFps,_that.note,_that.impactDetected,_that.analysisAttributes);case _:
  return null;

}
}

}

/// @nodoc


class _SwingSession extends SwingSession {
  const _SwingSession({required this.id, required this.videoPath, required this.recordedAt, required this.duration, required this.targetFps, this.note, this.impactDetected = true, final  List<SwingAnalysisAttribute> analysisAttributes = const []}): _analysisAttributes = analysisAttributes,super._();
  

@override final  int id;
@override final  VideoPath videoPath;
@override final  DateTime recordedAt;
@override final  SwingDuration duration;
@override final  Fps targetFps;
@override final  String? note;
@override@JsonKey() final  bool impactDetected;
 final  List<SwingAnalysisAttribute> _analysisAttributes;
@override@JsonKey() List<SwingAnalysisAttribute> get analysisAttributes {
  if (_analysisAttributes is EqualUnmodifiableListView) return _analysisAttributes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_analysisAttributes);
}


/// Create a copy of SwingSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SwingSessionCopyWith<_SwingSession> get copyWith => __$SwingSessionCopyWithImpl<_SwingSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SwingSession&&(identical(other.id, id) || other.id == id)&&(identical(other.videoPath, videoPath) || other.videoPath == videoPath)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.targetFps, targetFps) || other.targetFps == targetFps)&&(identical(other.note, note) || other.note == note)&&(identical(other.impactDetected, impactDetected) || other.impactDetected == impactDetected)&&const DeepCollectionEquality().equals(other._analysisAttributes, _analysisAttributes));
}


@override
int get hashCode => Object.hash(runtimeType,id,videoPath,recordedAt,duration,targetFps,note,impactDetected,const DeepCollectionEquality().hash(_analysisAttributes));

@override
String toString() {
  return 'SwingSession(id: $id, videoPath: $videoPath, recordedAt: $recordedAt, duration: $duration, targetFps: $targetFps, note: $note, impactDetected: $impactDetected, analysisAttributes: $analysisAttributes)';
}


}

/// @nodoc
abstract mixin class _$SwingSessionCopyWith<$Res> implements $SwingSessionCopyWith<$Res> {
  factory _$SwingSessionCopyWith(_SwingSession value, $Res Function(_SwingSession) _then) = __$SwingSessionCopyWithImpl;
@override @useResult
$Res call({
 int id, VideoPath videoPath, DateTime recordedAt, SwingDuration duration, Fps targetFps, String? note, bool impactDetected, List<SwingAnalysisAttribute> analysisAttributes
});




}
/// @nodoc
class __$SwingSessionCopyWithImpl<$Res>
    implements _$SwingSessionCopyWith<$Res> {
  __$SwingSessionCopyWithImpl(this._self, this._then);

  final _SwingSession _self;
  final $Res Function(_SwingSession) _then;

/// Create a copy of SwingSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? videoPath = null,Object? recordedAt = null,Object? duration = null,Object? targetFps = null,Object? note = freezed,Object? impactDetected = null,Object? analysisAttributes = null,}) {
  return _then(_SwingSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,videoPath: null == videoPath ? _self.videoPath : videoPath // ignore: cast_nullable_to_non_nullable
as VideoPath,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as SwingDuration,targetFps: null == targetFps ? _self.targetFps : targetFps // ignore: cast_nullable_to_non_nullable
as Fps,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,impactDetected: null == impactDetected ? _self.impactDetected : impactDetected // ignore: cast_nullable_to_non_nullable
as bool,analysisAttributes: null == analysisAttributes ? _self._analysisAttributes : analysisAttributes // ignore: cast_nullable_to_non_nullable
as List<SwingAnalysisAttribute>,
  ));
}


}

// dart format on
