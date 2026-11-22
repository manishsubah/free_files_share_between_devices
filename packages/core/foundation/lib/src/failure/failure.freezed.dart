// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppFailure {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AppFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AppFailure()';
}


}

/// @nodoc
class $AppFailureCopyWith<$Res>  {
$AppFailureCopyWith(AppFailure _, $Res Function(AppFailure) __);
}


/// Adds pattern-matching-related methods to [AppFailure].
extension AppFailurePatterns on AppFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( UnexpectedFailure value)?  unexpected,TResult Function( CancelledFailure value)?  cancelled,TResult Function( PermissionDeniedFailure value)?  permissionDenied,required TResult orElse(),}){
final _that = this;
switch (_that) {
case UnexpectedFailure() when unexpected != null:
return unexpected(_that);case CancelledFailure() when cancelled != null:
return cancelled(_that);case PermissionDeniedFailure() when permissionDenied != null:
return permissionDenied(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( UnexpectedFailure value)  unexpected,required TResult Function( CancelledFailure value)  cancelled,required TResult Function( PermissionDeniedFailure value)  permissionDenied,}){
final _that = this;
switch (_that) {
case UnexpectedFailure():
return unexpected(_that);case CancelledFailure():
return cancelled(_that);case PermissionDeniedFailure():
return permissionDenied(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( UnexpectedFailure value)?  unexpected,TResult? Function( CancelledFailure value)?  cancelled,TResult? Function( PermissionDeniedFailure value)?  permissionDenied,}){
final _that = this;
switch (_that) {
case UnexpectedFailure() when unexpected != null:
return unexpected(_that);case CancelledFailure() when cancelled != null:
return cancelled(_that);case PermissionDeniedFailure() when permissionDenied != null:
return permissionDenied(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Object error,  StackTrace? stackTrace)?  unexpected,TResult Function()?  cancelled,TResult Function( String permission)?  permissionDenied,required TResult orElse(),}) {final _that = this;
switch (_that) {
case UnexpectedFailure() when unexpected != null:
return unexpected(_that.error,_that.stackTrace);case CancelledFailure() when cancelled != null:
return cancelled();case PermissionDeniedFailure() when permissionDenied != null:
return permissionDenied(_that.permission);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Object error,  StackTrace? stackTrace)  unexpected,required TResult Function()  cancelled,required TResult Function( String permission)  permissionDenied,}) {final _that = this;
switch (_that) {
case UnexpectedFailure():
return unexpected(_that.error,_that.stackTrace);case CancelledFailure():
return cancelled();case PermissionDeniedFailure():
return permissionDenied(_that.permission);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Object error,  StackTrace? stackTrace)?  unexpected,TResult? Function()?  cancelled,TResult? Function( String permission)?  permissionDenied,}) {final _that = this;
switch (_that) {
case UnexpectedFailure() when unexpected != null:
return unexpected(_that.error,_that.stackTrace);case CancelledFailure() when cancelled != null:
return cancelled();case PermissionDeniedFailure() when permissionDenied != null:
return permissionDenied(_that.permission);case _:
  return null;

}
}

}

/// @nodoc


class UnexpectedFailure extends AppFailure {
  const UnexpectedFailure({required this.error, this.stackTrace}): super._();
  

 final  Object error;
 final  StackTrace? stackTrace;

/// Create a copy of AppFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnexpectedFailureCopyWith<UnexpectedFailure> get copyWith => _$UnexpectedFailureCopyWithImpl<UnexpectedFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is UnexpectedFailure&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(error),stackTrace);
}

@override
String toString() {
    return 'AppFailure.unexpected(error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $UnexpectedFailureCopyWith<$Res> implements $AppFailureCopyWith<$Res> {
  factory $UnexpectedFailureCopyWith(UnexpectedFailure value, $Res Function(UnexpectedFailure) _then) = _$UnexpectedFailureCopyWithImpl;
@useResult
$Res call({
 Object error, StackTrace? stackTrace
});




}
/// @nodoc
class _$UnexpectedFailureCopyWithImpl<$Res>
    implements $UnexpectedFailureCopyWith<$Res> {
  _$UnexpectedFailureCopyWithImpl(this._self, this._then);

  final UnexpectedFailure _self;
  final $Res Function(UnexpectedFailure) _then;

/// Create a copy of AppFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,Object? stackTrace = freezed,}) {
  return _then(UnexpectedFailure(
error: null == error ? _self.error : error ,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

/// @nodoc


class CancelledFailure extends AppFailure {
  const CancelledFailure(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CancelledFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'AppFailure.cancelled()';
}


}




/// @nodoc


class PermissionDeniedFailure extends AppFailure {
  const PermissionDeniedFailure({required this.permission}): super._();
  

 final  String permission;

/// Create a copy of AppFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PermissionDeniedFailureCopyWith<PermissionDeniedFailure> get copyWith => _$PermissionDeniedFailureCopyWithImpl<PermissionDeniedFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PermissionDeniedFailure&&(identical(other.permission, permission) || other.permission == permission));
}


@override
int get hashCode {
    return Object.hash(runtimeType,permission);
}

@override
String toString() {
    return 'AppFailure.permissionDenied(permission: $permission)';
}


}

/// @nodoc
abstract mixin class $PermissionDeniedFailureCopyWith<$Res> implements $AppFailureCopyWith<$Res> {
  factory $PermissionDeniedFailureCopyWith(PermissionDeniedFailure value, $Res Function(PermissionDeniedFailure) _then) = _$PermissionDeniedFailureCopyWithImpl;
@useResult
$Res call({
 String permission
});




}
/// @nodoc
class _$PermissionDeniedFailureCopyWithImpl<$Res>
    implements $PermissionDeniedFailureCopyWith<$Res> {
  _$PermissionDeniedFailureCopyWithImpl(this._self, this._then);

  final PermissionDeniedFailure _self;
  final $Res Function(PermissionDeniedFailure) _then;

/// Create a copy of AppFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? permission = null,}) {
  return _then(PermissionDeniedFailure(
permission: null == permission ? _self.permission : permission // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
