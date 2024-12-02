import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';
import 'surah_detail_screen.dart';

final surahsProvider = FutureProvider((ref) => ApiService().fetchSurahs());

class Quran extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahs = ref.watch(surahsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Al-Qur\'an',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: surahs.when(
        data: (data) => Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final surah = data[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Text(
                      surah['number'].toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    surah['englishName'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${surah['name']} • ${surah['revelationType']}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.teal),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SurahDetailScreen(surah['number']),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text(
            'Error: $err',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
