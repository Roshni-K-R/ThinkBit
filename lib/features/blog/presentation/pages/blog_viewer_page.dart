import 'package:flutter/material.dart';
import 'package:ThinkBit/core/theme/app_pallete.dart';
import 'package:ThinkBit/core/utils/calculate_reading_time.dart';
import 'package:ThinkBit/core/utils/format_date.dart';
import 'package:ThinkBit/features/blog/domain/entities/blog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class BlogViewerPage extends StatefulWidget {
  static route(Blog blog) => MaterialPageRoute(
    builder: (context) => BlogViewerPage(blog: blog),
  );

  final Blog blog;
  const BlogViewerPage({super.key, required this.blog});

  @override
  State<BlogViewerPage> createState() => _BlogViewerPageState();
}

class _BlogViewerPageState extends State<BlogViewerPage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  final TextEditingController _commentController = TextEditingController();
  //final List<Map<String, dynamic>> _comments = [];
  bool _showComments = false;
  bool _isLiked = false;
  int _likeCount=0;
  bool _isLoading = true;
  late final RealtimeChannel _realtimeChannel;
  final FocusNode _commentFocusNode = FocusNode();

  List<BlogComment> _comments = [];
  bool _isLoadingComments = false;

  @override
  void initState() {
    super.initState();
    _realtimeChannel = _supabase.channel('blog_${widget.blog.id}');
    _loadInitialData();
    _setupRealtimeUpdates();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      _checkIfLiked(),
      _getLikeCount(),
      _loadComments(),
    ]);
    setState(() => _isLoading = false);
  }

  Future<void> _checkIfLiked() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final res = await _supabase
          .from('likes')
          .select()
          .eq('user_id', userId)
          .eq('post_id', widget.blog.id)
          .maybeSingle();

      setState(() => _isLiked = res != null);
    } catch (e) {
      debugPrint('Error checking like status: $e');
    }
  }

  Future<void> _getLikeCount() async {
    try {
      final response = await _supabase
          .from('likes')
          .select()
          .eq('post_id', widget.blog.id);

      setState(() => _likeCount = response.length);
    } catch (e) {
      debugPrint('Error getting like count: $e');
      setState(() => _likeCount = 0);
    }
  }


  void _setupRealtimeUpdates() {
    _realtimeChannel
      ..onPostgresChanges(
        event: PostgresChangeEvent.all, // Use ALL instead of separate insert/delete
        schema: 'public',
        table: 'likes',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'post_id',
          value: widget.blog.id,
        ),
        callback: (payload) {
          debugPrint('Like update: $payload');
          if (payload.eventType == 'INSERT') {
            setState(() {
              _likeCount++;
              if (payload.newRecord['user_id'] == _supabase.auth.currentUser?.id) {
                _isLiked = true;
              }
            });
          } else if (payload.eventType == 'DELETE') {
            setState(() {
              _likeCount--;
              if (payload.oldRecord['user_id'] == _supabase.auth.currentUser?.id) {
                _isLiked = false;
              }
            });
          }
        },
      )
      ..onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'comments',
        callback: (payload) {
          if (payload.newRecord['post_id'] == widget.blog.id) {
            _loadComments();
          }
        },
      )
      ..subscribe();
  }

  Future<void> _toggleLike() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    // Optimistic UI update
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });

    try {
      if (_isLiked) {
        await _supabase.from('likes').upsert({
          'user_id': userId,
          'post_id': widget.blog.id,
          'created_at': DateTime.now().toIso8601String(),
        });
      } else {
        await _supabase
            .from('likes')
            .delete()
            .eq('user_id', userId)
            .eq('post_id', widget.blog.id);
      }
    } catch (e) {
      // Rollback on error
      setState(() {
        _isLiked = !_isLiked;
        _likeCount += _isLiked ? 1 : -1;
      });
      debugPrint('Like error: $e');
    }
  }

// Add this method to fetch comments
  Future<void> _loadComments() async {
    setState(() => _isLoadingComments = true);
    try {
      final response = await _supabase
          .from('comments')
          .select('*, profiles(name)')
          .eq('post_id', widget.blog.id)
          .order('updated_at', ascending: false);

      setState(() {
        _comments = response.map((json) => BlogComment.fromJson(json)).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load comments: $e')),
      );
    } finally {
      setState(() => _isLoadingComments = false);
    }
  }

// Add this method to post comments
  Future<void> _postComment() async {
    final userId = _supabase.auth.currentUser?.id;
    final content = _commentController.text.trim();

    if (userId == null || content.isEmpty) return;

    try {
      await _supabase.from('comments').insert({
        'user_id': userId,
        'post_id': widget.blog.id,
        'content': content,
      });

      _commentController.clear();
      await _loadComments(); // Refresh comments
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post comment: $e')),
      );
    }
  }



  @override
  void dispose() {
    _realtimeChannel.unsubscribe();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _sharePost(context),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.blog.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      child: Text(
                        widget.blog.posterName![0].toUpperCase(),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.blog.posterName!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${formatDateBydMMMYYYY(widget.blog.updatedAt)} • ${calculateReadingTime(widget.blog.content)} min read',
                            style: TextStyle(
                              color: AppPallete.greyColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.blog.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInteractionBar(),
                const SizedBox(height: 24),
                Text(
                  widget.blog.content,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
                if (_showComments) _buildCommentsSection(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
         padding: const EdgeInsets.only(bottom: 44.0), // Adjust this value to move up/down
         child: Align(
         alignment: Alignment.bottomRight,
        child: FloatingActionButton.small(
          onPressed: () {
            setState(() => _showComments = true);
            // Request focus after a small delay to allow the widget to build
            Future.delayed(const Duration(milliseconds: 100), () {
              FocusScope.of(context).requestFocus(_commentFocusNode);
            });
            Scrollable.ensureVisible(
              context,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          child: const Icon(Icons.comment),
        ),
      ),
      ),
    );
  }

  Widget _buildInteractionBar() {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            _isLiked ? Icons.favorite : Icons.favorite_border,
            color: _isLiked ? AppPallete.errorColor : null,
          ),
          onPressed: _toggleLike,
        ),
        Text(_likeCount.toString()),
        const SizedBox(width: 16),
        IconButton(
          icon: const Icon(Icons.comment),
          onPressed: () => setState(() => _showComments = !_showComments),
        ),
        Text(_comments.length.toString()),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.bookmark_border),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 8),
        const Text(
          'Comments',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (_comments.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Text(
              'No comments yet. Be the first to comment!',
              style: TextStyle(color: AppPallete.greyColor),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _comments.length,
            separatorBuilder: (_, __) => const Divider(height: 24),
            itemBuilder: (context, index) {
              final comment = _comments[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        child: Text(
                          comment.authorName[0].toUpperCase(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        comment.authorName,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      Text(
                        DateFormat('MMM d').format(comment.updatedAt),
                        style: TextStyle(
                          color: AppPallete.greyColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(comment.content),
                ],
              );
            },
          ),
        const SizedBox(height: 16),
        TextField(
          focusNode: _commentFocusNode, // Add this line
          controller: _commentController,
          decoration: InputDecoration(
            hintText: 'Write a comment...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: _postComment,
            ),
          ),
          maxLines: 3,
          minLines: 1,
          onSubmitted: (_) {
            _postComment();
            _commentFocusNode.unfocus();
          }
        ),
      ],
    );
  }

  void _sharePost(BuildContext context) {
    // Implement share functionality
  }
}