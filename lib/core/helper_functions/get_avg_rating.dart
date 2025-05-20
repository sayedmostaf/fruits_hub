num getAvgRating(List<dynamic> reviews) {
  if (reviews.isEmpty) {
    return 0.0;
  }
  var sum = 0.0;
  for (var review in reviews) {
    sum += (review as Map<String, dynamic>)['ratting'] ?? 0.0;
  }
  return sum / reviews.length;
}
