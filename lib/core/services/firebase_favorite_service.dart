import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fruits_hub/core/services/favorite_service.dart';

class FirebaseFavoriteService implements FavoriteService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<String>? _cachedFavorites;

  String get userId {
    final user = auth.currentUser;
    if (user == null) {
      log("Error: Current user is null, cannot initialize userId");
      throw Exception('User not authenticated');
    }
    return user.uid;
  }

  @override
  Future<bool> addToFavorite({required String itemId}) async {
    if (userId.isEmpty) {
      throw Exception('User not authenticated');
    }
    try {
      final List<String> favorites = await getFavoriteItems();
      if (!favorites.contains(itemId)) {
        final updatedFavorites = [...favorites, itemId];
        _cachedFavorites = updatedFavorites;
        await firestore.collection('users').doc(userId).set({
          'favorite': updatedFavorites,
        }, SetOptions(merge: true));
      }
      return true;
    } catch (e) {
      log('Error adding to favorites: $e');
      throw Exception('Failed to add to favorites: $e');
    }
  }

  @override
  Future<List<String>> getFavoriteItems() async {
    if (userId.isEmpty) {
      throw Exception('User not authenticated');
    }
    try {
      final doc = await firestore.collection('users').doc(userId).get();

      if (!doc.exists) {
        log('User document does not exist, initializing empty favorites.');
        _cachedFavorites = <String>[];
        return _cachedFavorites!;
      }

      final data = doc.data();
      if (data == null || data['favorite'] == null) {
        _cachedFavorites = <String>[];
      } else if (data['favorite'] is List) {
        _cachedFavorites = List<String>.from(data['favorite']);
      } else {
        log('Warning: favorite field is not a list. Resetting to empty.');
        _cachedFavorites = <String>[];
      }

      return _cachedFavorites!;
    } catch (e) {
      log('Error fetching favorites in firebase: $e');
      throw Exception('حدث خطأ في تحميل المنتجات.');
    }
  }

  @override
  Future<bool> removeFromFavorite({required String itemId}) async {
    if (userId.isEmpty) {
      throw Exception('User not authenticated');
    }
    try {
      final List<String> favorites = await getFavoriteItems();
      if (favorites.contains(itemId)) {
        favorites.remove(itemId);
        _cachedFavorites = favorites;
        await firestore.collection('users').doc(userId).update({
          'favorite': favorites,
        });
      }
      return true;
    } catch (e) {
      log('Error removing from favorites: $e');
      throw Exception('Failed to remove from favorites: $e');
    }
  }

  @override
  Future<bool> isFavorite({required String itemId}) async {
    if (userId.isEmpty) {
      return false;
    }
    try {
      final response = await getFavoriteItems();
      return response.contains(itemId);
    } catch (e) {
      log("Error checking favorite status: $e");
      return false;
    }
  }

  void clearCache() {
    _cachedFavorites = null;
  }
}
