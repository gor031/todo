import 'package:flutter/material.dart';
import '../services/blog_service.dart';

class BlogProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _lastPostId;

  // Getters
  List<Map<String, dynamic>> get items => _items;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final posts = await BlogService.fetchPosts();

      _items.clear();
      _items.addAll(posts);
      if (posts.isNotEmpty) {
        _lastPostId = posts[0]['id'];
      }
    } catch (e) {
      debugPrint('Error in BlogProvider.fetchPosts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkNewPosts() async {
    try {
      final posts = await BlogService.fetchPosts();

      if (posts.isNotEmpty && posts[0]['id'] != _lastPostId) {
        for (var post in posts) {
          if (post['id'] == _lastPostId) break;
          _items.insert(0, post);
        }
        _lastPostId = posts[0]['id'];
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error in BlogProvider.checkNewPosts: $e');
    }
  }

  void setLoginState(bool isLoggedIn) {
    _isLoggedIn = isLoggedIn;
    notifyListeners();
  }

  void updateLikes(String id, int likes) {
    final index = _items.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      _items[index]['likesCount'] = likes;
      notifyListeners();
    }
  }

  void updateComments(String id, int comments) {
    final index = _items.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      _items[index]['commentCount'] = comments;
      notifyListeners();
    }
  }

  void toggleFavorite(String id) {
    final index = _items.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      _items[index]['isFavorite'] = !_items[index]['isFavorite'];
      notifyListeners();
    }
  }
}
