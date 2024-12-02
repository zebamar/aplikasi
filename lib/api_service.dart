import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class ApiService {
  final String baseUrl = "https://api.alquran.cloud/v1";

  Future<List<dynamic>> fetchSurahs() async {
    final response = await http.get(Uri.parse('$baseUrl/surah'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to load surahs');
    }
  }

  Future<Map<String, dynamic>> fetchSurahDetail(int surahNumber) async {
    final response = await http.get(Uri.parse('$baseUrl/surah/$surahNumber'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to load surah details');
    }
  }

  Future<List<dynamic>> fetchDailyPrayers() async {
    try {
      // Membaca file db.json dari direktori assets
      final String response = await rootBundle.loadString('assets/db.json');
      final Map<String, dynamic> data = jsonDecode(response);

      // Menangani nilai null di JSON
      return (data['data'] as List).map((prayer) {
        return {
          'title': prayer['title'] ?? 'Judul Tidak Tersedia',
          'text': prayer['text'] ?? 'Teks doa tidak tersedia',
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to load daily prayers: $e');
    }
  }
}
