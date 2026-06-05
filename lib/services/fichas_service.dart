import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FichasService extends ChangeNotifier {
  static final instance = FichasService._();
  FichasService._() {
    _load();
  }

  static const _key = 'fichas_criadas';
  List<Map<String, dynamic>> _fichas = [];
  List<Map<String, dynamic>> get fichas => List.unmodifiable(_fichas);

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null) {
      _fichas = List<Map<String, dynamic>>.from(jsonDecode(raw) as List);
      notifyListeners();
    }
  }

  Future<void> addFicha(Map<String, dynamic> ficha) async {
    _fichas.insert(0, ficha);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(_fichas));
  }
}
