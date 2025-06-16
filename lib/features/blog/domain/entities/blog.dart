class Blog {
  final String id;
  final String posterId;
  final String title;
  final String content;
  final String imageUrl;
  final List<String> topics;
  final DateTime updatedAt;
  final String? posterName;

  //new which i added now
  final int? likeCount;
  final int? commentCount;
  final bool? isLiked;

  Blog({
    required this.id,
    required this.posterId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.topics,
    required this.updatedAt,
    this.posterName,

    //new which i added now
    this.commentCount,
    this.isLiked,
    this.likeCount,
  });
}

class BlogComment {
  final String id;
  final String content;
  final DateTime updatedAt;
  final String userId;
  final String postId;
  final String authorName;

  BlogComment({
    required this.id,
    required this.content,
    required this.updatedAt,
    required this.userId,
    required this.postId,
    required this.authorName,
  });

  factory BlogComment.fromJson(Map<String, dynamic> json) {
    return BlogComment(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toString()),
      userId: json['user_id'] ?? '',
      postId: json['post_id'] ?? '',
      authorName: json['profiles']?['name'] ?? 'Unknown',
    );
  }
}