import 'package:flutter/material.dart';
import '../../../canvas/domain/models/canvas_object.dart';
import '../../domain/models/template_model.dart';
import 'vector_template_helpers.dart';

class ZoomTemplateGenerators {
  static List<TemplateModel> getTemplates() {
    return [
      // 1. Picture Inside Picture
      TemplateModel(
        id: 'zoom_picture_in_picture',
        title: 'Picture Inside Picture',
        category: 'Infinite Zoom Art',
        description: 'An art gallery frame holding a landscape painting, inside which a cottage window holds another world.',
        icon: Icons.zoom_in_map_rounded,
        difficulty: 'Advanced',
        tags: const ['Infinite Zoom', 'Nested', 'Gallery', 'Landscape', 'Deep'],
        isFeatured: true,
        isTrending: true,
        isEditorsPick: true,
        initialZoom: 1.0,
        suggestedUsage: 'Pinch to zoom into the framed painting center (10x), then zoom into the cottage window (100x).',
        backgroundColor: const Color(0xFFF8FAFC),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // --- LEVEL 0: Gallery Wall & Grand Frame (Normal Scale: Zoom 1.0) ---
          objs.add(VectorArtHelper.rect(
            id: '$projectId-l0-wall',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-360, -240, 720, 480),
            strokeColor: const Color(0xFF1E293B),
            fillColor: const Color(0xFFF1F5F9),
            strokeWidth: 4.0,
            isFilled: true,
          ));

          objs.add(VectorArtHelper.text(
            id: '$projectId-l0-sign',
            layerId: layerId,
            order: order++,
            text: 'LEVEL 1: THE GALLERY (ZOOM IN TO EXPLORE)',
            position: const Offset(-200, -210),
            fontSize: 14,
            color: const Color(0xFF64748B),
            isBold: true,
          ));

          // Ornate Frame Border
          objs.add(VectorArtHelper.rect(
            id: '$projectId-l0-frame',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-200, -120, 400, 260),
            strokeColor: const Color(0xFF92400E),
            fillColor: const Color(0xFFFFFBEB),
            strokeWidth: 8.0,
            isFilled: true,
          ));

          // --- LEVEL 1: Mountain Cottage Landscape (Centered at (0, 10), Zoom 10x) ---
          // Mountain backdrop
          objs.add(VectorArtHelper.polygon(
            id: '$projectId-l1-mt',
            layerId: layerId,
            order: order++,
            center: const Offset(0, -20),
            radius: 80,
            sides: 3,
            strokeColor: const Color(0xFF0F172A),
            fillColor: const Color(0xFFE2E8F0),
            strokeWidth: 2.0,
            isFilled: true,
          ));

          // Cottage House
          objs.add(VectorArtHelper.rect(
            id: '$projectId-l1-house',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-30, 20, 60, 50),
            strokeColor: const Color(0xFFB45309),
            fillColor: const Color(0xFFFEF3C7),
            strokeWidth: 2.0,
            isFilled: true,
          ));

          // Cottage Roof
          objs.add(VectorArtHelper.polygon(
            id: '$projectId-l1-roof',
            layerId: layerId,
            order: order++,
            center: const Offset(0, 15),
            radius: 35,
            sides: 3,
            strokeColor: const Color(0xFF78350F),
            fillColor: const Color(0xFFFDE68A),
            strokeWidth: 2.0,
            isFilled: true,
          ));

