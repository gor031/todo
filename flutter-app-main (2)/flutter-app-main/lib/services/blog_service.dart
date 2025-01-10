import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BlogService {
  static const String apiKey = 'AIzaSyBRuwJnY2jeoB20aVLtiJoet-jlHMbwSqU';
  static const String blogId = '3451078878396375552';

  static Uri _buildUri() {
    return Uri.parse('https://www.googleapis.com/blogger/v3/blogs/$blogId/posts'
        '?key=$apiKey'
        '&maxResults=10'
        '&orderBy=published'
        '&fields=items(id,title,content,published,url)');
  }

  static Future<List<Map<String, dynamic>>> fetchPosts() async {
    List<Map<String, dynamic>> posts = [];

    try {
      debugPrint('API 요청 시작...');
      final response = await http.get(_buildUri());

      if (response.statusCode == 200) {
        debugPrint('API 응답 성공');
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['items'] == null) return posts;

        final List<dynamic> items = data['items'];

        for (var item in items) {
          String thumbnailUrl = '';
          final String content = item['content'] as String;

          try {
            // 실제 URL 확인을 위한 로그
            debugPrint('\n=== 포스트 데이터 ===');
            debugPrint('제목: ${item['title']}');
            debugPrint('컨텐츠: $content');

            final matches = RegExp(
                    r'src="(https:\/\/blogger\.googleusercontent\.com[^"]+)"')
                .allMatches(content);

            if (matches.isNotEmpty) {
              thumbnailUrl = matches.first.group(1) ?? '';
              // URL에서 width 파라미터 제거
              thumbnailUrl = thumbnailUrl.replaceAll(RegExp(r'=w\d+'), '');
              debugPrint('추출된 이미지 URL: $thumbnailUrl');
            } else {
              // 다른 패턴으로도 시도
              final alternativeMatches =
                  RegExp(r'src="([^"]+\.(?:jpg|jpeg|png|gif))"')
                      .allMatches(content);
              if (alternativeMatches.isNotEmpty) {
                thumbnailUrl = alternativeMatches.first.group(1) ?? '';
                debugPrint('대체 패턴으로 찾은 이미지 URL: $thumbnailUrl');
              } else {
                debugPrint('이미지 URL을 찾을 수 없음');
              }
            }

            // URL이 //로 시작하면 https: 추가
            if (thumbnailUrl.startsWith('//')) {
              thumbnailUrl = 'https:$thumbnailUrl';
            }
          } catch (e) {
            debugPrint('이미지 처리 중 오류: $e');
          }

          // 디버그용 출력
          debugPrint('최종 thumbnail URL: $thumbnailUrl');

          posts.add({
            'id': item['id'],
            'title': item['title'],
            'description': content.replaceAll(RegExp(r'<[^>]*>'), ''),
            'content': content,
            'link': item['url'],
            'thumbnail': thumbnailUrl,
            'commentCount': 0,
            'likesCount': 0,
            'isFavorite': false,
            'published': DateTime.parse(item['published']).toString(),
          });
        }
      } else {
        debugPrint('API 오류: ${response.statusCode}');
        debugPrint('오류 내용: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }

    return posts;
  }
}
