import 'package:app1/bacaan/datail.dart';
import 'package:app1/pengaturan/setting.dart';
import 'package:flutter/material.dart';
import 'package:app1/services/firebase_service.dart';

class florafauna extends StatelessWidget {
  const florafauna({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTabIndex = 0;

  Future<List<Map<String, dynamic>>> _loadItems() async {
    final lang = AppScope.of(context).language;
    final isEn = lang == AppLanguage.english;

    if (_selectedTabIndex == 0) {
      return isEn
          ? await FirebaseService.getFloraArticlesEn()
          : await FirebaseService.getFloraArticles();
    } else {
      return isEn
          ? await FirebaseService.getFaunaArticlesEn()
          : await FirebaseService.getFaunaArticles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/kembali'),
                    child: const Icon(
                      Icons.home_filled,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Tab
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildTab('Flora', 0),
                            const SizedBox(width: 8),
                            _buildTab('Fauna', 1),
                          ],
                        ),
                      ),
                    ),
                    // Konten putih
                    Positioned.fill(
                      top: 28,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              Expanded(
                                child: FutureBuilder<List<Map<String, dynamic>>>(
                                  future: _loadItems(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    final items = snapshot.data!;

                                    return SingleChildScrollView(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 18,
                                              mainAxisSpacing: 18,
                                              childAspectRatio: 0.72,
                                            ),
                                        itemCount: items.length,
                                        itemBuilder: (context, index) {
                                          final item = items[index];

                                          return _CardItem(
                                            item: {
                                              'title':
                                                  item['title']?.toString() ??
                                                  '',
                                              'imagePath':
                                                  item['imagePath']
                                                      ?.toString() ??
                                                  '',
                                            },
                                            category: _selectedTabIndex == 0
                                                ? 'flora'
                                                : 'fauna',
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 154, 195, 111)
              : const Color.fromARGB(255, 177, 226, 155),
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// Card item
class _CardItem extends StatelessWidget {
  const _CardItem({required this.item, required this.category});

  final Map<String, String> item;
  final String category; // 'flora' atau 'fauna'

  @override
  Widget build(BuildContext context) {
    final String imagePath = item['imagePath'] ?? '';
    final String title = item['title'] ?? '';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Gambar
          Expanded(
            child: imagePath.isEmpty
                ? _PlaceholderImage(label: title)
                : Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
          ),
          const SizedBox(height: 6),
          // Nama
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3D5A3D),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          // Tombol BACA
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: double.infinity,
              height: 24,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 181, 219, 164),
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  padding: EdgeInsets.zero,
                  elevation: 0,
                ),
                onPressed: () => _openDetail(context, title, imagePath),
                child: Text(
                  L10n.read(context),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Future<void> _openDetail(
    BuildContext context,
    String title,
    String imagePath,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          const Center(child: CircularProgressIndicator(color: Colors.white)),
    );

    try {
      final lang = AppScope.of(context).language;
      final isEn = lang == AppLanguage.english;

      final articles = category == 'flora'
          ? (isEn
                ? await FirebaseService.getFloraArticlesEn()
                : await FirebaseService.getFloraArticles())
          : (isEn
                ? await FirebaseService.getFaunaArticlesEn()
                : await FirebaseService.getFaunaArticles());

      final article = articles.firstWhere(
        (a) => a['title'] == title,
        orElse: () => {},
      );

      if (context.mounted) Navigator.pop(context);

      if (article.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Artikel belum tersedia'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => materi1(
              title: article['title'] ?? title,
              subtitle: article['subtitle'] ?? '',
              description: article['description'] ?? '',
              imagePath: imagePath,
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context); // tutup loading
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal memuat artikel. Cek koneksi internet.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

// Placeholder
class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFE8E0DC),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.image_outlined, size: 36, color: Color(0xFFB0A0A0)),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFFB0A0A0),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
