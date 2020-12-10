import 'dart:convert' show utf8, json;
import 'dart:io';
import 'dart:math';
import 'package:english_words/english_words.dart';

class PostModel {
  final String description;
  final String id, userImg, userName, timeTaken;
  final String loadedImg;

  PostModel(
      {this.description,
      this.id,
      this.userImg,
      this.userName,
      this.timeTaken,
      this.loadedImg = ""});
}

class PostFetcher {
  final _count = 40;
  final _itemsPerPage = 10;
  int _currentPage = 0;
  Random random = new Random();

  Future<List<PostModel>> fetchPostsList(int amount) async {
    var url = 'https://randomuser.me/api/?results=$amount&nat=us';
    var httpClient = new HttpClient();

    final posts = <PostModel>[];
    final n = min(_itemsPerPage, _count - _currentPage * _itemsPerPage);
    if (n <= 0) {
      return [];
    }
    print('Now on page $_currentPage');
    try {
      await Future.delayed(Duration(seconds: 1));
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var jsonx = await response.transform(utf8.decoder).join();
        Map data = json.decode(jsonx);

        for (var res in data['results']) {
          var objName = res['name'];
          String name =
              objName['first'].toString() + " " + objName['last'].toString();
          var objImage = res['picture'];
          String profileUrl = objImage['large'].toString();
          PostModel post = new PostModel(
              id: "1",
              timeTaken: '${random.nextInt(24) + 1}h${random.nextInt(60) + 1}m',
              userImg: profileUrl,
              userName: name,
              description: generateWordPairs()
                  .take(random.nextInt(10) + 10)
                  .toList()
                  .join(" "));
          posts.add(post);
        }
      }
      _currentPage++;

      return posts;
    } catch (exception) {
      print(exception.toString());
      return [];
    }
  }
}
