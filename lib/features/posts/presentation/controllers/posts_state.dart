import 'package:flutter_core_base/core/pagination/paged_state.dart';
import 'package:flutter_core_base/features/posts/domain/entities/post.dart';

/// The posts feed is a plain paged list; all of its state lives in the shared
/// [PagedState]. Kept as an alias so call sites read as `PostsState`.
typedef PostsState = PagedState<Post>;
