import 'dart:convert';
import 'package:fedodo_micro/Extensions/url_extensions.dart';
import 'package:fedodo_micro/Models/ActivityPub/ordered_collection_page.dart';
import 'package:fedodo_micro/Models/ActivityPub/ordered_paged_collection.dart';
import 'package:http/http.dart' as http;

import '../../Globals/preferences.dart';

class OutboxAPI {
  Future<OrderedPagedCollection> getFirstPage(String outboxUrl) async {

    Uri outboxUri = Uri.parse(outboxUrl);

    if(outboxUri.authority != Preferences.prefs!.getString("DomainName")){
      outboxUri = outboxUri.asProxyUri();
    }

    http.Response pageResponse = await http.get(outboxUri);
    OrderedPagedCollection collection = OrderedPagedCollection.fromJson(jsonDecode(utf8.decode(pageResponse.bodyBytes)));
    return collection;
  }

  Future<OrderedCollectionPage> getPosts(String nextUrl) async {

    Uri nextUri = Uri.parse(nextUrl);

    if(nextUri.authority != Preferences.prefs!.getString("DomainName")){
      nextUri = nextUri.asProxyUri();
    }

    http.Response pageResponse = await http.get(nextUri);

    OrderedCollectionPage collection = OrderedCollectionPage.fromJson(jsonDecode(utf8.decode(pageResponse.bodyBytes)));

    return collection;
  }
}
