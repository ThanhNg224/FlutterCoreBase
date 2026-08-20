// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'face_otp_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FaceOtpState {

 FaceOtpConfig get config;
/// Create a copy of FaceOtpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FaceOtpStateCopyWith<FaceOtpState> get copyWith => _$FaceOtpStateCopyWithImpl<FaceOtpState>(this as FaceOtpState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FaceOtpState&&(identical(other.config, config) || other.config == config));
}


@override
int get hashCode => Object.hash(runtimeType,config);

@override
String toString() {
  return 'FaceOtpState(config: $config)';
}


}

/// @nodoc
abstract mixin class $FaceOtpStateCopyWith<$Res>  {
  factory $FaceOtpStateCopyWith(FaceOtpState value, $Res Function(FaceOtpState) _then) = _$FaceOtpStateCopyWithImpl;
@useResult
$Res call({
 FaceOtpConfig config
});


$FaceOtpConfigCopyWith<$Res> get config;

}
/// @nodoc
class _$FaceOtpStateCopyWithImpl<$Res>
    implements $FaceOtpStateCopyWith<$Res> {
  _$FaceOtpStateCopyWithImpl(this._self, this._then);

  final FaceOtpState _self;
  final $Res Function(FaceOtpState) _then;

/// Create a copy of FaceOtpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? config = null,}) {
  return _then(_self.copyWith(
config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as FaceOtpConfig,
  ));
}
/// Create a copy of FaceOtpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FaceOtpConfigCopyWith<$Res> get config {
  
  return $FaceOtpConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}


