// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'face_otp_result_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FaceOtpResultDto {

 String get sessionId; String get status; double get similarityScore; double get livenessScore; String get token; String get verifiedAtIso; String? get faceImageBase64;
/// Create a copy of FaceOtpResultDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FaceOtpResultDtoCopyWith<FaceOtpResultDto> get copyWith => _$FaceOtpResultDtoCopyWithImpl<FaceOtpResultDto>(this as FaceOtpResultDto, _$identity);

  /// Serializes this FaceOtpResultDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FaceOtpResultDto&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.status, status) || other.status == status)&&(identical(other.similarityScore, similarityScore) || other.similarityScore == similarityScore)&&(identical(other.livenessScore, livenessScore) || other.livenessScore == livenessScore)&&(identical(other.token, token) || other.token == token)&&(identical(other.verifiedAtIso, verifiedAtIso) || other.verifiedAtIso == verifiedAtIso)&&(identical(other.faceImageBase64, faceImageBase64) || other.faceImageBase64 == faceImageBase64));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,status,similarityScore,livenessScore,token,verifiedAtIso,faceImageBase64);

@override
String toString() {
  return 'FaceOtpResultDto(sessionId: $sessionId, status: $status, similarityScore: $similarityScore, livenessScore: $livenessScore, token: $token, verifiedAtIso: $verifiedAtIso, faceImageBase64: $faceImageBase64)';
}


}

