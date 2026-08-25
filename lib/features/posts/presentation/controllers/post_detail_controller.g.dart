// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PostDetailController)
final postDetailControllerProvider = PostDetailControllerFamily._();

final class PostDetailControllerProvider
    extends $AsyncNotifierProvider<PostDetailController, Post> {
  PostDetailControllerProvider._({
    required PostDetailControllerFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'postDetailControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$postDetailControllerHash();

  @override
  String toString() {
    return r'postDetailControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PostDetailController create() => PostDetailController();

  @override
  bool operator ==(Object other) {
    return other is PostDetailControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postDetailControllerHash() =>
    r'7c7416b5687b9d09d5773e5dce462356e7137001';

final class PostDetailControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          PostDetailController,
          AsyncValue<Post>,
          Post,
          FutureOr<Post>,
          int
        > {
  PostDetailControllerFamily._()
    : super(
        retry: null,
        name: r'postDetailControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PostDetailControllerProvider call(int id) =>
      PostDetailControllerProvider._(argument: id, from: this);

  @override
  String toString() => r'postDetailControllerProvider';
}

abstract class _$PostDetailController extends $AsyncNotifier<Post> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  FutureOr<Post> build(int id);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Post>, Post>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Post>, Post>,
              AsyncValue<Post>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