          // Cottage Window (Target for Level 2)
          objs.add(VectorArtHelper.rect(
            id: '$projectId-l1-window',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-6, 38, 12, 14),
            strokeColor: const Color(0xFF0284C7),
            fillColor: const Color(0xFF38BDF8),
            strokeWidth: 1.0,
            isFilled: true,
          ));

          // --- LEVEL 2: Window Microcosm (Centered at (0, 45), scale 0.05, Zoom 100x) ---
          objs.add(VectorArtHelper.circle(
            id: '$projectId-l2-micro-sun',
            layerId: layerId,
            order: order++,
            center: const Offset(0, 45),
            radius: 2.5,
            strokeColor: const Color(0xFFE11D48),
            fillColor: const Color(0xFFFEE2E2),
            strokeWidth: 0.3,
            isFilled: true,
          ));

          objs.add(VectorArtHelper.text(
            id: '$projectId-l2-micro-text',
            layerId: layerId,
            order: order++,
            text: 'SECRET PARADISE FOUND',
            position: const Offset(-8, 48),
            fontSize: 0.9,
            color: const Color(0xFF0F172A),
            isBold: true,
          ));

          return objs;
        },
      ),

      // 2. Ocean in a Single Drop
      TemplateModel(
        id: 'zoom_ocean_drop',
        title: 'Ocean in a Single Drop',
        category: 'Infinite Zoom Art',
        description: 'A glass of pure water holding a single hanging droplet with an entire underwater coral reef.',
        icon: Icons.water_drop_rounded,
        difficulty: 'Advanced',
        tags: const ['Infinite Zoom', 'Water', 'Coral', 'Microcosm', 'Sea'],
        isFeatured: true,
        suggestedUsage: 'Zoom into the center water droplet to uncover manta rays, sea kelp, and micro plankton.',
        backgroundColor: const Color(0xFFF0FDF4),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Level 0: Water Glass Outline
          objs.add(VectorArtHelper.rect(
            id: '$projectId-glass',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-160, -180, 320, 360),
            strokeColor: const Color(0xFF0284C7),
            fillColor: const Color(0xFFE0F2FE).withValues(alpha: 0.3),
            strokeWidth: 3.5,
            isFilled: true,
          ));

          objs.add(VectorArtHelper.text(
            id: '$projectId-glass-txt',
            layerId: layerId,
            order: order++,
            text: 'SURFACE DROPLET (ZOOM INTO CENTER)',
            position: const Offset(-140, -210),
            fontSize: 13,
            color: const Color(0xFF0369A1),
            isBold: true,
          ));

          // Level 1: The Hanging Droplet
          objs.add(VectorArtHelper.circle(
            id: '$projectId-drop-core',
            layerId: layerId,
            order: order++,
            center: const Offset(0, 0),
            radius: 80,
            strokeColor: const Color(0xFF0369A1),
            fillColor: const Color(0xFFBAE6FD),
            strokeWidth: 3.0,
            isFilled: true,
          ));

          // Droplet Coral Reef
          for (int c = -2; c <= 2; c++) {
            objs.add(VectorArtHelper.line(
              id: '$projectId-coral-$c',
              layerId: layerId,
              order: order++,
              start: Offset(c * 25.0, 50),
              end: Offset(c * 20.0, 10),
              color: const Color(0xFF059669),
              strokeWidth: 4.0,
            ));
          }

          // Level 2: Microscopic Plankton (at 0, 0)
          objs.add(VectorArtHelper.star(
            id: '$projectId-plankton',
            layerId: layerId,
            order: order++,
            center: const Offset(0, -15),
            radius: 4.0,
            strokeColor: const Color(0xFFD97706),
            fillColor: const Color(0xFFFEF3C7),
            strokeWidth: 0.5,
            isFilled: true,
          ));

          objs.add(VectorArtHelper.text(
            id: '$projectId-plankton-lbl',
            layerId: layerId,
            order: order++,
            text: 'MICRO CELL 100X',
            position: const Offset(-4, -8),
            fontSize: 1.0,
            color: const Color(0xFF0F172A),
            isBold: true,
          ));

          return objs;
        },
      ),

      // 3. Nested Nature Worlds
      TemplateModel(
        id: 'zoom_nested_tree_worlds',
        title: 'Nested Nature Worlds',
        category: 'Infinite Zoom Art',
        description: 'An ancient grandfather oak tree whose emerald leaf contains cell chloroplast ecosystems.',
        icon: Icons.forest_rounded,
        difficulty: 'Intermediate',
        tags: const ['Infinite Zoom', 'Tree', 'Biology', 'Leaf', 'Ecology'],
        suggestedUsage: 'Pinch into the right foliage cluster, locate the golden leaf, and zoom 50x inside.',
        backgroundColor: const Color(0xFFF7FEE7),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Trunk
          objs.add(VectorArtHelper.rect(
            id: '$projectId-trunk',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-40, 20, 80, 180),
            strokeColor: const Color(0xFF78350F),
            fillColor: const Color(0xFF92400E),
            strokeWidth: 3.0,
            isFilled: true,
          ));

          // Canopy
          objs.add(VectorArtHelper.circle(
            id: '$projectId-canopy',
            layerId: layerId,
            order: order++,
            center: const Offset(0, -70),
            radius: 160,
            strokeColor: const Color(0xFF15803D),
            fillColor: const Color(0xFFBBF7D0),
            strokeWidth: 3.5,
            isFilled: true,
          ));

          // Target Golden Leaf (Level 1)
          objs.add(VectorArtHelper.circle(
            id: '$projectId-gold-leaf',
            layerId: layerId,
            order: order++,
            center: const Offset(60, -80),
            radius: 20,
            strokeColor: const Color(0xFFB45309),
            fillColor: const Color(0xFFFDE68A),
            strokeWidth: 1.8,
            isFilled: true,
          ));

          // Micro Leaf Vein Core (Level 2)
          objs.add(VectorArtHelper.line(
            id: '$projectId-vein-mid',
            layerId: layerId,
            order: order++,
            start: const Offset(50, -80),
            end: const Offset(70, -80),
            color: const Color(0xFF047857),
            strokeWidth: 0.5,
          ));

          objs.add(VectorArtHelper.circle(
            id: '$projectId-chloroplast',
            layerId: layerId,
            order: order++,
            center: const Offset(60, -80),
            radius: 1.8,
            strokeColor: const Color(0xFF15803D),
            fillColor: const Color(0xFF86EFAC),
            strokeWidth: 0.2,
            isFilled: true,
          ));

          return objs;
        },
      ),

      // 4. Galaxy inside Coffee Cup
      TemplateModel(
        id: 'zoom_galaxy_coffee',
        title: 'Cosmic Coffee Galaxy',
        category: 'Infinite Zoom Art',
        description: 'Morning ceramic coffee mug filled with espresso crema swirling into a spiral galaxy.',
        icon: Icons.coffee_rounded,
        difficulty: 'Advanced',
        tags: const ['Infinite Zoom', 'Coffee', 'Galaxy', 'Astronomy', 'Spiral'],
        isPremium: true,
        suggestedUsage: 'Zoom into the center of the milk swirl to discover orbiting planets and space stations.',
        backgroundColor: const Color(0xFFFFFBEB),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Mug Rim
          objs.add(VectorArtHelper.circle(
            id: '$projectId-mug-rim',
            layerId: layerId,
            order: order++,
            center: Offset.zero,
            radius: 190,
            strokeColor: const Color(0xFF78350F),
            fillColor: const Color(0xFF1E293B),
            strokeWidth: 5.0,
            isFilled: true,
          ));

          // Espresso Crema Spiral (Level 1)
          final spiralPts = <Offset>[];
          for (double t = 0; t < 6 * 3.14159; t += 0.2) {
            final r = 9 * t;
            spiralPts.add(Offset(r * -0.8 * (t % 2 == 0 ? 1 : 0.9), r * 0.7));
          }
          objs.add(VectorArtHelper.stroke(
            id: '$projectId-crema-spiral',
            layerId: layerId,
            order: order++,
            points: spiralPts,
            color: const Color(0xFFFDE68A),
            strokeWidth: 3.5,
          ));

          // Center Sun Star System (Level 2)
          objs.add(VectorArtHelper.star(
            id: '$projectId-cosmic-star',
            layerId: layerId,
            order: order++,
            center: const Offset(0, 0),
            radius: 3.0,
            strokeColor: const Color(0xFFE11D48),
            fillColor: Colors.white,
            strokeWidth: 0.3,
            isFilled: true,
          ));

          // Orbiting micro planet
          objs.add(VectorArtHelper.circle(
            id: '$projectId-micro-planet',
            layerId: layerId,
            order: order++,
            center: const Offset(5.0, 2.0),
            radius: 0.8,
            strokeColor: const Color(0xFF38BDF8),
            fillColor: const Color(0xFF0284C7),
            strokeWidth: 0.2,
            isFilled: true,
          ));

          return objs;
        },
      ),

      // 5. Flower in Infinite Garden
      TemplateModel(
        id: 'zoom_infinite_garden_flower',
        title: 'Blossom Micro-Pavilion',
        category: 'Infinite Zoom Art',
        description: 'A botanical flower garden overview leading to a single blossom stamen hiding a miniature pavilion.',
        icon: Icons.local_florist_rounded,
        difficulty: 'Intermediate',
        tags: const ['Infinite Zoom', 'Garden', 'Floral', 'Architecture', 'Wonder'],
        suggestedUsage: 'Zoom into the center blossom stamen at 40x to reveal the miniature garden pavilion.',
        backgroundColor: const Color(0xFFF0FDF4),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Garden Bed
          objs.add(VectorArtHelper.rect(
            id: '$projectId-bed',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-280, -180, 560, 360),
            strokeColor: const Color(0xFF15803D),
            fillColor: const Color(0xFFDCFCE7),
            strokeWidth: 3.0,
            isFilled: true,
          ));

          // Central Giant Blossom
          for (int p = 0; p < 8; p++) {
            final a = p * (6.28318 / 8);
            final pts = VectorArtHelper.generatePetalPoints(
              center: Offset.zero,
              angle: a,
              length: 120,
              width: 32,
            );
            objs.add(VectorArtHelper.stroke(
              id: '$projectId-petal-$p',
              layerId: layerId,
              order: order++,
              points: pts,
              color: const Color(0xFFE11D48),
              strokeWidth: 2.0,
            ));
          }

          // Golden Pistil Core (Level 1)
          objs.add(VectorArtHelper.circle(
            id: '$projectId-pistil-core',
            layerId: layerId,
            order: order++,
            center: Offset.zero,
            radius: 28,
            strokeColor: const Color(0xFFD97706),
            fillColor: const Color(0xFFFEF3C7),
            strokeWidth: 2.0,
            isFilled: true,
          ));

          // Micro Pavilion (Level 2)
          objs.add(VectorArtHelper.polygon(
            id: '$projectId-pavilion-roof',
            layerId: layerId,
            order: order++,
            center: const Offset(0, -1.0),
            radius: 2.5,
            sides: 6,
            strokeColor: const Color(0xFF78350F),
            fillColor: const Color(0xFFFDE68A),
            strokeWidth: 0.3,
            isFilled: true,
          ));

          return objs;
        },
      ),

      // 6. Clockwork Continuum
      TemplateModel(
        id: 'zoom_clockwork_chronometer',
        title: 'Clockwork Continuum',
        category: 'Infinite Zoom Art',
        description: 'Precision mechanical pocket chronometer with nested gear trains and escapement jewel balance.',
        icon: Icons.watch_later_rounded,
        difficulty: 'Advanced',
        tags: const ['Infinite Zoom', 'Clockwork', 'Gears', 'Mechanical', 'Steampunk'],
        isPremium: true,
        suggestedUsage: 'Pinch into the escapement gear hub at 60x magnification to examine the ruby jewel pin.',
        backgroundColor: const Color(0xFF0F172A),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Pocket Watch Outer Case
          objs.add(VectorArtHelper.circle(
            id: '$projectId-case',
            layerId: layerId,
            order: order++,
            center: Offset.zero,
            radius: 210,
            strokeColor: const Color(0xFFD97706),
            strokeWidth: 4.0,
          ));

          // Dial Numbers Ring
          objs.add(VectorArtHelper.circle(
            id: '$projectId-dial',
            layerId: layerId,
            order: order++,
            center: Offset.zero,
            radius: 170,
            strokeColor: const Color(0xFF38BDF8).withValues(alpha: 0.5),
            strokeWidth: 1.5,
          ));

          // Primary Gear Train (Level 1)
          objs.add(VectorArtHelper.polygon(
            id: '$projectId-gear-main',
            layerId: layerId,
            order: order++,
            center: const Offset(40, 30),
            radius: 70,
            sides: 12,
            strokeColor: const Color(0xFFF59E0B),
            strokeWidth: 2.2,
          ));

          // Escapement Hub & Jewel Pin (Level 2)
          objs.add(VectorArtHelper.circle(
            id: '$projectId-escapement-hub',
            layerId: layerId,
            order: order++,
            center: const Offset(40, 30),
            radius: 3.5,
            strokeColor: const Color(0xFFE11D48),
            fillColor: const Color(0xFFFECDD3),
            strokeWidth: 0.4,
            isFilled: true,
          ));

          return objs;
        },
      ),

      // 7. Endless Eye of Insight
      TemplateModel(
        id: 'zoom_endless_eye',
        title: 'Endless Eye of Insight',
        category: 'Infinite Zoom Art',
        description: 'Intense portrait eye whose iris patterns open into a futuristic holographic skyline reflection.',
        icon: Icons.remove_red_eye_rounded,
        difficulty: 'Intermediate',
        tags: const ['Infinite Zoom', 'Eye', 'Portrait', 'Iris', 'Cyberpunk'],
        suggestedUsage: 'Pinch into the pupil core to uncover a hidden digital metropolis map.',
        backgroundColor: const Color(0xFF0F172A),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Eye Outline
          objs.add(VectorArtHelper.stroke(
            id: '$projectId-eye-top',
            layerId: layerId,
            order: order++,
            points: [
              const Offset(-220, 0),
              const Offset(-110, -90),
              const Offset(0, -110),
              const Offset(110, -90),
              const Offset(220, 0),
            ],
            color: Colors.white,
            strokeWidth: 3.5,
          ));

          objs.add(VectorArtHelper.stroke(
            id: '$projectId-eye-btm',
            layerId: layerId,
            order: order++,
            points: [
              const Offset(-220, 0),
              const Offset(-110, 80),
              const Offset(0, 95),
              const Offset(110, 80),
              const Offset(220, 0),
            ],
            color: Colors.white,
            strokeWidth: 3.5,
          ));

          // Iris (Level 1)
          objs.add(VectorArtHelper.circle(
            id: '$projectId-iris',
            layerId: layerId,
            order: order++,
            center: Offset.zero,
            radius: 75,
            strokeColor: const Color(0xFF0284C7),
            fillColor: const Color(0xFF0369A1),
            strokeWidth: 2.5,
            isFilled: true,
          ));

          // Pupil (Level 2)
          objs.add(VectorArtHelper.circle(
            id: '$projectId-pupil',
            layerId: layerId,
            order: order++,
            center: Offset.zero,
            radius: 28,
            strokeColor: Colors.black,
            fillColor: Colors.black,
            strokeWidth: 1.0,
            isFilled: true,
          ));

          // City Grid Inside Pupil (Level 3 - Scale 0.05)
          objs.add(VectorArtHelper.rect(
            id: '$projectId-micro-tower',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-1.5, -4.0, 3.0, 8.0),
            strokeColor: const Color(0xFF38BDF8),
            fillColor: const Color(0xFFE0F2FE),
            strokeWidth: 0.2,
            isFilled: true,
          ));

          return objs;
        },
      ),

      // 8. Infinite Citadel Blueprint
      TemplateModel(
        id: 'zoom_infinite_citadel',
        title: 'Citadel Blueprint Archive',
        category: 'Infinite Zoom Art',
        description: 'An architectural castle fortress master plan holding an inner library blueprint at 80x zoom.',
        icon: Icons.account_balance_rounded,
        difficulty: 'Advanced',
        tags: const ['Infinite Zoom', 'Citadel', 'Blueprint', 'Architecture', 'Castle'],
        suggestedUsage: 'Navigate from the outer castle perimeter wall into the throne hall study archive.',
        backgroundColor: const Color(0xFF0B192C),
        gridStyle: 'lines',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Outer Wall Blueprint
          objs.add(VectorArtHelper.rect(
            id: '$projectId-castle-outer',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-280, -180, 560, 360),
            strokeColor: const Color(0xFF38BDF8),
            strokeWidth: 3.0,
          ));

          // 4 Corner Bastions
          for (final bx in [-280.0, 240.0]) {
            for (final by in [-180.0, 140.0]) {
              objs.add(VectorArtHelper.rect(
                id: '$projectId-bastion-$bx-$by',
                layerId: layerId,
                order: order++,
                rect: Rect.fromLTWH(bx, by, 40, 40),
                strokeColor: const Color(0xFF38BDF8),
                fillColor: const Color(0xFF1E3A8A),
                strokeWidth: 2.0,
                isFilled: true,
              ));
            }
          }

          // Inner Library Chamber (Level 1)
          objs.add(VectorArtHelper.rect(
            id: '$projectId-chamber',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-50, -40, 100, 80),
            strokeColor: const Color(0xFFFDE047),
            strokeWidth: 2.0,
          ));

          // Ancient Desk (Level 2)
          objs.add(VectorArtHelper.rect(
            id: '$projectId-micro-desk',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-3.0, -2.0, 6.0, 4.0),
            strokeColor: const Color(0xFFFDE047),
            fillColor: const Color(0xFFB45309),
            strokeWidth: 0.3,
            isFilled: true,
          ));

          return objs;
        },
      ),
    ];
  }
}
