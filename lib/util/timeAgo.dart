String timeAgo(DateTime dateTime) {
  final Duration difference = DateTime.now().difference(dateTime);
  if (difference.inDays >= 365) {
    return '${difference.inDays ~/ 365}년';
  } else if (difference.inDays >= 30) {
    return '${difference.inDays ~/ 30}달';
  } else if (difference.inDays >= 7) {
    return '${difference.inDays ~/ 7}주';
  } else if (difference.inDays >= 1) {
    return '${difference.inDays}일';
  } else if (difference.inHours >= 1) {
    return '${difference.inHours}시간';
  } else if (difference.inMinutes >= 1) {
    return '${difference.inMinutes}분';
  } else if (difference.inSeconds >= 1) {
    return '${difference.inSeconds}초';
  } else {
    return '방금';
  }
}
