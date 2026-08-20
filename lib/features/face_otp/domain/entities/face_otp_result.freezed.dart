// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'face_otp_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FaceOtpResult {

 String get sessionId; VerificationStatus get status; double get similarityScore; double get livenessScore; String get token; DateTime get verifiedAt; String? get faceImageBase64;
/// Create a copy of FaceOtpResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FaceOtpResultCopyWith<FaceOtpResult> get copyWith => _$FaceOtpResultCopyWithImpl<FaceOtpResult>(this as FaceOtpResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FaceOtpResult&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.status, status) || other.status == status)&&(identical(other.similarityScore, similarityScore) || other.similarityScore == similarityScore)&&(identical(other.livenessScore, livenessScore) || other.livenessScore == livenessScore)&&(identical(other.token, token) || other.token == token)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt)&&(identical(other.faceImageBase64, faceImageBase64) || other.faceImageBase64 == faceImageBase64));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,status,similarityScore,livenessScore,token,verifiedAt,faceImageBase64);

@override
String toString() {
  return 'FaceOtpResult(sessionId: $sessionId, status: $status, similarityScore: $similarityScore, livenessScore: $livenessScore, token: $token, verifiedAt: $verifiedAt, faceImageBase64: $faceImageBase64)';
}


}

/// @nodoc
abstract mixin class $FaceOtpResultCopyWith<$Res>  {
  factory $FaceOtpResultCopyWith(FaceOtpResult value, $Res Function(FaceOtpResult) _then) = _$FaceOtpResultCopyWithImpl;
@useResult
$Res call({
 String sessionId, VerificationStatus status, double similarityScore, double livenessScore, String token, DateTime verifiedAt, String? faceImageBase64
});




}
/// @nodoc
class _$FaceOtpResultCopyWithImpl<$Res>
    implements $FaceOtpResultCopyWith<$Res> {
  _$FaceOtpResultCopyWithImpl(this._self, this._then);

  final FaceOtpResult _self;
  final $Res Function(FaceOtpResult) _then;

/// Create a copy of FaceOtpResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? status = null,Object? similarityScore = null,Object? livenessScore = null,Object? token = null,Object? verifiedAt = null,Object? faceImageBase64 = freezed,}) {
  return _then(FaceOtpResult(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VerificationStatus,similarityScore: null == similarityScore ? _self.similarityScore : similarityScore // ignore: cast_nullable_to_non_nullable
as double,livenessScore: null == livenessScore ? _self.livenessScore : livenessScore // ignore: cast_nullable_to_non_nullable
as double,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,verifiedAt: null == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime,faceImageBase64: freezed == faceImageBase64 ? _self.faceImageBase64 : faceImageBase64 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FaceOtpResult].
extension FaceOtpResultPatterns on FaceOtpResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FaceOtpResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FaceOtpResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FaceOtpResult value)  $default,){
final _that = this;
switch (_that) {
case _FaceOtpResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FaceOtpResult value)?  $default,){
final _that = this;
switch (_that) {
case _FaceOtpResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  VerificationStatus status,  double similarityScore,  double livenessScore,  String token,  DateTime verifiedAt,  String? faceImageBase64)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FaceOtpResult() when $default != null:
return $default(_that.sessionId,_that.status,_that.similarityScore,_that.livenessScore,_that.token,_that.verifiedAt,_that.faceImageBase64);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  VerificationStatus status,  double similarityScore,  double livenessScore,  String token,  DateTime verifiedAt,  String? faceImageBase64)  $default,) {final _that = this;
switch (_that) {
case _FaceOtpResult():
return $default(_that.sessionId,_that.status,_that.similarityScore,_that.livenessScore,_that.token,_that.verifiedAt,_that.faceImageBase64);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  VerificationStatus status,  double similarityScore,  double livenessScore,  String token,  DateTime verifiedAt,  String? faceImageBase64)?  $default,) {final _that = this;
switch (_that) {
case _FaceOtpResult() when $default != null:
return $default(_that.sessionId,_that.status,_that.similarityScore,_that.livenessScore,_that.token,_that.verifiedAt,_that.faceImageBase64);case _:
  return null;

}
}

}

/// @nodoc


class _FaceOtpResult implements FaceOtpResult {
  const _FaceOtpResult({required this.sessionId, required this.status, required this.similarityScore, required this.livenessScore, required this.token, required this.verifiedAt, this.faceImageBase64});
  

@override final  String sessionId;
@override final  VerificationStatus status;
@override final  double similarityScore;
@override final  double livenessScore;
@override final  String token;
@override final  DateTime verifiedAt;
@override final  String? faceImageBase64;

/// Create a copy of FaceOtpResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FaceOtpResultCopyWith<_FaceOtpResult> get copyWith => __$FaceOtpResultCopyWithImpl<_FaceOtpResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FaceOtpResult&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.status, status) || other.status == status)&&(identical(other.similarityScore, similarityScore) || other.similarityScore == similarityScore)&&(identical(other.livenessScore, livenessScore) || other.livenessScore == livenessScore)&&(identical(other.token, token) || other.token == token)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt)&&(identical(other.faceImageBase64, faceImageBase64) || other.faceImageBase64 == faceImageBase64));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,status,similarityScore,livenessScore,token,verifiedAt,faceImageBase64);

@override
String toString() {
  return 'FaceOtpResult(sessionId: $sessionId, status: $status, similarityScore: $similarityScore, livenessScore: $livenessScore, token: $token, verifiedAt: $verifiedAt, faceImageBase64: $faceImageBase64)';
}


}

/// @nodoc
abstract mixin class _$FaceOtpResultCopyWith<$Res> implements $FaceOtpResultCopyWith<$Res> {
  factory _$FaceOtpResultCopyWith(_FaceOtpResult value, $Res Function(_FaceOtpResult) _then) = __$FaceOtpResultCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, VerificationStatus status, double similarityScore, double livenessScore, String token, DateTime verifiedAt, String? faceImageBase64
});




}
/// @nodoc
class __$FaceOtpResultCopyWithImpl<$Res>
    implements _$FaceOtpResultCopyWith<$Res> {
  __$FaceOtpResultCopyWithImpl(this._self, this._then);

  final _FaceOtpResult _self;
  final $Res Function(_FaceOtpResult) _then;

/// Create a copy of FaceOtpResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? status = null,Object? similarityScore = null,Object? livenessScore = null,Object? token = null,Object? verifiedAt = null,Object? faceImageBase64 = freezed,}) {
  return _then(_FaceOtpResult(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VerificationStatus,similarityScore: null == similarityScore ? _self.similarityScore : similarityScore // ignore: cast_nullable_to_non_nullable
as double,livenessScore: null == livenessScore ? _self.livenessScore : livenessScore // ignore: cast_nullable_to_non_nullable
as double,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,verifiedAt: null == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime,faceImageBase64: freezed == faceImageBase64 ? _self.faceImageBase64 : faceImageBase64 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
