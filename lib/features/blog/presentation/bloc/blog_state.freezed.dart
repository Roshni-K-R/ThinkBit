// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blog_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BlogState {
  int get warningCount => throw _privateConstructorUsedError;
  bool get isBlocked => throw _privateConstructorUsedError;
  bool get showWarning => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int warningCount, bool isBlocked, bool showWarning)
        initial,
    required TResult Function(
            int warningCount, bool isBlocked, bool showWarning)
        loading,
    required TResult Function(
            int warningCount, bool isBlocked, bool showWarning)
        uploadSuccess,
    required TResult Function(List<Blog> blogs, int warningCount,
            bool isBlocked, bool showWarning)
        displaySuccess,
    required TResult Function(
            String message, int warningCount, bool isBlocked, bool showWarning)
        failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int warningCount, bool isBlocked, bool showWarning)?
        initial,
    TResult? Function(int warningCount, bool isBlocked, bool showWarning)?
        loading,
    TResult? Function(int warningCount, bool isBlocked, bool showWarning)?
        uploadSuccess,
    TResult? Function(List<Blog> blogs, int warningCount, bool isBlocked,
            bool showWarning)?
        displaySuccess,
    TResult? Function(
            String message, int warningCount, bool isBlocked, bool showWarning)?
        failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int warningCount, bool isBlocked, bool showWarning)?
        initial,
    TResult Function(int warningCount, bool isBlocked, bool showWarning)?
        loading,
    TResult Function(int warningCount, bool isBlocked, bool showWarning)?
        uploadSuccess,
    TResult Function(List<Blog> blogs, int warningCount, bool isBlocked,
            bool showWarning)?
        displaySuccess,
    TResult Function(
            String message, int warningCount, bool isBlocked, bool showWarning)?
        failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BlogInitial value) initial,
    required TResult Function(BlogLoading value) loading,
    required TResult Function(BlogUploadSuccess value) uploadSuccess,
    required TResult Function(BlogDisplaySuccess value) displaySuccess,
    required TResult Function(BlogFailure value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BlogInitial value)? initial,
    TResult? Function(BlogLoading value)? loading,
    TResult? Function(BlogUploadSuccess value)? uploadSuccess,
    TResult? Function(BlogDisplaySuccess value)? displaySuccess,
    TResult? Function(BlogFailure value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BlogInitial value)? initial,
    TResult Function(BlogLoading value)? loading,
    TResult Function(BlogUploadSuccess value)? uploadSuccess,
    TResult Function(BlogDisplaySuccess value)? displaySuccess,
    TResult Function(BlogFailure value)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BlogStateCopyWith<BlogState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlogStateCopyWith<$Res> {
  factory $BlogStateCopyWith(BlogState value, $Res Function(BlogState) then) =
      _$BlogStateCopyWithImpl<$Res, BlogState>;
  @useResult
  $Res call({int warningCount, bool isBlocked, bool showWarning});
}

