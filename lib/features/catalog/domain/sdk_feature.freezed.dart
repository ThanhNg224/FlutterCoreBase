// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sdk_feature.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SdkFeature {

 String get id; String get title; String get description; String get routePath; FeatureCategory get category; IconData get icon; bool get isEnabled; List<String> get tags;
/// Create a copy of SdkFeature
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SdkFeatureCopyWith<SdkFeature> get copyWith => _$SdkFeatureCopyWithImpl<SdkFeature>(this as SdkFeature, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SdkFeature&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.routePath, routePath) || other.routePath == routePath)&&(identical(other.category, category) || other.category == category)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&const DeepCollectionEquality().equals(other.tags, tags));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,routePath,category,icon,isEnabled,const DeepCollectionEquality().hash(tags));

@override
String toString() {
  return 'SdkFeature(id: $id, title: $title, description: $description, routePath: $routePath, category: $category, icon: $icon, isEnabled: $isEnabled, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $SdkFeatureCopyWith<$Res>  {
  factory $SdkFeatureCopyWith(SdkFeature value, $Res Function(SdkFeature) _then) = _$SdkFeatureCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, String routePath, FeatureCategory category, IconData icon, bool isEnabled, List<String> tags
});




}
/// @nodoc
class _$SdkFeatureCopyWithImpl<$Res>
    implements $SdkFeatureCopyWith<$Res> {
  _$SdkFeatureCopyWithImpl(this._self, this._then);

  final SdkFeature _self;
  final $Res Function(SdkFeature) _then;

/// Create a copy of SdkFeature
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? routePath = null,Object? category = null,Object? icon = null,Object? isEnabled = null,Object? tags = null,}) {
  return _then(SdkFeature(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,routePath: null == routePath ? _self.routePath : routePath // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as FeatureCategory,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SdkFeature].
extension SdkFeaturePatterns on SdkFeature {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SdkFeature value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SdkFeature() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SdkFeature value)  $default,){
final _that = this;
switch (_that) {
case _SdkFeature():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SdkFeature value)?  $default,){
final _that = this;
switch (_that) {
case _SdkFeature() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String routePath,  FeatureCategory category,  IconData icon,  bool isEnabled,  List<String> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SdkFeature() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.routePath,_that.category,_that.icon,_that.isEnabled,_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  String routePath,  FeatureCategory category,  IconData icon,  bool isEnabled,  List<String> tags)  $default,) {final _that = this;
switch (_that) {
case _SdkFeature():
return $default(_that.id,_that.title,_that.description,_that.routePath,_that.category,_that.icon,_that.isEnabled,_that.tags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  String routePath,  FeatureCategory category,  IconData icon,  bool isEnabled,  List<String> tags)?  $default,) {final _that = this;
switch (_that) {
case _SdkFeature() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.routePath,_that.category,_that.icon,_that.isEnabled,_that.tags);case _:
  return null;

}
}

}

/// @nodoc


class _SdkFeature implements SdkFeature {
  const _SdkFeature({required this.id, required this.title, required this.description, required this.routePath, required this.category, required this.icon, this.isEnabled = true,  List<String> tags = const []}): _tags = tags;
  

@override final  String id;
@override final  String title;
@override final  String description;
@override final  String routePath;
@override final  FeatureCategory category;
@override final  IconData icon;
@override@JsonKey() final  bool isEnabled;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of SdkFeature
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SdkFeatureCopyWith<_SdkFeature> get copyWith => __$SdkFeatureCopyWithImpl<_SdkFeature>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SdkFeature&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.routePath, routePath) || other.routePath == routePath)&&(identical(other.category, category) || other.category == category)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&const DeepCollectionEquality().equals(other._tags, _tags));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,routePath,category,icon,isEnabled,const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'SdkFeature(id: $id, title: $title, description: $description, routePath: $routePath, category: $category, icon: $icon, isEnabled: $isEnabled, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$SdkFeatureCopyWith<$Res> implements $SdkFeatureCopyWith<$Res> {
  factory _$SdkFeatureCopyWith(_SdkFeature value, $Res Function(_SdkFeature) _then) = __$SdkFeatureCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, String routePath, FeatureCategory category, IconData icon, bool isEnabled, List<String> tags
});




}
/// @nodoc
class __$SdkFeatureCopyWithImpl<$Res>
    implements _$SdkFeatureCopyWith<$Res> {
  __$SdkFeatureCopyWithImpl(this._self, this._then);

  final _SdkFeature _self;
  final $Res Function(_SdkFeature) _then;

/// Create a copy of SdkFeature
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? routePath = null,Object? category = null,Object? icon = null,Object? isEnabled = null,Object? tags = null,}) {
  return _then(_SdkFeature(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,routePath: null == routePath ? _self.routePath : routePath // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as FeatureCategory,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
