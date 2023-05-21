import 'dart:convert';
import 'package:fedodo_micro/APIs/auth_base_api.dart';
import 'package:fedodo_micro/Models/ActivityPub/ordered_collection_page.dart';
import 'package:http/http.dart' as http;
import '../../Globals/preferences.dart';
import '../../Models/ActivityPub/ordered_paged_collection.dart';

class SharesAPI {
  Future<OrderedPagedCollection> getShares(String postId) async {
    String formattedUrl =
        "https://${Preferences.prefs!.getString("DomainName")}/shares/${Uri.encodeQueryComponent(postId)}";

    http.Response response =
        await http.get(Uri.parse(formattedUrl), headers: <String, String>{});

    OrderedPagedCollection collection = OrderedPagedCollection.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    return collection;
  }

  Future<bool> isPostShared(String postId) async {
    OrderedPagedCollection shares = await getShares(postId);

    String url = shares.first!;
    do {
      http.Response response = await http.get(
        Uri.parse(url),
      );

      OrderedCollectionPage collection = OrderedCollectionPage.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      if (collection.orderedItems.isEmpty) {
        return false;
      }

      if (collection.orderedItems
          .where((element) => element.actor == Preferences.prefs!.getString("ActorId"))
          .isNotEmpty) {
        return true;
      }

      url = collection.next!;
    } while (true);

    return false;
  }

  void share(String postId) async {
    Map<String, dynamic> body = {
      "to": ["as:Public"],
      "type": "Announce",
      "object": postId
    };

    String json = jsonEncode(body);

    var result = await AuthBaseApi.post(
      url: Uri.parse("https://${Preferences.prefs!.getString("DomainName")}/outbox/${Preferences.prefs!.getString("UserId")}"),
      headers: <String, String>{
        "content-type": "application/json",
      },
      body: json,
    );

    var bodyString = result.body;
  }
}