/// @nodoc
class _$BlogStateCopyWithImpl<$Res, $Val extends BlogState>
    implements $BlogStateCopyWith<$Res> {
  _$BlogStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? warningCount = null,
    Object? isBlocked = null,
    Object? showWarning = null,
  }) {
    return _then(_value.copyWith(
      warningCount: null == warningCount
          ? _value.warningCount
          : warningCount // ignore: cast_nullable_to_non_nullable
              as int,
      isBlocked: null == isBlocked
          ? _value.isBlocked
          : isBlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      showWarning: null == showWarning
          ? _value.showWarning
          : showWarning // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BlogInitialImplCopyWith<$Res>
    implements $BlogStateCopyWith<$Res> {
  factory _$$BlogInitialImplCopyWith(
          _$BlogInitialImpl value, $Res Function(_$BlogInitialImpl) then) =
      __$$BlogInitialImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int warningCount, bool isBlocked, bool showWarning});
}

/// @nodoc
class __$$BlogInitialImplCopyWithImpl<$Res>
    extends _$BlogStateCopyWithImpl<$Res, _$BlogInitialImpl>
    implements _$$BlogInitialImplCopyWith<$Res> {
  __$$BlogInitialImplCopyWithImpl(
      _$BlogInitialImpl _value, $Res Function(_$BlogInitialImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? warningCount = null,
    Object? isBlocked = null,
    Object? showWarning = null,
  }) {
    return _then(_$BlogInitialImpl(
      warningCount: null == warningCount
          ? _value.warningCount
          : warningCount // ignore: cast_nullable_to_non_nullable
              as int,
      isBlocked: null == isBlocked
          ? _value.isBlocked
          : isBlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      showWarning: null == showWarning
          ? _value.showWarning
          : showWarning // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$BlogInitialImpl implements BlogInitial {
  const _$BlogInitialImpl(
      {this.warningCount = 0,
      this.isBlocked = false,
      this.showWarning = false});

  @override
  @JsonKey()
  final int warningCount;
  @override
  @JsonKey()
  final bool isBlocked;
  @override
  @JsonKey()
  final bool showWarning;

  @override
  String toString() {
    return 'BlogState.initial(warningCount: $warningCount, isBlocked: $isBlocked, showWarning: $showWarning)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlogInitialImpl &&
            (identical(other.warningCount, warningCount) ||
                other.warningCount == warningCount) &&
            (identical(other.isBlocked, isBlocked) ||
                other.isBlocked == isBlocked) &&
            (identical(other.showWarning, showWarning) ||
                other.showWarning == showWarning));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, warningCount, isBlocked, showWarning);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BlogInitialImplCopyWith<_$BlogInitialImpl> get copyWith =>
      __$$BlogInitialImplCopyWithImpl<_$BlogInitialImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int warningCount, bool isBlocked, bool showWarning)
        initial,
    required TResult Function(
            int warningCount, bool isBlocked, bool showWarning)
        loading,
    required TResult Function(
            int warningCount, bool isBlocked, bool showWarning)
        uploadSuccess,
    required TResult Function(List<Blog> blogs, int warningCount,
            bool isBlocked, bool showWarning)
        displaySuccess,
    required TResult Function(
            String message, int warningCount, bool isBlocked, bool showWarning)
        failure,
  }) {
    return initial(warningCount, isBlocked, showWarning);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int warningCount, bool isBlocked, bool showWarning)?
        initial,
    TResult? Function(int warningCount, bool isBlocked, bool showWarning)?
        loading,
    TResult? Function(int warningCount, bool isBlocked, bool showWarning)?
        uploadSuccess,
    TResult? Function(List<Blog> blogs, int warningCount, bool isBlocked,
            bool showWarning)?
        displaySuccess,
    TResult? Function(
            String message, int warningCount, bool isBlocked, bool showWarning)?
        failure,
  }) {
    return initial?.call(warningCount, isBlocked, showWarning);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int warningCount, bool isBlocked, bool showWarning)?
        initial,
    TResult Function(int warningCount, bool isBlocked, bool showWarning)?
        loading,
    TResult Function(int warningCount, bool isBlocked, bool showWarning)?
        uploadSuccess,
    TResult Function(List<Blog> blogs, int warningCount, bool isBlocked,
            bool showWarning)?
        displaySuccess,
    TResult Function(
            String message, int warningCount, bool isBlocked, bool showWarning)?
        failure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(warningCount, isBlocked, showWarning);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BlogInitial value) initial,
    required TResult Function(BlogLoading value) loading,
    required TResult Function(BlogUploadSuccess value) uploadSuccess,
    required TResult Function(BlogDisplaySuccess value) displaySuccess,
    required TResult Function(BlogFailure value) failure,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BlogInitial value)? initial,
    TResult? Function(BlogLoading value)? loading,
    TResult? Function(BlogUploadSuccess value)? uploadSuccess,
    TResult? Function(BlogDisplaySuccess value)? displaySuccess,
    TResult? Function(BlogFailure value)? failure,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BlogInitial value)? initial,
    TResult Function(BlogLoading value)? loading,
    TResult Function(BlogUploadSuccess value)? uploadSuccess,
    TResult Function(BlogDisplaySuccess value)? displaySuccess,
    TResult Function(BlogFailure value)? failure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class BlogInitial implements BlogState {
  const factory BlogInitial(
      {final int warningCount,
      final bool isBlocked,
      final bool showWarning}) = _$BlogInitialImpl;

  @override
  int get warningCount;
  @override
  bool get isBlocked;
  @override
  bool get showWarning;
  @override
  @JsonKey(ignore: true)
  _$$BlogInitialImplCopyWith<_$BlogInitialImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BlogLoadingImplCopyWith<$Res>
    implements $BlogStateCopyWith<$Res> {
  factory _$$BlogLoadingImplCopyWith(
          _$BlogLoadingImpl value, $Res Function(_$BlogLoadingImpl) then) =
      __$$BlogLoadingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int warningCount, bool isBlocked, bool showWarning});
}

