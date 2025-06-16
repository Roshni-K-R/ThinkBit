class BlogDraft {
  final String? title;
  final String? content;
  final List<String> topics;
  final String? imagePath;

  BlogDraft({
    this.title,
    this.content,
    this.topics = const [],
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'topics': topics,
      'imagePath': imagePath,
    };
  }

  factory BlogDraft.fromMap(Map<String, dynamic> map) {
    return BlogDraft(
      title: map['title'],
      content: map['content'],
      topics: List<String>.from(map['topics'] ?? []),
      imagePath: map['imagePath'],
    );
  }
}