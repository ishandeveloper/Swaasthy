// Enums For All The Different Types Of Post Components

enum ForumPostType {
  text,
  video,
  singleimage,
  multiimage,
  link,
  youtube,
  richText,
  poll
}

/* 
  0 is for Text Type Posts

  1 is for Posts with Self-Hosted-Video.

  2 is for Posts with Single Image.

  3 is for Posts with Multiple Images.

  4 is for Posts with Links.

  5 is for Posts with Youtube Videos

  6 is for Posts with Rich Text

  7 is for Posts with Poll

*/

checkForumPostType(int type) {
  int _type = type;

  switch (_type) {

    // In case of a text-type post
    case 0:
      return ForumPostType.text;
      break;

    // In case of a single-image-type post
    case 1:
      return ForumPostType.singleimage;
      break;

    // In case of a video-type post
    case 2:
      return ForumPostType.video;
      break;

    // In case of a multi-image-type post
    case 3:
      return ForumPostType.multiimage;
      break;

    // In case of a link-type post
    case 4:
      return ForumPostType.link;
      break;

    // In case of a youtube post
    case 5:
      return ForumPostType.youtube;
      break;

    // In case of a rich text type post
    case 6:
      return ForumPostType.richText;
      break;

    // In case of a rich text type post
    case 7:
      return ForumPostType.poll;
      break;

    default:
      return null;
  }
}

// Enums for different states of connection
enum ConnectionStatus {
  WiFi,
  Cellular,
  Offline,
}
