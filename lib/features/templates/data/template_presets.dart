import 'package:flutter/material.dart';
import '../domain/models/template_model.dart';
import 'generators/art_generators.dart';
import 'generators/productivity_generators.dart';
import 'generators/zoom_generators.dart';

class TemplatePresets {
  static List<TemplateModel>? _cachedAll;

  static List<TemplateModel> get allTemplates {
    if (_cachedAll != null) return _cachedAll!;

    final list = <TemplateModel>[
      // 0. Blank Infinite Canvas Starter
      TemplateModel(
        id: 'blank_infinite',
        title: 'Infinite Canvas Starter',
        category: 'Infinite Zoom Art',
        description: 'A completely unbounded space with zero borders for freeform thinking, sketching, and infinite zoom creation.',
        icon: Icons.all_out_rounded,
        difficulty: 'Beginner',
        tags: const ['Canvas', 'Infinite', 'Blank', 'Sketch', 'Starter'],
        isFeatured: true,
        backgroundColor: const Color(0xFFFFFFFF),
        gridStyle: 'dots',
        suggestedUsage: 'Start from scratch without boundaries. Zoom out for the big picture or zoom in for microscopic detail.',
        buildObjects: (projectId, layerId) => [],
      ),
      ...ArtTemplateGenerators.getTemplates(),
      ...ZoomTemplateGenerators.getTemplates(),
      ...ProductivityTemplateGenerators.getTemplates(),
    ];

    _cachedAll = list;
    return list;
  }

  static List<TemplateModel> get featuredTemplates =>
      allTemplates.where((t) => t.isFeatured).toList();

  static List<TemplateModel> get trendingTemplates =>
      allTemplates.where((t) => t.isTrending || t.isFeatured).toList();

  static List<TemplateModel> get editorsPicks =>
      allTemplates.where((t) => t.isEditorsPick || t.isFeatured).toList();

  static TemplateModel? getById(String id) {
    try {
      return allTemplates.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<TemplateModel> getByCategory(String category) {
    if (category == 'All') return allTemplates;
    return allTemplates.where((t) => t.category == category).toList();
  }

  static List<String> get categories => const [
        'All',
        'Infinite Zoom Art',
        'Mandala Art',
        'Zentangle Art',
        'Doodle Art',
        'Abstract Art',
        'Digital Art',
        'Mind Maps',
        'Brainstorming',
        'Study Notes',
        'Vision Boards',
        'Daily Planning',
        'Business Planning',
        'Creative Sketches',
        'Nature & Landscape',
        'Typography Art',
        'Coloring Templates',
        'Social Media Art',
        'Educational Diagrams',
      ];
}
