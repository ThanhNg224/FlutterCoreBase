// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'face_otp_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FaceOtpConfig {

 int get timeoutSeconds; double get livenessThreshold; LivenessMode get livenessMode; bool get recordSessionVideo;
/// Create a copy of FaceOtpConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FaceOtpConfigCopyWith<FaceOtpConfig> get copyWith => _$FaceOtpConfigCopyWithImpl<FaceOtpConfig>(this as FaceOtpConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FaceOtpConfig&&(identical(other.timeoutSeconds, timeoutSeconds) || other.timeoutSeconds == timeoutSeconds)&&(identical(other.livenessThreshold, livenessThreshold) || other.livenessThreshold == livenessThreshold)&&(identical(other.livenessMode, livenessMode) || other.livenessMode == livenessMode)&&(identical(other.recordSessionVideo, recordSessionVideo) || other.recordSessionVideo == recordSessionVideo));
}


@override
int get hashCode => Object.hash(runtimeType,timeoutSeconds,livenessThreshold,livenessMode,recordSessionVideo);

@override
String toString() {
  return 'FaceOtpConfig(timeoutSeconds: $timeoutSeconds, livenessThreshold: $livenessThreshold, livenessMode: $livenessMode, recordSessionVideo: $recordSessionVideo)';
}


}

/// @nodoc
abstract mixin class $FaceOtpConfigCopyWith<$Res>  {
  factory $FaceOtpConfigCopyWith(FaceOtpConfig value, $Res Function(FaceOtpConfig) _then) = _$FaceOtpConfigCopyWithImpl;
@useResult
$Res call({
 int timeoutSeconds, double livenessThreshold, LivenessMode livenessMode, bool recordSessionVideo
});




}
/// @nodoc
class _$FaceOtpConfigCopyWithImpl<$Res>
    implements $FaceOtpConfigCopyWith<$Res> {
  _$FaceOtpConfigCopyWithImpl(this._self, this._then);

  final FaceOtpConfig _self;
  final $Res Function(FaceOtpConfig) _then;

/// Create a copy of FaceOtpConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? timeoutSeconds = null,Object? livenessThreshold = null,Object? livenessMode = null,Object? recordSessionVideo = null,}) {
  return _then(FaceOtpConfig(
timeoutSeconds: null == timeoutSeconds ? _self.timeoutSeconds : timeoutSeconds // ignore: cast_nullable_to_non_nullable
as int,livenessThreshold: null == livenessThreshold ? _self.livenessThreshold : livenessThreshold // ignore: cast_nullable_to_non_nullable
as double,livenessMode: null == livenessMode ? _self.livenessMode : livenessMode // ignore: cast_nullable_to_non_nullable
as LivenessMode,recordSessionVideo: null == recordSessionVideo ? _self.recordSessionVideo : recordSessionVideo // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FaceOtpConfig].
extension FaceOtpConfigPatterns on FaceOtpConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FaceOtpConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FaceOtpConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FaceOtpConfig value)  $default,){
final _that = this;
switch (_that) {
case _FaceOtpConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FaceOtpConfig value)?  $default,){
final _that = this;
switch (_that) {
case _FaceOtpConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int timeoutSeconds,  double livenessThreshold,  LivenessMode livenessMode,  bool recordSessionVideo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FaceOtpConfig() when $default != null:
return $default(_that.timeoutSeconds,_that.livenessThreshold,_that.livenessMode,_that.recordSessionVideo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int timeoutSeconds,  double livenessThreshold,  LivenessMode livenessMode,  bool recordSessionVideo)  $default,) {final _that = this;
switch (_that) {
case _FaceOtpConfig():
return $default(_that.timeoutSeconds,_that.livenessThreshold,_that.livenessMode,_that.recordSessionVideo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int timeoutSeconds,  double livenessThreshold,  LivenessMode livenessMode,  bool recordSessionVideo)?  $default,) {final _that = this;
switch (_that) {
case _FaceOtpConfig() when $default != null:
return $default(_that.timeoutSeconds,_that.livenessThreshold,_that.livenessMode,_that.recordSessionVideo);case _:
  return null;

}
}

}

/// @nodoc


class _FaceOtpConfig implements FaceOtpConfig {
  const _FaceOtpConfig({this.timeoutSeconds = 30, this.livenessThreshold = 0.85, this.livenessMode = LivenessMode.passive3D, this.recordSessionVideo = true});
  

@override@JsonKey() final  int timeoutSeconds;
@override@JsonKey() final  double livenessThreshold;
@override@JsonKey() final  LivenessMode livenessMode;
@override@JsonKey() final  bool recordSessionVideo;

/// Create a copy of FaceOtpConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FaceOtpConfigCopyWith<_FaceOtpConfig> get copyWith => __$FaceOtpConfigCopyWithImpl<_FaceOtpConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FaceOtpConfig&&(identical(other.timeoutSeconds, timeoutSeconds) || other.timeoutSeconds == timeoutSeconds)&&(identical(other.livenessThreshold, livenessThreshold) || other.livenessThreshold == livenessThreshold)&&(identical(other.livenessMode, livenessMode) || other.livenessMode == livenessMode)&&(identical(other.recordSessionVideo, recordSessionVideo) || other.recordSessionVideo == recordSessionVideo));
}


@override
int get hashCode => Object.hash(runtimeType,timeoutSeconds,livenessThreshold,livenessMode,recordSessionVideo);

@override
String toString() {
  return 'FaceOtpConfig(timeoutSeconds: $timeoutSeconds, livenessThreshold: $livenessThreshold, livenessMode: $livenessMode, recordSessionVideo: $recordSessionVideo)';
}


}

/// @nodoc
abstract mixin class _$FaceOtpConfigCopyWith<$Res> implements $FaceOtpConfigCopyWith<$Res> {
  factory _$FaceOtpConfigCopyWith(_FaceOtpConfig value, $Res Function(_FaceOtpConfig) _then) = __$FaceOtpConfigCopyWithImpl;
@override @useResult
$Res call({
 int timeoutSeconds, double livenessThreshold, LivenessMode livenessMode, bool recordSessionVideo
});




}
/// @nodoc
class __$FaceOtpConfigCopyWithImpl<$Res>
    implements _$FaceOtpConfigCopyWith<$Res> {
  __$FaceOtpConfigCopyWithImpl(this._self, this._then);

  final _FaceOtpConfig _self;
  final $Res Function(_FaceOtpConfig) _then;

/// Create a copy of FaceOtpConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? timeoutSeconds = null,Object? livenessThreshold = null,Object? livenessMode = null,Object? recordSessionVideo = null,}) {
  return _then(_FaceOtpConfig(
timeoutSeconds: null == timeoutSeconds ? _self.timeoutSeconds : timeoutSeconds // ignore: cast_nullable_to_non_nullable
as int,livenessThreshold: null == livenessThreshold ? _self.livenessThreshold : livenessThreshold // ignore: cast_nullable_to_non_nullable
as double,livenessMode: null == livenessMode ? _self.livenessMode : livenessMode // ignore: cast_nullable_to_non_nullable
as LivenessMode,recordSessionVideo: null == recordSessionVideo ? _self.recordSessionVideo : recordSessionVideo // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