/// @nodoc
class __$$BlogLoadingImplCopyWithImpl<$Res>
    extends _$BlogStateCopyWithImpl<$Res, _$BlogLoadingImpl>
    implements _$$BlogLoadingImplCopyWith<$Res> {
  __$$BlogLoadingImplCopyWithImpl(
      _$BlogLoadingImpl _value, $Res Function(_$BlogLoadingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? warningCount = null,
    Object? isBlocked = null,
    Object? showWarning = null,
  }) {
    return _then(_$BlogLoadingImpl(
      warningCount: null == warningCount
          ? _value.warningCount
          : warningCount // ignore: cast_nullable_to_non_nullable
              as int,
      isBlocked: null == isBlocked
          ? _value.isBlocked
          : isBlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      showWarning: null == showWarning
          ? _value.showWarning
          : showWarning // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$BlogLoadingImpl implements BlogLoading {
  const _$BlogLoadingImpl(
      {this.warningCount = 0,
      this.isBlocked = false,
      this.showWarning = false});

  @override
  @JsonKey()
  final int warningCount;
  @override
  @JsonKey()
  final bool isBlocked;
  @override
  @JsonKey()
  final bool showWarning;

  @override
  String toString() {
    return 'BlogState.loading(warningCount: $warningCount, isBlocked: $isBlocked, showWarning: $showWarning)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlogLoadingImpl &&
            (identical(other.warningCount, warningCount) ||
                other.warningCount == warningCount) &&
            (identical(other.isBlocked, isBlocked) ||
                other.isBlocked == isBlocked) &&
            (identical(other.showWarning, showWarning) ||
                other.showWarning == showWarning));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, warningCount, isBlocked, showWarning);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BlogLoadingImplCopyWith<_$BlogLoadingImpl> get copyWith =>
      __$$BlogLoadingImplCopyWithImpl<_$BlogLoadingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int warningCount, bool isBlocked, bool showWarning)
        initial,
    required TResult Function(
            int warningCount, bool isBlocked, bool showWarning)
        loading,
    required TResult Function(
            int warningCount, bool isBlocked, bool showWarning)
        uploadSuccess,
    required TResult Function(List<Blog> blogs, int warningCount,
            bool isBlocked, bool showWarning)
        displaySuccess,
    required TResult Function(
            String message, int warningCount, bool isBlocked, bool showWarning)
        failure,
  }) {
    return loading(warningCount, isBlocked, showWarning);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int warningCount, bool isBlocked, bool showWarning)?
        initial,
    TResult? Function(int warningCount, bool isBlocked, bool showWarning)?
        loading,
    TResult? Function(int warningCount, bool isBlocked, bool showWarning)?
        uploadSuccess,
    TResult? Function(List<Blog> blogs, int warningCount, bool isBlocked,
            bool showWarning)?
        displaySuccess,
    TResult? Function(
            String message, int warningCount, bool isBlocked, bool showWarning)?
        failure,
  }) {
    return loading?.call(warningCount, isBlocked, showWarning);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int warningCount, bool isBlocked, bool showWarning)?
        initial,
    TResult Function(int warningCount, bool isBlocked, bool showWarning)?
        loading,
    TResult Function(int warningCount, bool isBlocked, bool showWarning)?
        uploadSuccess,
    TResult Function(List<Blog> blogs, int warningCount, bool isBlocked,
            bool showWarning)?
        displaySuccess,
    TResult Function(
            String message, int warningCount, bool isBlocked, bool showWarning)?
        failure,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(warningCount, isBlocked, showWarning);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BlogInitial value) initial,
    required TResult Function(BlogLoading value) loading,
    required TResult Function(BlogUploadSuccess value) uploadSuccess,
    required TResult Function(BlogDisplaySuccess value) displaySuccess,
    required TResult Function(BlogFailure value) failure,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BlogInitial value)? initial,
    TResult? Function(BlogLoading value)? loading,
    TResult? Function(BlogUploadSuccess value)? uploadSuccess,
    TResult? Function(BlogDisplaySuccess value)? displaySuccess,
    TResult? Function(BlogFailure value)? failure,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BlogInitial value)? initial,
    TResult Function(BlogLoading value)? loading,
    TResult Function(BlogUploadSuccess value)? uploadSuccess,
    TResult Function(BlogDisplaySuccess value)? displaySuccess,
    TResult Function(BlogFailure value)? failure,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class BlogLoading implements BlogState {
  const factory BlogLoading(
      {final int warningCount,
      final bool isBlocked,
      final bool showWarning}) = _$BlogLoadingImpl;

  @override
  int get warningCount;
  @override
  bool get isBlocked;
  @override
  bool get showWarning;
  @override
  @JsonKey(ignore: true)
  _$$BlogLoadingImplCopyWith<_$BlogLoadingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BlogUploadSuccessImplCopyWith<$Res>
    implements $BlogStateCopyWith<$Res> {
  factory _$$BlogUploadSuccessImplCopyWith(_$BlogUploadSuccessImpl value,
          $Res Function(_$BlogUploadSuccessImpl) then) =
      __$$BlogUploadSuccessImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int warningCount, bool isBlocked, bool showWarning});
}

