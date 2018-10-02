class Post {
  
  final int author;
  final int id;
  final String slug;
  final String type;

  Post({this.author, this.id, this.slug, this.type});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      author: json['author'],
      id: json['id'],
      slug: json['slug'],
      type: json['type'],
    );
  }

}