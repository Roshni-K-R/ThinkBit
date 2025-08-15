import 'package:ThinkBit/core/utils/calculate_reading_time.dart';
import 'package:ThinkBit/features/blog/domain/entities/blog.dart';
import 'package:ThinkBit/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final Color color;
  const BlogCard({
    super.key,
    required this.blog,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, BlogViewerPage.route(blog));
      },
      child: Container(
        height: 200,
        margin: const EdgeInsets.all(16).copyWith(bottom: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: blog.imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                  imageUrl: blog.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: color.withOpacity(0.1),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: color.withOpacity(0.1),
                    child: const Icon(Icons.broken_image, size: 40),
                  ),
                )
                    : Container(
                  color: color.withOpacity(0.1),
                  child: Center(
                    child: Icon(
                      Icons.image,
                      size: 40,
                      color: color.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ),
            // Dark Overlay for Text Readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black.withOpacity(0.3), // Adjust opacity as needed
                ),
              ),
            ),
            // Content Overlay
            Positioned.fill(
              child:Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Topics Chips
                    if (blog.topics.isNotEmpty)
                      SizedBox(
                        height: 32,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: blog.topics.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Chip(
                                label: Text(
                                  blog.topics[index],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: Colors.black.withOpacity(0.4),
                                visualDensity: VisualDensity.compact,
                              ),
                            );
                          },
                        ),
                      ),
                    // Spacer to push content to bottom
                    const Spacer(),
                    // Title and Metadata
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          blog.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${calculateReadingTime(blog.content)} min read',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            if (blog.updatedAt != null || blog.updatedAt != null)
                              Row(
                                children: [
                                  if (blog.posterName != null)
                                    Text(
                                      blog.posterName!,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  if (blog.updatedAt!= null)
                                    Text(
                                      ' • ${DateFormat('MMM d').format(blog.updatedAt!)}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}