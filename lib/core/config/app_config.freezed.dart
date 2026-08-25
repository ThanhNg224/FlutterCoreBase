// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppConfig {

 Environment get environment; String get baseUrl; String get appToken; String get clientKey; bool get mockSdkEnabled; String get sdkVersion;
/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppConfigCopyWith<AppConfig> get copyWith => _$AppConfigCopyWithImpl<AppConfig>(this as AppConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppConfig&&(identical(other.environment, environment) || other.environment == environment)&&(identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl)&&(identical(other.appToken, appToken) || other.appToken == appToken)&&(identical(other.clientKey, clientKey) || other.clientKey == clientKey)&&(identical(other.mockSdkEnabled, mockSdkEnabled) || other.mockSdkEnabled == mockSdkEnabled)&&(identical(other.sdkVersion, sdkVersion) || other.sdkVersion == sdkVersion));
}


@override
int get hashCode => Object.hash(runtimeType,environment,baseUrl,appToken,clientKey,mockSdkEnabled,sdkVersion);

@override
String toString() {
  return 'AppConfig(environment: $environment, baseUrl: $baseUrl, appToken: $appToken, clientKey: $clientKey, mockSdkEnabled: $mockSdkEnabled, sdkVersion: $sdkVersion)';
}


}

/// @nodoc
abstract mixin class $AppConfigCopyWith<$Res>  {
  factory $AppConfigCopyWith(AppConfig value, $Res Function(AppConfig) _then) = _$AppConfigCopyWithImpl;
@useResult
$Res call({
 Environment environment, String baseUrl, String appToken, String clientKey, bool mockSdkEnabled, String sdkVersion
});




}
/// @nodoc
class _$AppConfigCopyWithImpl<$Res>
    implements $AppConfigCopyWith<$Res> {
  _$AppConfigCopyWithImpl(this._self, this._then);

  final AppConfig _self;
  final $Res Function(AppConfig) _then;

/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? environment = null,Object? baseUrl = null,Object? appToken = null,Object? clientKey = null,Object? mockSdkEnabled = null,Object? sdkVersion = null,}) {
  return _then(AppConfig(
environment: null == environment ? _self.environment : environment // ignore: cast_nullable_to_non_nullable
as Environment,baseUrl: null == baseUrl ? _self.baseUrl : baseUrl // ignore: cast_nullable_to_non_nullable
as String,appToken: null == appToken ? _self.appToken : appToken // ignore: cast_nullable_to_non_nullable
as String,clientKey: null == clientKey ? _self.clientKey : clientKey // ignore: cast_nullable_to_non_nullable
as String,mockSdkEnabled: null == mockSdkEnabled ? _self.mockSdkEnabled : mockSdkEnabled // ignore: cast_nullable_to_non_nullable
as bool,sdkVersion: null == sdkVersion ? _self.sdkVersion : sdkVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppConfig].
extension AppConfigPatterns on AppConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppConfig value)  $default,){
final _that = this;
switch (_that) {
case _AppConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppConfig value)?  $default,){
final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Environment environment,  String baseUrl,  String appToken,  String clientKey,  bool mockSdkEnabled,  String sdkVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
return $default(_that.environment,_that.baseUrl,_that.appToken,_that.clientKey,_that.mockSdkEnabled,_that.sdkVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Environment environment,  String baseUrl,  String appToken,  String clientKey,  bool mockSdkEnabled,  String sdkVersion)  $default,) {final _that = this;
switch (_that) {
case _AppConfig():
return $default(_that.environment,_that.baseUrl,_that.appToken,_that.clientKey,_that.mockSdkEnabled,_that.sdkVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Environment environment,  String baseUrl,  String appToken,  String clientKey,  bool mockSdkEnabled,  String sdkVersion)?  $default,) {final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
return $default(_that.environment,_that.baseUrl,_that.appToken,_that.clientKey,_that.mockSdkEnabled,_that.sdkVersion);case _:
  return null;

}
}

}

/// @nodoc


class _AppConfig implements AppConfig {
  const _AppConfig({this.environment = Environment.production, this.baseUrl = ApiEndpoints.prodUrl, this.appToken = ApiEndpoints.defaultProdToken, this.clientKey = ApiEndpoints.defaultProdClientKey, this.mockSdkEnabled = false, this.sdkVersion = ApiEndpoints.placeholderSdkVersion});
  

@override@JsonKey() final  Environment environment;
@override@JsonKey() final  String baseUrl;
@override@JsonKey() final  String appToken;
@override@JsonKey() final  String clientKey;
@override@JsonKey() final  bool mockSdkEnabled;
@override@JsonKey() final  String sdkVersion;

/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppConfigCopyWith<_AppConfig> get copyWith => __$AppConfigCopyWithImpl<_AppConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppConfig&&(identical(other.environment, environment) || other.environment == environment)&&(identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl)&&(identical(other.appToken, appToken) || other.appToken == appToken)&&(identical(other.clientKey, clientKey) || other.clientKey == clientKey)&&(identical(other.mockSdkEnabled, mockSdkEnabled) || other.mockSdkEnabled == mockSdkEnabled)&&(identical(other.sdkVersion, sdkVersion) || other.sdkVersion == sdkVersion));
}


@override
int get hashCode => Object.hash(runtimeType,environment,baseUrl,appToken,clientKey,mockSdkEnabled,sdkVersion);

@override
String toString() {
  return 'AppConfig(environment: $environment, baseUrl: $baseUrl, appToken: $appToken, clientKey: $clientKey, mockSdkEnabled: $mockSdkEnabled, sdkVersion: $sdkVersion)';
}


}

/// @nodoc
abstract mixin class _$AppConfigCopyWith<$Res> implements $AppConfigCopyWith<$Res> {
  factory _$AppConfigCopyWith(_AppConfig value, $Res Function(_AppConfig) _then) = __$AppConfigCopyWithImpl;
@override @useResult
$Res call({
 Environment environment, String baseUrl, String appToken, String clientKey, bool mockSdkEnabled, String sdkVersion
});




}
/// @nodoc
class __$AppConfigCopyWithImpl<$Res>
    implements _$AppConfigCopyWith<$Res> {
  __$AppConfigCopyWithImpl(this._self, this._then);

  final _AppConfig _self;
  final $Res Function(_AppConfig) _then;

/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? environment = null,Object? baseUrl = null,Object? appToken = null,Object? clientKey = null,Object? mockSdkEnabled = null,Object? sdkVersion = null,}) {
  return _then(_AppConfig(
environment: null == environment ? _self.environment : environment // ignore: cast_nullable_to_non_nullable
as Environment,baseUrl: null == baseUrl ? _self.baseUrl : baseUrl // ignore: cast_nullable_to_non_nullable
as String,appToken: null == appToken ? _self.appToken : appToken // ignore: cast_nullable_to_non_nullable
as String,clientKey: null == clientKey ? _self.clientKey : clientKey // ignore: cast_nullable_to_non_nullable
as String,mockSdkEnabled: null == mockSdkEnabled ? _self.mockSdkEnabled : mockSdkEnabled // ignore: cast_nullable_to_non_nullable
as bool,sdkVersion: null == sdkVersion ? _self.sdkVersion : sdkVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
