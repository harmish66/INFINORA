import 'package:flutter/material.dart';

class AppColors {
  // Light Mode Colors - Studio Archival & Clean Slate
  static const Color primaryBackground = Color(0xFFF9FAFB);
  static const Color secondaryBackground = Color(0xFFF3F4F6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color primaryBrand = Color(0xFF2563EB); // Studio Cobalt Blue
  static const Color secondaryBrand = Color(0xFF1D4ED8); // Deep Cobalt
  static const Color accent = Color(0xFF0D9488); // Technical Teal
  static const Color primaryText = Color(0xFF0F172A); // Obsidian Ink
  static const Color secondaryText = Color(0xFF64748B); // Slate Grey
  static const Color border = Color(0xFFE2E8F0);
  static const Color success = Color(0xFF059669); // Forest Emerald
  static const Color warning = Color(0xFFD97706); // Warm Amber
  static const Color error = Color(0xFFDC2626); // Crimson Red

  // Dark Mode Colors - Studio Charcoal & Obsidian
  static const Color darkBackground = Color(0xFF0F1115);
  static const Color darkSecondaryBackground = Color(0xFF161920);
  static const Color darkSurface = Color(0xFF1C2027);
  static const Color darkPrimaryText = Color(0xFFF8FAFC);
  static const Color darkSecondaryText = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF2A303C);

  // Palette presets for drawing
  static const List<Color> drawingPalette = [
    Color(0xFF0F172A), // Obsidian Black
    Color(0xFF2563EB), // Cobalt Blue
    Color(0xFF0D9488), // Technical Teal
    Color(0xFF059669), // Forest Green
    Color(0xFFD97706), // Amber Ochre
    Color(0xFFDC2626), // Crimson Red
    Color(0xFF7C3AED), // Indigo
    Color(0xFF0284C7), // Sky Blue
    Color(0xFFEA580C), // Burnt Orange
    Color(0xFF64748B), // Slate Grey
    Color(0xFFFFFFFF), // Pure White
    Color(0xFF000000), // Pure Black
  ];

  // Canvas background presets
  static const List<Color> canvasBackgrounds = [
    Color(0xFFFFFFFF), // Crisp White
    Color(0xFFF9FAFB), // Off-White Studio
    Color(0xFFF3F4F6), // Warm Grey Paper
    Color(0xFFFFFBEB), // Archival Cream
    Color(0xFF1E2430), // Technical Slate
    Color(0xFF0F1115), // Deep Charcoal
  ];
}
