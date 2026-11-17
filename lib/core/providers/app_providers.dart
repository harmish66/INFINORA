import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../database/app_database.dart';
import '../../features/projects/data/project_repository.dart';
import '../../features/projects/domain/models/project_model.dart';
import '../../features/settings/data/settings_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized before app runs');
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsRepository(prefs);
});

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ProjectRepository(db);
});

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final repo = ref.watch(settingsRepositoryProvider);
    return repo.getThemeMode();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final repo = ref.read(settingsRepositoryProvider);
    await repo.setThemeMode(mode);
    state = mode;
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(() {
  return ThemeModeNotifier();
});

class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() {
    final repo = ref.watch(settingsRepositoryProvider);
    return repo.getLocale();
  }

  Future<void> setLocale(String languageCode) async {
    final repo = ref.read(settingsRepositoryProvider);
    await repo.setLocale(languageCode);
    state = Locale(languageCode);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(() {
  return LocaleNotifier();
});

class ProjectsListNotifier extends AsyncNotifier<List<ProjectModel>> {
  @override
  Future<List<ProjectModel>> build() async {
    final repo = ref.watch(projectRepositoryProvider);
    return repo.getAllProjects();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(projectRepositoryProvider);
      return repo.getAllProjects();
    });
  }

  Future<void> deleteProject(String id) async {
    final repo = ref.read(projectRepositoryProvider);
    await repo.deleteProject(id);
    await refresh();
  }

  Future<void> toggleFavorite(String id, bool isFavorite) async {
    final repo = ref.read(projectRepositoryProvider);
    await repo.toggleFavorite(id, isFavorite);
    await refresh();
  }

  Future<void> toggleArchive(String id, bool isArchived) async {
    final repo = ref.read(projectRepositoryProvider);
    await repo.toggleArchive(id, isArchived);
    await refresh();
  }

  Future<ProjectModel> duplicateProject(String id, String newName) async {
    final repo = ref.read(projectRepositoryProvider);
    final dup = await repo.duplicateProject(id, newName);
    await refresh();
    return dup;
  }
}

final projectsListProvider =
    AsyncNotifierProvider<ProjectsListNotifier, List<ProjectModel>>(() {
  return ProjectsListNotifier();
});

final favoriteProjectsProvider = FutureProvider<List<ProjectModel>>((ref) async {
  // Watch projects list so it updates automatically
  ref.watch(projectsListProvider);
  final repo = ref.watch(projectRepositoryProvider);
  return repo.getFavoriteProjects();
});

final archivedProjectsProvider = FutureProvider<List<ProjectModel>>((ref) async {
  ref.watch(projectsListProvider);
  final repo = ref.watch(projectRepositoryProvider);
  return repo.getArchivedProjects();
});
