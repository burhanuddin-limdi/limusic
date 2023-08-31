String formatSongTitle(String title) {
  final patterns = {
    RegExp(r'\[.*\]'): '',
    RegExp(r'\(.*'): '',
    RegExp(r'\|.*'): '',
  };

  for (final pattern in patterns.keys) {
    title = title.replaceFirst(pattern, patterns[pattern]!);
  }

  return title
      .trim()
      .replaceAll('&amp;', '&')
      .replaceAll('&#039;', "'")
      .replaceAll('&quot;', '"');
}

String formatDuration(int milliseconds) {
  final duration = Duration(milliseconds: milliseconds);

  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);

  var formattedDuration = '';

  if (hours > 0) {
    formattedDuration += '${hours.toString().padLeft(2, '0')}:';
  }

  formattedDuration += '${minutes.toString().padLeft(2, '0')}:';
  formattedDuration += seconds.toString().padLeft(2, '0');

  return formattedDuration;
}