/// @nodoc
class __$$BlogUploadSuccessImplCopyWithImpl<$Res>
    extends _$BlogStateCopyWithImpl<$Res, _$BlogUploadSuccessImpl>
    implements _$$BlogUploadSuccessImplCopyWith<$Res> {
  __$$BlogUploadSuccessImplCopyWithImpl(_$BlogUploadSuccessImpl _value,
      $Res Function(_$BlogUploadSuccessImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? warningCount = null,
    Object? isBlocked = null,
    Object? showWarning = null,
  }) {
    return _then(_$BlogUploadSuccessImpl(
      warningCount: null == warningCount
          ? _value.warningCount
          : warningCount // ignore: cast_nullable_to_non_nullable
              as int,
      isBlocked: null == isBlocked
          ? _value.isBlocked
          : isBlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      showWarning: null == showWarning
          ? _value.showWarning
          : showWarning // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$BlogUploadSuccessImpl implements BlogUploadSuccess {
  const _$BlogUploadSuccessImpl(
      {this.warningCount = 0,
      this.isBlocked = false,
      this.showWarning = false});

  @override
  @JsonKey()
  final int warningCount;
  @override
  @JsonKey()
  final bool isBlocked;
  @override
  @JsonKey()
  final bool showWarning;

  @override
  String toString() {
    return 'BlogState.uploadSuccess(warningCount: $warningCount, isBlocked: $isBlocked, showWarning: $showWarning)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlogUploadSuccessImpl &&
            (identical(other.warningCount, warningCount) ||
                other.warningCount == warningCount) &&
            (identical(other.isBlocked, isBlocked) ||
                other.isBlocked == isBlocked) &&
            (identical(other.showWarning, showWarning) ||
                other.showWarning == showWarning));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, warningCount, isBlocked, showWarning);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BlogUploadSuccessImplCopyWith<_$BlogUploadSuccessImpl> get copyWith =>
      __$$BlogUploadSuccessImplCopyWithImpl<_$BlogUploadSuccessImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int warningCount, bool isBlocked, bool showWarning)
        initial,
    required TResult Function(
            int warningCount, bool isBlocked, bool showWarning)
        loading,
    required TResult Function(
            int warningCount, bool isBlocked, bool showWarning)
        uploadSuccess,
    required TResult Function(List<Blog> blogs, int warningCount,
            bool isBlocked, bool showWarning)
        displaySuccess,
    required TResult Function(
            String message, int warningCount, bool isBlocked, bool showWarning)
        failure,
  }) {
    return uploadSuccess(warningCount, isBlocked, showWarning);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int warningCount, bool isBlocked, bool showWarning)?
        initial,
    TResult? Function(int warningCount, bool isBlocked, bool showWarning)?
        loading,
    TResult? Function(int warningCount, bool isBlocked, bool showWarning)?
        uploadSuccess,
    TResult? Function(List<Blog> blogs, int warningCount, bool isBlocked,
            bool showWarning)?
        displaySuccess,
    TResult? Function(
            String message, int warningCount, bool isBlocked, bool showWarning)?
        failure,
  }) {
    return uploadSuccess?.call(warningCount, isBlocked, showWarning);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int warningCount, bool isBlocked, bool showWarning)?
        initial,
    TResult Function(int warningCount, bool isBlocked, bool showWarning)?
        loading,
    TResult Function(int warningCount, bool isBlocked, bool showWarning)?
        uploadSuccess,
    TResult Function(List<Blog> blogs, int warningCount, bool isBlocked,
            bool showWarning)?
        displaySuccess,
    TResult Function(
            String message, int warningCount, bool isBlocked, bool showWarning)?
        failure,
    required TResult orElse(),
  }) {
    if (uploadSuccess != null) {
      return uploadSuccess(warningCount, isBlocked, showWarning);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BlogInitial value) initial,
    required TResult Function(BlogLoading value) loading,
    required TResult Function(BlogUploadSuccess value) uploadSuccess,
    required TResult Function(BlogDisplaySuccess value) displaySuccess,
    required TResult Function(BlogFailure value) failure,
  }) {
    return uploadSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BlogInitial value)? initial,
    TResult? Function(BlogLoading value)? loading,
    TResult? Function(BlogUploadSuccess value)? uploadSuccess,
    TResult? Function(BlogDisplaySuccess value)? displaySuccess,
    TResult? Function(BlogFailure value)? failure,
  }) {
    return uploadSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BlogInitial value)? initial,
    TResult Function(BlogLoading value)? loading,
    TResult Function(BlogUploadSuccess value)? uploadSuccess,
    TResult Function(BlogDisplaySuccess value)? displaySuccess,
    TResult Function(BlogFailure value)? failure,
    required TResult orElse(),
  }) {
    if (uploadSuccess != null) {
      return uploadSuccess(this);
    }
    return orElse();
  }
}

