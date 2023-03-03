import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/ActivityPub/actor.dart';
import '../Models/ActivityPub/ordered_collection.dart';

class FollowersProvider {
  FollowersProvider();

  Future<OrderedCollection> getFollowers(String followerEndpoint) async {
    http.Response response = await http.get(
      Uri.parse(followerEndpoint),
      headers: <String, String>{"Accept": "application/json"},
    );

    String jsonString = response.body;
    OrderedCollection collection = OrderedCollection.fromJson(jsonDecode(jsonString));
    return collection;
  }
}
