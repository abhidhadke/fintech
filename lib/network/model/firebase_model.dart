class News{

  String? newsTitle;
  String? newsBody;
  DateTime? created;

  News();

  News.fromSnapshot(snapshot)
    : newsTitle = snapshot.data()['news_title'],
      newsBody = snapshot.data()['news_body'],
      created = snapshot.data()['news_time'].toDate();
}