import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/app_providers.dart';

class FavoriteTemplatesNotifier extends Notifier<Set<String>> {
  static const _key = 'favorite_template_ids';

  @override
  Set<String> build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final list = prefs.getStringList(_key) ?? [];
    return list.toSet();
  }

  Future<void> toggleFavorite(String templateId) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final current = Set<String>.from(state);
    if (current.contains(templateId)) {
      current.remove(templateId);
    } else {
      current.add(templateId);
    }
    await prefs.setStringList(_key, current.toList());
    state = current;
  }

  bool isFavorite(String templateId) => state.contains(templateId);
}

final favoriteTemplatesProvider =
    NotifierProvider<FavoriteTemplatesNotifier, Set<String>>(() {
  return FavoriteTemplatesNotifier();
});
