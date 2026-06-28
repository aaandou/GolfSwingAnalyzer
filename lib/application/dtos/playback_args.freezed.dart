// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playback_args.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlaybackArgs {

 SwingSession get session; bool get isFreshRecording;
/// Create a copy of PlaybackArgs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaybackArgsCopyWith<PlaybackArgs> get copyWith => _$PlaybackArgsCopyWithImpl<PlaybackArgs>(this as PlaybackArgs, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaybackArgs&&(identical(other.session, session) || other.session == session)&&(identical(other.isFreshRecording, isFreshRecording) || other.isFreshRecording == isFreshRecording));
}


@override
int get hashCode => Object.hash(runtimeType,session,isFreshRecording);

@override
String toString() {
  return 'PlaybackArgs(session: $session, isFreshRecording: $isFreshRecording)';
}


}

/// @nodoc
abstract mixin class $PlaybackArgsCopyWith<$Res>  {
  factory $PlaybackArgsCopyWith(PlaybackArgs value, $Res Function(PlaybackArgs) _then) = _$PlaybackArgsCopyWithImpl;
@useResult
$Res call({
 SwingSession session, bool isFreshRecording
});


$SwingSessionCopyWith<$Res> get session;

}
/// @nodoc
class _$PlaybackArgsCopyWithImpl<$Res>
    implements $PlaybackArgsCopyWith<$Res> {
  _$PlaybackArgsCopyWithImpl(this._self, this._then);

  final PlaybackArgs _self;
  final $Res Function(PlaybackArgs) _then;

/// Create a copy of PlaybackArgs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? session = null,Object? isFreshRecording = null,}) {
  return _then(_self.copyWith(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as SwingSession,isFreshRecording: null == isFreshRecording ? _self.isFreshRecording : isFreshRecording // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of PlaybackArgs
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SwingSessionCopyWith<$Res> get session {
  
  return $SwingSessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlaybackArgs].
extension PlaybackArgsPatterns on PlaybackArgs {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlaybackArgs value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlaybackArgs() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlaybackArgs value)  $default,){
final _that = this;
switch (_that) {
case _PlaybackArgs():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlaybackArgs value)?  $default,){
final _that = this;
switch (_that) {
case _PlaybackArgs() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SwingSession session,  bool isFreshRecording)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlaybackArgs() when $default != null:
return $default(_that.session,_that.isFreshRecording);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SwingSession session,  bool isFreshRecording)  $default,) {final _that = this;
switch (_that) {
case _PlaybackArgs():
return $default(_that.session,_that.isFreshRecording);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SwingSession session,  bool isFreshRecording)?  $default,) {final _that = this;
switch (_that) {
case _PlaybackArgs() when $default != null:
return $default(_that.session,_that.isFreshRecording);case _:
  return null;

}
}

}

/// @nodoc


class _PlaybackArgs implements PlaybackArgs {
  const _PlaybackArgs({required this.session, required this.isFreshRecording});
  

@override final  SwingSession session;
@override final  bool isFreshRecording;

/// Create a copy of PlaybackArgs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaybackArgsCopyWith<_PlaybackArgs> get copyWith => __$PlaybackArgsCopyWithImpl<_PlaybackArgs>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlaybackArgs&&(identical(other.session, session) || other.session == session)&&(identical(other.isFreshRecording, isFreshRecording) || other.isFreshRecording == isFreshRecording));
}


@override
int get hashCode => Object.hash(runtimeType,session,isFreshRecording);

@override
String toString() {
  return 'PlaybackArgs(session: $session, isFreshRecording: $isFreshRecording)';
}


}

/// @nodoc
abstract mixin class _$PlaybackArgsCopyWith<$Res> implements $PlaybackArgsCopyWith<$Res> {
  factory _$PlaybackArgsCopyWith(_PlaybackArgs value, $Res Function(_PlaybackArgs) _then) = __$PlaybackArgsCopyWithImpl;
@override @useResult
$Res call({
 SwingSession session, bool isFreshRecording
});


@override $SwingSessionCopyWith<$Res> get session;

}
/// @nodoc
class __$PlaybackArgsCopyWithImpl<$Res>
    implements _$PlaybackArgsCopyWith<$Res> {
  __$PlaybackArgsCopyWithImpl(this._self, this._then);

  final _PlaybackArgs _self;
  final $Res Function(_PlaybackArgs) _then;

/// Create a copy of PlaybackArgs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? session = null,Object? isFreshRecording = null,}) {
  return _then(_PlaybackArgs(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as SwingSession,isFreshRecording: null == isFreshRecording ? _self.isFreshRecording : isFreshRecording // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of PlaybackArgs
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SwingSessionCopyWith<$Res> get session {
  
  return $SwingSessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}
}

// dart format on
