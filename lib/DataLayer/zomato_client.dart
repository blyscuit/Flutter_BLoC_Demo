/*
 * Copyright (c) 2019 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import 'dart:async';
import 'dart:convert' show json;

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'location.dart';
import 'restaurant.dart';

class ZomatoClient {
  final _apiID = 'ZXJJ4F2USFME32M0WZUJZKI2A4V5T4TEIHTLKEAHJWMW2CCQ';
  final _apiSecret = '34XPES3VGVEFBTSWSGBVVHFIMQVQ42QNTFWMOEUS4C51C5VU';
  final _host = 'api.foursquare.com';
  final _contextRoot = 'v2';

  Future<List<Location>> fetchLocations(String query) async {
    final results = await request(
        path: 'venues/explore', parameters: {'limit': '10', 'near': query});
    final suggestions = results['response']['groups'][0]['items'];
    return suggestions
        .map<Location>((json) => Location.fromJson(json))
        .toList(growable: false);
  }

  Future<List<Restaurant>> fetchRestaurants(
      Location location, String query) async {
    final results = await request(
        path: 'venues/search', parameters: {'near': location.title, 'limit': '10', 'query': query});

print(results);

    final restaurants = results['response']['venues'];

    return restaurants
        .map<Restaurant>((json) => Restaurant.fromJson(json))
        .toList(growable: false);
  }

  Future<Map> request(
      {@required String path, Map<String, String> parameters}) async {
    parameters.addAll(
        {'client_id': _apiID, 'client_secret': _apiSecret, 'v': "20180323"});
    final uri = Uri.https(_host, '$_contextRoot/$path', parameters);
    final results = await http.get(uri, headers: _headers);
    final jsonObject = json.decode(results.body);
    return jsonObject;
  }

  Map<String, String> get _headers => {
        'Accept': 'application/json',
        'client_id': _apiID,
        'client_secret': _apiSecret
      };
}