abstract class BlogUploadSuccess implements BlogState {
  const factory BlogUploadSuccess(
      {final int warningCount,
      final bool isBlocked,
      final bool showWarning}) = _$BlogUploadSuccessImpl;

  @override
  int get warningCount;
  @override
  bool get isBlocked;
  @override
  bool get showWarning;
  @override
  @JsonKey(ignore: true)
  _$$BlogUploadSuccessImplCopyWith<_$BlogUploadSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BlogDisplaySuccessImplCopyWith<$Res>
    implements $BlogStateCopyWith<$Res> {
  factory _$$BlogDisplaySuccessImplCopyWith(_$BlogDisplaySuccessImpl value,
          $Res Function(_$BlogDisplaySuccessImpl) then) =
      __$$BlogDisplaySuccessImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Blog> blogs, int warningCount, bool isBlocked, bool showWarning});
}

/// @nodoc
class __$$BlogDisplaySuccessImplCopyWithImpl<$Res>
    extends _$BlogStateCopyWithImpl<$Res, _$BlogDisplaySuccessImpl>
    implements _$$BlogDisplaySuccessImplCopyWith<$Res> {
  __$$BlogDisplaySuccessImplCopyWithImpl(_$BlogDisplaySuccessImpl _value,
      $Res Function(_$BlogDisplaySuccessImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? blogs = null,
    Object? warningCount = null,
    Object? isBlocked = null,
    Object? showWarning = null,
  }) {
    return _then(_$BlogDisplaySuccessImpl(
      blogs: null == blogs
          ? _value._blogs
          : blogs // ignore: cast_nullable_to_non_nullable
              as List<Blog>,
      warningCount: null == warningCount
          ? _value.warningCount
          : warningCount // ignore: cast_nullable_to_non_nullable
              as int,
      isBlocked: null == isBlocked
          ? _value.isBlocked
          : isBlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      showWarning: null == showWarning
          ? _value.showWarning
          : showWarning // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$BlogDisplaySuccessImpl implements BlogDisplaySuccess {
  const _$BlogDisplaySuccessImpl(
      {required final List<Blog> blogs,
      this.warningCount = 0,
      this.isBlocked = false,
      this.showWarning = false})
      : _blogs = blogs;

  final List<Blog> _blogs;
  @override
  List<Blog> get blogs {
    if (_blogs is EqualUnmodifiableListView) return _blogs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_blogs);
  }

  @override
  @JsonKey()
  final int warningCount;
  @override
  @JsonKey()
  final bool isBlocked;
  @override
  @JsonKey()
  final bool showWarning;

  @override
  String toString() {
    return 'BlogState.displaySuccess(blogs: $blogs, warningCount: $warningCount, isBlocked: $isBlocked, showWarning: $showWarning)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlogDisplaySuccessImpl &&
            const DeepCollectionEquality().equals(other._blogs, _blogs) &&
            (identical(other.warningCount, warningCount) ||
                other.warningCount == warningCount) &&
            (identical(other.isBlocked, isBlocked) ||
                other.isBlocked == isBlocked) &&
            (identical(other.showWarning, showWarning) ||
                other.showWarning == showWarning));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_blogs),
      warningCount,
      isBlocked,
      showWarning);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BlogDisplaySuccessImplCopyWith<_$BlogDisplaySuccessImpl> get copyWith =>
      __$$BlogDisplaySuccessImplCopyWithImpl<_$BlogDisplaySuccessImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int warningCount, bool isBlocked, bool showWarning)
        initial,
    required TResult Function(
            int warningCount, bool isBlocked, bool showWarning)
        loading,
    required TResult Function(
            int warningCount, bool isBlocked, bool showWarning)
        uploadSuccess,
    required TResult Function(List<Blog> blogs, int warningCount,
            bool isBlocked, bool showWarning)
        displaySuccess,
    required TResult Function(
            String message, int warningCount, bool isBlocked, bool showWarning)
        failure,
  }) {
    return displaySuccess(blogs, warningCount, isBlocked, showWarning);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int warningCount, bool isBlocked, bool showWarning)?
        initial,
    TResult? Function(int warningCount, bool isBlocked, bool showWarning)?
        loading,
    TResult? Function(int warningCount, bool isBlocked, bool showWarning)?
        uploadSuccess,
    TResult? Function(List<Blog> blogs, int warningCount, bool isBlocked,
            bool showWarning)?
        displaySuccess,
    TResult? Function(
            String message, int warningCount, bool isBlocked, bool showWarning)?
        failure,
  }) {
    return displaySuccess?.call(blogs, warningCount, isBlocked, showWarning);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int warningCount, bool isBlocked, bool showWarning)?
        initial,
    TResult Function(int warningCount, bool isBlocked, bool showWarning)?
        loading,
    TResult Function(int warningCount, bool isBlocked, bool showWarning)?
        uploadSuccess,
    TResult Function(List<Blog> blogs, int warningCount, bool isBlocked,
            bool showWarning)?
        displaySuccess,
    TResult Function(
            String message, int warningCount, bool isBlocked, bool showWarning)?
        failure,
    required TResult orElse(),
  }) {
    if (displaySuccess != null) {
      return displaySuccess(blogs, warningCount, isBlocked, showWarning);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BlogInitial value) initial,
    required TResult Function(BlogLoading value) loading,
    required TResult Function(BlogUploadSuccess value) uploadSuccess,
    required TResult Function(BlogDisplaySuccess value) displaySuccess,
    required TResult Function(BlogFailure value) failure,
  }) {
    return displaySuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BlogInitial value)? initial,
    TResult? Function(BlogLoading value)? loading,
    TResult? Function(BlogUploadSuccess value)? uploadSuccess,
    TResult? Function(BlogDisplaySuccess value)? displaySuccess,
    TResult? Function(BlogFailure value)? failure,
  }) {
    return displaySuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BlogInitial value)? initial,
    TResult Function(BlogLoading value)? loading,
    TResult Function(BlogUploadSuccess value)? uploadSuccess,
    TResult Function(BlogDisplaySuccess value)? displaySuccess,
    TResult Function(BlogFailure value)? failure,
    required TResult orElse(),
  }) {
    if (displaySuccess != null) {
      return displaySuccess(this);
    }
    return orElse();
  }
}

