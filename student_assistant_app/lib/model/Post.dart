
class Post {
  final String ownerName;
  final String ownerId;
  final String postId;
  final String text;
  final List<String> comments;
  final String fileUrl;
  final String filePath;
  final String type;

  Post(
      {this.ownerId,
      this.text,
      this.comments,
      this.postId,
      this.ownerName,
      this.fileUrl,
      this.filePath,
      this.type});

}