/// Adds pattern-matching-related methods to [FaceOtpState].
extension FaceOtpStatePatterns on FaceOtpState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FaceOtpInitialState value)?  initial,TResult Function( FaceOtpVerifyingState value)?  verifying,TResult Function( FaceOtpSuccessState value)?  success,TResult Function( FaceOtpFailureState value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FaceOtpInitialState() when initial != null:
return initial(_that);case FaceOtpVerifyingState() when verifying != null:
return verifying(_that);case FaceOtpSuccessState() when success != null:
return success(_that);case FaceOtpFailureState() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FaceOtpInitialState value)  initial,required TResult Function( FaceOtpVerifyingState value)  verifying,required TResult Function( FaceOtpSuccessState value)  success,required TResult Function( FaceOtpFailureState value)  failure,}){
final _that = this;
switch (_that) {
case FaceOtpInitialState():
return initial(_that);case FaceOtpVerifyingState():
return verifying(_that);case FaceOtpSuccessState():
return success(_that);case FaceOtpFailureState():
return failure(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FaceOtpInitialState value)?  initial,TResult? Function( FaceOtpVerifyingState value)?  verifying,TResult? Function( FaceOtpSuccessState value)?  success,TResult? Function( FaceOtpFailureState value)?  failure,}){
final _that = this;
switch (_that) {
case FaceOtpInitialState() when initial != null:
return initial(_that);case FaceOtpVerifyingState() when verifying != null:
return verifying(_that);case FaceOtpSuccessState() when success != null:
return success(_that);case FaceOtpFailureState() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( FaceOtpConfig config)?  initial,TResult Function( FaceOtpConfig config,  String progressMessage)?  verifying,TResult Function( FaceOtpConfig config,  FaceOtpResult result)?  success,TResult Function( FaceOtpConfig config,  Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FaceOtpInitialState() when initial != null:
return initial(_that.config);case FaceOtpVerifyingState() when verifying != null:
return verifying(_that.config,_that.progressMessage);case FaceOtpSuccessState() when success != null:
return success(_that.config,_that.result);case FaceOtpFailureState() when failure != null:
return failure(_that.config,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( FaceOtpConfig config)  initial,required TResult Function( FaceOtpConfig config,  String progressMessage)  verifying,required TResult Function( FaceOtpConfig config,  FaceOtpResult result)  success,required TResult Function( FaceOtpConfig config,  Failure failure)  failure,}) {final _that = this;
switch (_that) {
case FaceOtpInitialState():
return initial(_that.config);case FaceOtpVerifyingState():
return verifying(_that.config,_that.progressMessage);case FaceOtpSuccessState():
return success(_that.config,_that.result);case FaceOtpFailureState():
return failure(_that.config,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( FaceOtpConfig config)?  initial,TResult? Function( FaceOtpConfig config,  String progressMessage)?  verifying,TResult? Function( FaceOtpConfig config,  FaceOtpResult result)?  success,TResult? Function( FaceOtpConfig config,  Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case FaceOtpInitialState() when initial != null:
return initial(_that.config);case FaceOtpVerifyingState() when verifying != null:
return verifying(_that.config,_that.progressMessage);case FaceOtpSuccessState() when success != null:
return success(_that.config,_that.result);case FaceOtpFailureState() when failure != null:
return failure(_that.config,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class FaceOtpInitialState implements FaceOtpState {
  const FaceOtpInitialState({this.config = const FaceOtpConfig()});
  

@override@JsonKey() final  FaceOtpConfig config;

/// Create a copy of FaceOtpState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FaceOtpInitialStateCopyWith<FaceOtpInitialState> get copyWith => _$FaceOtpInitialStateCopyWithImpl<FaceOtpInitialState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FaceOtpInitialState&&(identical(other.config, config) || other.config == config));
}


@override
int get hashCode => Object.hash(runtimeType,config);

@override
String toString() {
  return 'FaceOtpState.initial(config: $config)';
}


}

/// @nodoc
abstract mixin class $FaceOtpInitialStateCopyWith<$Res> implements $FaceOtpStateCopyWith<$Res> {
  factory $FaceOtpInitialStateCopyWith(FaceOtpInitialState value, $Res Function(FaceOtpInitialState) _then) = _$FaceOtpInitialStateCopyWithImpl;
@override @useResult
$Res call({
 FaceOtpConfig config
});


@override $FaceOtpConfigCopyWith<$Res> get config;

}
/// @nodoc
class _$FaceOtpInitialStateCopyWithImpl<$Res>
    implements $FaceOtpInitialStateCopyWith<$Res> {
  _$FaceOtpInitialStateCopyWithImpl(this._self, this._then);

  final FaceOtpInitialState _self;
  final $Res Function(FaceOtpInitialState) _then;

/// Create a copy of FaceOtpState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? config = null,}) {
  return _then(FaceOtpInitialState(
config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as FaceOtpConfig,
  ));
}

/// Create a copy of FaceOtpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FaceOtpConfigCopyWith<$Res> get config {
  
  return $FaceOtpConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}

/// @nodoc


class FaceOtpVerifyingState implements FaceOtpState {
  const FaceOtpVerifyingState({required this.config, this.progressMessage = 'Initializing biometric camera...'});
  

@override final  FaceOtpConfig config;
@JsonKey() final  String progressMessage;

/// Create a copy of FaceOtpState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FaceOtpVerifyingStateCopyWith<FaceOtpVerifyingState> get copyWith => _$FaceOtpVerifyingStateCopyWithImpl<FaceOtpVerifyingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FaceOtpVerifyingState&&(identical(other.config, config) || other.config == config)&&(identical(other.progressMessage, progressMessage) || other.progressMessage == progressMessage));
}


@override
int get hashCode => Object.hash(runtimeType,config,progressMessage);

@override
String toString() {
  return 'FaceOtpState.verifying(config: $config, progressMessage: $progressMessage)';
}


}

/// @nodoc
abstract mixin class $FaceOtpVerifyingStateCopyWith<$Res> implements $FaceOtpStateCopyWith<$Res> {
  factory $FaceOtpVerifyingStateCopyWith(FaceOtpVerifyingState value, $Res Function(FaceOtpVerifyingState) _then) = _$FaceOtpVerifyingStateCopyWithImpl;
@override @useResult
$Res call({
 FaceOtpConfig config, String progressMessage
});


@override $FaceOtpConfigCopyWith<$Res> get config;

}
/// @nodoc
class _$FaceOtpVerifyingStateCopyWithImpl<$Res>
    implements $FaceOtpVerifyingStateCopyWith<$Res> {
  _$FaceOtpVerifyingStateCopyWithImpl(this._self, this._then);

  final FaceOtpVerifyingState _self;
  final $Res Function(FaceOtpVerifyingState) _then;

/// Create a copy of FaceOtpState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? config = null,Object? progressMessage = null,}) {
  return _then(FaceOtpVerifyingState(
config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as FaceOtpConfig,progressMessage: null == progressMessage ? _self.progressMessage : progressMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of FaceOtpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FaceOtpConfigCopyWith<$Res> get config {
  
  return $FaceOtpConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}

/// @nodoc


class FaceOtpSuccessState implements FaceOtpState {
  const FaceOtpSuccessState({required this.config, required this.result});
  

@override final  FaceOtpConfig config;
 final  FaceOtpResult result;

/// Create a copy of FaceOtpState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FaceOtpSuccessStateCopyWith<FaceOtpSuccessState> get copyWith => _$FaceOtpSuccessStateCopyWithImpl<FaceOtpSuccessState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FaceOtpSuccessState&&(identical(other.config, config) || other.config == config)&&(identical(other.result, result) || other.result == result));
}


@override
int get hashCode => Object.hash(runtimeType,config,result);

@override
String toString() {
  return 'FaceOtpState.success(config: $config, result: $result)';
}


}

/// @nodoc
abstract mixin class $FaceOtpSuccessStateCopyWith<$Res> implements $FaceOtpStateCopyWith<$Res> {
  factory $FaceOtpSuccessStateCopyWith(FaceOtpSuccessState value, $Res Function(FaceOtpSuccessState) _then) = _$FaceOtpSuccessStateCopyWithImpl;
@override @useResult
$Res call({
 FaceOtpConfig config, FaceOtpResult result
});


@override $FaceOtpConfigCopyWith<$Res> get config;$FaceOtpResultCopyWith<$Res> get result;

}
/// @nodoc
class _$FaceOtpSuccessStateCopyWithImpl<$Res>
    implements $FaceOtpSuccessStateCopyWith<$Res> {
  _$FaceOtpSuccessStateCopyWithImpl(this._self, this._then);

  final FaceOtpSuccessState _self;
  final $Res Function(FaceOtpSuccessState) _then;

/// Create a copy of FaceOtpState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? config = null,Object? result = null,}) {
  return _then(FaceOtpSuccessState(
config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as FaceOtpConfig,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as FaceOtpResult,
  ));
}

/// Create a copy of FaceOtpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FaceOtpConfigCopyWith<$Res> get config {
  
  return $FaceOtpConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}/// Create a copy of FaceOtpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FaceOtpResultCopyWith<$Res> get result {
  
  return $FaceOtpResultCopyWith<$Res>(_self.result, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}

/// @nodoc


class FaceOtpFailureState implements FaceOtpState {
  const FaceOtpFailureState({required this.config, required this.failure});
  

@override final  FaceOtpConfig config;
 final  Failure failure;

/// Create a copy of FaceOtpState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FaceOtpFailureStateCopyWith<FaceOtpFailureState> get copyWith => _$FaceOtpFailureStateCopyWithImpl<FaceOtpFailureState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FaceOtpFailureState&&(identical(other.config, config) || other.config == config)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,config,failure);

@override
String toString() {
  return 'FaceOtpState.failure(config: $config, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $FaceOtpFailureStateCopyWith<$Res> implements $FaceOtpStateCopyWith<$Res> {
  factory $FaceOtpFailureStateCopyWith(FaceOtpFailureState value, $Res Function(FaceOtpFailureState) _then) = _$FaceOtpFailureStateCopyWithImpl;
@override @useResult
$Res call({
 FaceOtpConfig config, Failure failure
});


@override $FaceOtpConfigCopyWith<$Res> get config;$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$FaceOtpFailureStateCopyWithImpl<$Res>
    implements $FaceOtpFailureStateCopyWith<$Res> {
  _$FaceOtpFailureStateCopyWithImpl(this._self, this._then);

  final FaceOtpFailureState _self;
  final $Res Function(FaceOtpFailureState) _then;

/// Create a copy of FaceOtpState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? config = null,Object? failure = null,}) {
  return _then(FaceOtpFailureState(
config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as FaceOtpConfig,failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of FaceOtpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FaceOtpConfigCopyWith<$Res> get config {
  
  return $FaceOtpConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}/// Create a copy of FaceOtpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res> get failure {
  
  return $FailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