abstract class BlogDisplaySuccess implements BlogState {
  const factory BlogDisplaySuccess(
      {required final List<Blog> blogs,
      final int warningCount,
      final bool isBlocked,
      final bool showWarning}) = _$BlogDisplaySuccessImpl;

  List<Blog> get blogs;
  @override
  int get warningCount;
  @override
  bool get isBlocked;
  @override
  bool get showWarning;
  @override
  @JsonKey(ignore: true)
  _$$BlogDisplaySuccessImplCopyWith<_$BlogDisplaySuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BlogFailureImplCopyWith<$Res>
    implements $BlogStateCopyWith<$Res> {
  factory _$$BlogFailureImplCopyWith(
          _$BlogFailureImpl value, $Res Function(_$BlogFailureImpl) then) =
      __$$BlogFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String message, int warningCount, bool isBlocked, bool showWarning});
}

/// @nodoc
class __$$BlogFailureImplCopyWithImpl<$Res>
    extends _$BlogStateCopyWithImpl<$Res, _$BlogFailureImpl>
    implements _$$BlogFailureImplCopyWith<$Res> {
  __$$BlogFailureImplCopyWithImpl(
      _$BlogFailureImpl _value, $Res Function(_$BlogFailureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? warningCount = null,
    Object? isBlocked = null,
    Object? showWarning = null,
  }) {
    return _then(_$BlogFailureImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      warningCount: null == warningCount
          ? _value.warningCount
          : warningCount // ignore: cast_nullable_to_non_nullable
              as int,
      isBlocked: null == isBlocked
          ? _value.isBlocked
          : isBlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      showWarning: null == showWarning
          ? _value.showWarning
          : showWarning // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$BlogFailureImpl implements BlogFailure {
  const _$BlogFailureImpl(
      {required this.message,
      this.warningCount = 0,
      this.isBlocked = false,
      this.showWarning = false});

  @override
  final String message;
  @override
  @JsonKey()
  final int warningCount;
  @override
  @JsonKey()
  final bool isBlocked;
  @override
  @JsonKey()
  final bool showWarning;

  @override
  String toString() {
    return 'BlogState.failure(message: $message, warningCount: $warningCount, isBlocked: $isBlocked, showWarning: $showWarning)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlogFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.warningCount, warningCount) ||
                other.warningCount == warningCount) &&
            (identical(other.isBlocked, isBlocked) ||
                other.isBlocked == isBlocked) &&
            (identical(other.showWarning, showWarning) ||
                other.showWarning == showWarning));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, message, warningCount, isBlocked, showWarning);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BlogFailureImplCopyWith<_$BlogFailureImpl> get copyWith =>
      __$$BlogFailureImplCopyWithImpl<_$BlogFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int warningCount, bool isBlocked, bool showWarning)
        initial,
    required TResult Function(
            int warningCount, bool isBlocked, bool showWarning)
        loading,
    required TResult Function(
            int warningCount, bool isBlocked, bool showWarning)
        uploadSuccess,
    required TResult Function(List<Blog> blogs, int warningCount,
            bool isBlocked, bool showWarning)
        displaySuccess,
    required TResult Function(
            String message, int warningCount, bool isBlocked, bool showWarning)
        failure,
  }) {
    return failure(message, warningCount, isBlocked, showWarning);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int warningCount, bool isBlocked, bool showWarning)?
        initial,
    TResult? Function(int warningCount, bool isBlocked, bool showWarning)?
        loading,
    TResult? Function(int warningCount, bool isBlocked, bool showWarning)?
        uploadSuccess,
    TResult? Function(List<Blog> blogs, int warningCount, bool isBlocked,
            bool showWarning)?
        displaySuccess,
    TResult? Function(
            String message, int warningCount, bool isBlocked, bool showWarning)?
        failure,
  }) {
    return failure?.call(message, warningCount, isBlocked, showWarning);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int warningCount, bool isBlocked, bool showWarning)?
        initial,
    TResult Function(int warningCount, bool isBlocked, bool showWarning)?
        loading,
    TResult Function(int warningCount, bool isBlocked, bool showWarning)?
        uploadSuccess,
    TResult Function(List<Blog> blogs, int warningCount, bool isBlocked,
            bool showWarning)?
        displaySuccess,
    TResult Function(
            String message, int warningCount, bool isBlocked, bool showWarning)?
        failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(message, warningCount, isBlocked, showWarning);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BlogInitial value) initial,
    required TResult Function(BlogLoading value) loading,
    required TResult Function(BlogUploadSuccess value) uploadSuccess,
    required TResult Function(BlogDisplaySuccess value) displaySuccess,
    required TResult Function(BlogFailure value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BlogInitial value)? initial,
    TResult? Function(BlogLoading value)? loading,
    TResult? Function(BlogUploadSuccess value)? uploadSuccess,
    TResult? Function(BlogDisplaySuccess value)? displaySuccess,
    TResult? Function(BlogFailure value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BlogInitial value)? initial,
    TResult Function(BlogLoading value)? loading,
    TResult Function(BlogUploadSuccess value)? uploadSuccess,
    TResult Function(BlogDisplaySuccess value)? displaySuccess,
    TResult Function(BlogFailure value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class BlogFailure implements BlogState {
  const factory BlogFailure(
      {required final String message,
      final int warningCount,
      final bool isBlocked,
      final bool showWarning}) = _$BlogFailureImpl;

  String get message;
  @override
  int get warningCount;
  @override
  bool get isBlocked;
  @override
  bool get showWarning;
  @override
  @JsonKey(ignore: true)
  _$$BlogFailureImplCopyWith<_$BlogFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