/// @nodoc
abstract mixin class $FaceOtpResultDtoCopyWith<$Res>  {
  factory $FaceOtpResultDtoCopyWith(FaceOtpResultDto value, $Res Function(FaceOtpResultDto) _then) = _$FaceOtpResultDtoCopyWithImpl;
@useResult
$Res call({
 String sessionId, String status, double similarityScore, double livenessScore, String token, String verifiedAtIso, String? faceImageBase64
});




}
/// @nodoc
class _$FaceOtpResultDtoCopyWithImpl<$Res>
    implements $FaceOtpResultDtoCopyWith<$Res> {
  _$FaceOtpResultDtoCopyWithImpl(this._self, this._then);

  final FaceOtpResultDto _self;
  final $Res Function(FaceOtpResultDto) _then;

/// Create a copy of FaceOtpResultDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? status = null,Object? similarityScore = null,Object? livenessScore = null,Object? token = null,Object? verifiedAtIso = null,Object? faceImageBase64 = freezed,}) {
  return _then(FaceOtpResultDto(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,similarityScore: null == similarityScore ? _self.similarityScore : similarityScore // ignore: cast_nullable_to_non_nullable
as double,livenessScore: null == livenessScore ? _self.livenessScore : livenessScore // ignore: cast_nullable_to_non_nullable
as double,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,verifiedAtIso: null == verifiedAtIso ? _self.verifiedAtIso : verifiedAtIso // ignore: cast_nullable_to_non_nullable
as String,faceImageBase64: freezed == faceImageBase64 ? _self.faceImageBase64 : faceImageBase64 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FaceOtpResultDto].
extension FaceOtpResultDtoPatterns on FaceOtpResultDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FaceOtpResultDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FaceOtpResultDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FaceOtpResultDto value)  $default,){
final _that = this;
switch (_that) {
case _FaceOtpResultDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FaceOtpResultDto value)?  $default,){
final _that = this;
switch (_that) {
case _FaceOtpResultDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  String status,  double similarityScore,  double livenessScore,  String token,  String verifiedAtIso,  String? faceImageBase64)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FaceOtpResultDto() when $default != null:
return $default(_that.sessionId,_that.status,_that.similarityScore,_that.livenessScore,_that.token,_that.verifiedAtIso,_that.faceImageBase64);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  String status,  double similarityScore,  double livenessScore,  String token,  String verifiedAtIso,  String? faceImageBase64)  $default,) {final _that = this;
switch (_that) {
case _FaceOtpResultDto():
return $default(_that.sessionId,_that.status,_that.similarityScore,_that.livenessScore,_that.token,_that.verifiedAtIso,_that.faceImageBase64);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  String status,  double similarityScore,  double livenessScore,  String token,  String verifiedAtIso,  String? faceImageBase64)?  $default,) {final _that = this;
switch (_that) {
case _FaceOtpResultDto() when $default != null:
return $default(_that.sessionId,_that.status,_that.similarityScore,_that.livenessScore,_that.token,_that.verifiedAtIso,_that.faceImageBase64);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FaceOtpResultDto extends FaceOtpResultDto {
  const _FaceOtpResultDto({required this.sessionId, required this.status, required this.similarityScore, required this.livenessScore, required this.token, required this.verifiedAtIso, this.faceImageBase64}): super._();
  factory _FaceOtpResultDto.fromJson(Map<String, dynamic> json) => _$FaceOtpResultDtoFromJson(json);

@override final  String sessionId;
@override final  String status;
@override final  double similarityScore;
@override final  double livenessScore;
@override final  String token;
@override final  String verifiedAtIso;
@override final  String? faceImageBase64;

/// Create a copy of FaceOtpResultDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FaceOtpResultDtoCopyWith<_FaceOtpResultDto> get copyWith => __$FaceOtpResultDtoCopyWithImpl<_FaceOtpResultDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FaceOtpResultDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FaceOtpResultDto&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.status, status) || other.status == status)&&(identical(other.similarityScore, similarityScore) || other.similarityScore == similarityScore)&&(identical(other.livenessScore, livenessScore) || other.livenessScore == livenessScore)&&(identical(other.token, token) || other.token == token)&&(identical(other.verifiedAtIso, verifiedAtIso) || other.verifiedAtIso == verifiedAtIso)&&(identical(other.faceImageBase64, faceImageBase64) || other.faceImageBase64 == faceImageBase64));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,status,similarityScore,livenessScore,token,verifiedAtIso,faceImageBase64);

@override
String toString() {
  return 'FaceOtpResultDto(sessionId: $sessionId, status: $status, similarityScore: $similarityScore, livenessScore: $livenessScore, token: $token, verifiedAtIso: $verifiedAtIso, faceImageBase64: $faceImageBase64)';
}


}

/// @nodoc
abstract mixin class _$FaceOtpResultDtoCopyWith<$Res> implements $FaceOtpResultDtoCopyWith<$Res> {
  factory _$FaceOtpResultDtoCopyWith(_FaceOtpResultDto value, $Res Function(_FaceOtpResultDto) _then) = __$FaceOtpResultDtoCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, String status, double similarityScore, double livenessScore, String token, String verifiedAtIso, String? faceImageBase64
});




}
/// @nodoc
class __$FaceOtpResultDtoCopyWithImpl<$Res>
    implements _$FaceOtpResultDtoCopyWith<$Res> {
  __$FaceOtpResultDtoCopyWithImpl(this._self, this._then);

  final _FaceOtpResultDto _self;
  final $Res Function(_FaceOtpResultDto) _then;

/// Create a copy of FaceOtpResultDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? status = null,Object? similarityScore = null,Object? livenessScore = null,Object? token = null,Object? verifiedAtIso = null,Object? faceImageBase64 = freezed,}) {
  return _then(_FaceOtpResultDto(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,similarityScore: null == similarityScore ? _self.similarityScore : similarityScore // ignore: cast_nullable_to_non_nullable
as double,livenessScore: null == livenessScore ? _self.livenessScore : livenessScore // ignore: cast_nullable_to_non_nullable
as double,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,verifiedAtIso: null == verifiedAtIso ? _self.verifiedAtIso : verifiedAtIso // ignore: cast_nullable_to_non_nullable
as String,faceImageBase64: freezed == faceImageBase64 ? _self.faceImageBase64 : faceImageBase64 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
