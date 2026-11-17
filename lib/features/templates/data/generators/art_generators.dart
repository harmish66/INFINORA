import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../canvas/domain/models/canvas_object.dart';
import '../../domain/models/template_model.dart';
import 'vector_template_helpers.dart';

class ArtTemplateGenerators {
  static List<TemplateModel> getTemplates() {
    return [
      // ---------------- MANDALA ART ----------------
      TemplateModel(
        id: 'mandala_sacred_lotus',
        title: 'Sacred Lotus Mandala',
        category: 'Mandala Art',
        description: 'Harmonious 12-fold sacred mandala featuring concentric lotus petals, geometric rings, and central core.',
        icon: Icons.filter_vintage_rounded,
        difficulty: 'Intermediate',
        tags: const ['Mandala', 'Sacred', 'Lotus', 'Radial', 'Spiritual'],
        isFeatured: true,
        isTrending: true,
        suggestedUsage: 'Color the radial petals with shading pens or expand the outer rings with zentangle motifs.',
        backgroundColor: const Color(0xFFFBFBFB),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;
          const center = Offset(0, 0);

          // Concentric outer guide rings
          for (final r in [280.0, 220.0, 160.0, 100.0, 40.0]) {
            objs.add(VectorArtHelper.circle(
              id: '$projectId-r-$r',
              layerId: layerId,
              order: order++,
              center: center,
              radius: r,
              strokeColor: const Color(0xFF0F172A).withValues(alpha: 0.25),
              strokeWidth: 1.5,
            ));
          }

          // 12 Outer Petals
          for (int i = 0; i < 12; i++) {
            final angle = i * (2 * math.pi / 12);
            final pts = VectorArtHelper.generatePetalPoints(
              center: center,
              angle: angle,
              length: 270,
              width: 38,
            );
            objs.add(VectorArtHelper.stroke(
              id: '$projectId-op-$i',
              layerId: layerId,
              order: order++,
              points: pts,
              color: const Color(0xFF0284C7),
              strokeWidth: 2.0,
            ));
          }

          // 12 Inner Petals offset by half phase
          for (int i = 0; i < 12; i++) {
            final angle = (i + 0.5) * (2 * math.pi / 12);
            final pts = VectorArtHelper.generatePetalPoints(
              center: center,
              angle: angle,
              length: 155,
              width: 24,
            );
            objs.add(VectorArtHelper.stroke(
              id: '$projectId-ip-$i',
              layerId: layerId,
              order: order++,
              points: pts,
              color: const Color(0xFFD97706),
              strokeWidth: 2.0,
            ));
          }

          // Central Star Seed
          objs.add(VectorArtHelper.star(
            id: '$projectId-star',
            layerId: layerId,
            order: order++,
            center: center,
            radius: 35,
            strokeColor: const Color(0xFFE11D48),
            fillColor: const Color(0xFFFFFBEB),
            strokeWidth: 2.0,
            isFilled: true,
          ));

          return objs;
        },
      ),

      TemplateModel(
        id: 'mandala_geometric_sun',
        title: 'Solar Radiance Mandala',
        category: 'Mandala Art',
        description: 'Vibrant sunburst mandala with interlaced 16-point geometric rays and solar ring details.',
        icon: Icons.wb_sunny_rounded,
        difficulty: 'Beginner',
        tags: const ['Mandala', 'Sun', 'Geometric', 'Rays', 'Gold'],
        isEditorsPick: true,
        suggestedUsage: 'Add warm gradient shading and decorative stippling across each ray corridor.',
        backgroundColor: const Color(0xFFFFFDF5),
        gridStyle: 'dots',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;
          const center = Offset(0, 0);

          // Center Sun Core
          objs.add(VectorArtHelper.circle(
            id: '$projectId-sun-core',
            layerId: layerId,
            order: order++,
            center: center,
            radius: 80,
            strokeColor: const Color(0xFFD97706),
            fillColor: const Color(0xFFFEF3C7),
            strokeWidth: 3.0,
            isFilled: true,
          ));

          // 16 Rays
          for (int i = 0; i < 16; i++) {
            final a = i * (2 * math.pi / 16);
            final p1 = Offset(center.dx + 90 * math.cos(a), center.dy + 90 * math.sin(a));
            final p2 = Offset(center.dx + 260 * math.cos(a), center.dy + 260 * math.sin(a));
            objs.add(VectorArtHelper.line(
              id: '$projectId-ray-$i',
              layerId: layerId,
              order: order++,
              start: p1,
              end: p2,
              color: const Color(0xFFB45309),
              strokeWidth: 2.2,
            ));

            final tip = Offset(center.dx + 280 * math.cos(a), center.dy + 280 * math.sin(a));
            objs.add(VectorArtHelper.circle(
              id: '$projectId-orb-$i',
              layerId: layerId,
              order: order++,
              center: tip,
              radius: 6,
              strokeColor: const Color(0xFFD97706),
              fillColor: const Color(0xFFFDE68A),
              strokeWidth: 1.5,
              isFilled: true,
            ));
          }

          return objs;
        },
      ),

      TemplateModel(
        id: 'mandala_cosmic_chakra',
        title: 'Cosmic Chakra Matrix',
        category: 'Mandala Art',
        description: 'Multi-tiered meditation mandala structured along seven harmonious energy rings.',
        icon: Icons.lens_blur_rounded,
        difficulty: 'Advanced',
        tags: const ['Mandala', 'Chakra', 'Meditation', 'Detailed', 'Sacred'],
        isPremium: true,
        suggestedUsage: 'Practice slow, focused ink work or fine brush hatching inside each quadrant.',
        backgroundColor: const Color(0xFF0F172A),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;
          const center = Offset(0, 0);

          for (int ring = 1; ring <= 6; ring++) {
            final r = ring * 45.0;
            objs.add(VectorArtHelper.circle(
              id: '$projectId-ch-$ring',
              layerId: layerId,
              order: order++,
              center: center,
              radius: r,
              strokeColor: const Color(0xFF38BDF8).withValues(alpha: 0.4 + ring * 0.1),
              strokeWidth: 1.8,
            ));
          }

          // 8 Octagonal Symmetry Lines
          for (int i = 0; i < 8; i++) {
            final a = i * (math.pi / 4);
            objs.add(VectorArtHelper.line(
              id: '$projectId-ax-$i',
              layerId: layerId,
              order: order++,
              start: Offset(-280 * math.cos(a), -280 * math.sin(a)),
              end: Offset(280 * math.cos(a), 280 * math.sin(a)),
              color: const Color(0xFF94A3B8).withValues(alpha: 0.3),
              strokeWidth: 1.2,
            ));
          }

          return objs;
        },
      ),

      TemplateModel(
        id: 'mandala_islamic_star',
        title: 'Eightfold Geometric Rosette',
        category: 'Mandala Art',
        description: 'Traditional Islamic geometry pattern with interlacing octagonal stars and lattice bands.',
        icon: Icons.ac_unit_rounded,
        difficulty: 'Intermediate',
        tags: const ['Mandala', 'Geometry', 'Lattice', 'Star', 'Pattern'],
        backgroundColor: const Color(0xFFFAFAFA),
        gridStyle: 'dots',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;
          const center = Offset(0, 0);

          for (int rot = 0; rot < 4; rot++) {
            objs.add(VectorArtHelper.polygon(
              id: '$projectId-sq-$rot',
              layerId: layerId,
              order: order++,
              center: center,
              radius: 200,
              sides: 4,
              strokeColor: const Color(0xFF0284C7),
              strokeWidth: 2.2,
              rotation: rot * (math.pi / 8),
            ));
          }

          objs.add(VectorArtHelper.circle(
            id: '$projectId-inner',
            layerId: layerId,
            order: order++,
            center: center,
            radius: 80,
            strokeColor: const Color(0xFF059669),
            strokeWidth: 2.0,
          ));

          return objs;
        },
      ),

      TemplateModel(
        id: 'mandala_flow_leaf',
        title: 'Organic Botanical Rosette',
        category: 'Mandala Art',
        description: 'Gentle curved leaves arranged in sweeping spiral waves for botanical illustration.',
        icon: Icons.eco_rounded,
        difficulty: 'Beginner',
        tags: const ['Mandala', 'Leaves', 'Nature', 'Floral', 'Green'],
        backgroundColor: const Color(0xFFF7FEE7),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;
          const center = Offset(0, 0);

          for (int i = 0; i < 8; i++) {
            final a = i * (2 * math.pi / 8);
            final pts = VectorArtHelper.generatePetalPoints(
              center: center,
              angle: a,
              length: 220,
              width: 45,
            );
            objs.add(VectorArtHelper.stroke(
              id: '$projectId-leaf-$i',
              layerId: layerId,
              order: order++,
              points: pts,
              color: const Color(0xFF15803D),
              strokeWidth: 2.5,
            ));
          }
          return objs;
        },
      ),

      // ---------------- ZENTANGLE ART ----------------
      TemplateModel(
        id: 'zentangle_isometric_tangle',
        title: 'Isometric Tangle Maze',
        category: 'Zentangle Art',
        description: 'Intricate geometric 3D isometric cubes and intersecting ribbons ready for dense pattern fills.',
        icon: Icons.grain_rounded,
        difficulty: 'Advanced',
        tags: const ['Zentangle', 'Isometric', 'Ink', 'Texture', 'Doodle'],
        isFeatured: true,
        suggestedUsage: 'Fill each facet with distinct repetitive patterns like stippling, crosshatch, and spirals.',
        backgroundColor: const Color(0xFFFFFFFF),
        gridStyle: 'lines',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // 4x4 Grid of decorative isometric blocks
          for (int row = -2; row <= 1; row++) {
            for (int col = -2; col <= 1; col++) {
              final ox = col * 120.0 + 60.0;
              final oy = row * 120.0 + 60.0;
              objs.add(VectorArtHelper.rect(
                id: '$projectId-tile-$row-$col',
                layerId: layerId,
                order: order++,
                rect: Rect.fromLTWH(ox - 50, oy - 50, 100, 100),
                strokeColor: const Color(0xFF1E293B),
                strokeWidth: 2.0,
              ));

              // Diagonal cross strings
              objs.add(VectorArtHelper.line(
                id: '$projectId-diag-$row-$col',
                layerId: layerId,
                order: order++,
                start: Offset(ox - 50, oy - 50),
                end: Offset(ox + 50, oy + 50),
                color: const Color(0xFF64748B),
                strokeWidth: 1.2,
              ));
            }
          }
          return objs;
        },
      ),

      TemplateModel(
        id: 'zentangle_organic_waves',
        title: 'Flowing Ribbon Waves',
        category: 'Zentangle Art',
        description: 'Graceful undulating curved ribbons that weave over and under across the canvas.',
        icon: Icons.waves_rounded,
        difficulty: 'Intermediate',
        tags: const ['Zentangle', 'Ribbon', 'Waves', 'Organic', 'Flow'],
        backgroundColor: const Color(0xFFF8FAFC),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          for (int i = 0; i < 5; i++) {
            final yOffset = -200.0 + i * 100.0;
            final pts = <Offset>[];
            for (double x = -350; x <= 350; x += 25) {
              final y = yOffset + math.sin(x / 60 + i) * 35;
              pts.add(Offset(x, y));
            }
            objs.add(VectorArtHelper.stroke(
              id: '$projectId-wave-$i',
              layerId: layerId,
              order: order++,
              points: pts,
              color: const Color(0xFF0F172A),
              strokeWidth: 2.5,
            ));
          }
          return objs;
        },
      ),

      TemplateModel(
        id: 'zentangle_optical_spiral',
        title: 'Hypnotic Spiral Web',
        category: 'Zentangle Art',
        description: 'Logarithmic Archimedean spiral partitioned into curving segments for optical art effects.',
        icon: Icons.all_inclusive_rounded,
        difficulty: 'Advanced',
        tags: const ['Zentangle', 'Spiral', 'Optical', 'Web', 'Contrast'],
        isPremium: true,
        backgroundColor: const Color(0xFFFFFFFF),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;
          final pts = <Offset>[];

          for (double theta = 0; theta < 8 * math.pi; theta += 0.15) {
            final r = 12 * theta;
            pts.add(Offset(r * math.cos(theta), r * math.sin(theta)));
          }

          objs.add(VectorArtHelper.stroke(
            id: '$projectId-spiral',
            layerId: layerId,
            order: order++,
            points: pts,
            color: const Color(0xFF0F172A),
            strokeWidth: 2.2,
          ));
          return objs;
        },
      ),

      TemplateModel(
        id: 'zentangle_botanical_vine',
        title: 'Interlaced Botanical Vine',
        category: 'Zentangle Art',
        description: 'Whimsical spiraling garden stems and leaf pods creating structured spaces for fine line texture.',
        icon: Icons.yard_rounded,
        difficulty: 'Beginner',
        tags: const ['Zentangle', 'Vine', 'Plants', 'Garden', 'Relaxing'],
        backgroundColor: const Color(0xFFFAFAF9),
        gridStyle: 'dots',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          objs.add(VectorArtHelper.stroke(
            id: '$projectId-stem',
            layerId: layerId,
            order: order++,
            points: [
              const Offset(-250, 250),
              const Offset(-150, 100),
              const Offset(0, 0),
              const Offset(150, -80),
              const Offset(280, -220),
            ],
            color: const Color(0xFF047857),
            strokeWidth: 3.5,
          ));

          for (int i = 0; i < 6; i++) {
            final cx = -200.0 + i * 90.0;
            final cy = 180.0 - i * 70.0;
            objs.add(VectorArtHelper.circle(
              id: '$projectId-pod-$i',
              layerId: layerId,
              order: order++,
              center: Offset(cx + (i.isEven ? 40 : -40), cy),
              radius: 28,
              strokeColor: const Color(0xFF059669),
              fillColor: const Color(0xFFECFDF5),
              strokeWidth: 2.0,
              isFilled: true,
            ));
          }
          return objs;
        },
      ),

      // ---------------- DOODLE ART ----------------
      TemplateModel(
        id: 'doodle_creative_desk',
        title: 'Creative Studio Workspace',
        category: 'Doodle Art',
        description: 'Charming stationery desk setting with tablet, sketchpad, pens, coffee mug, and succulent.',
        icon: Icons.draw_rounded,
        difficulty: 'Beginner',
        tags: const ['Doodle', 'Desk', 'Workspace', 'Tools', 'Cute'],
        isTrending: true,
        suggestedUsage: 'Illustrate your daily creative setup or add speech bubbles and fun labels.',
        backgroundColor: const Color(0xFFFFFBEB),
        gridStyle: 'dots',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Desk Surface
          objs.add(VectorArtHelper.rect(
            id: '$projectId-desk',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-320, -180, 640, 360),
            strokeColor: const Color(0xFF78350F),
            fillColor: const Color(0xFFFEF3C7),
            strokeWidth: 3.0,
            isFilled: true,
          ));

          // Sketchpad
          objs.add(VectorArtHelper.rect(
            id: '$projectId-pad',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-160, -100, 220, 260),
            strokeColor: const Color(0xFF1E293B),
            fillColor: Colors.white,
            strokeWidth: 2.5,
            isFilled: true,
          ));

          // Coffee Cup
          objs.add(VectorArtHelper.circle(
            id: '$projectId-cup',
            layerId: layerId,
            order: order++,
            center: const Offset(180, -60),
            radius: 40,
            strokeColor: const Color(0xFF92400E),
            fillColor: const Color(0xFFFDE68A),
            strokeWidth: 2.5,
            isFilled: true,
          ));

          // Stylus Pen
          objs.add(VectorArtHelper.line(
            id: '$projectId-pen',
            layerId: layerId,
            order: order++,
            start: const Offset(110, 40),
            end: const Offset(160, 160),
            color: const Color(0xFF0284C7),
            strokeWidth: 5.0,
          ));

          return objs;
        },
      ),

      TemplateModel(
        id: 'doodle_coffee_cafe',
        title: 'Morning Cafe Delights',
        category: 'Doodle Art',
        description: 'Cozy cafe doodles including espresso cups, croissants, coffee beans, and brewing gear.',
        icon: Icons.coffee_rounded,
        difficulty: 'Beginner',
        tags: const ['Doodle', 'Coffee', 'Cafe', 'Croissant', 'Warm'],
        backgroundColor: const Color(0xFFFFF8F1),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Big Coffee Mug
          objs.add(VectorArtHelper.rect(
            id: '$projectId-mug-body',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-120, -60, 160, 180),
            strokeColor: const Color(0xFF78350F),
            fillColor: const Color(0xFFFFEDD5),
            strokeWidth: 3.0,
            isFilled: true,
          ));

          // Steam Waves
          for (int s = -1; s <= 1; s++) {
            objs.add(VectorArtHelper.stroke(
              id: '$projectId-steam-$s',
              layerId: layerId,
              order: order++,
              points: [
                Offset(-40.0 + s * 40.0, -80),
                Offset(-30.0 + s * 40.0, -120),
                Offset(-50.0 + s * 40.0, -160),
                Offset(-35.0 + s * 40.0, -200),
              ],
              color: const Color(0xFFD97706),
              strokeWidth: 2.5,
            ));
          }

          return objs;
        },
      ),

      TemplateModel(
        id: 'doodle_botanical_garden',
        title: 'Cactus & Terrarium Pots',
        category: 'Doodle Art',
        description: 'Collection of patterned ceramic planters filled with assorted succulents and flowering cacti.',
        icon: Icons.local_florist_rounded,
        difficulty: 'Beginner',
        tags: const ['Doodle', 'Cactus', 'Succulent', 'Plants', 'Garden'],
        backgroundColor: const Color(0xFFF0FDF4),
        gridStyle: 'dots',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // 3 Planter Pots
          for (int i = -1; i <= 1; i++) {
            final cx = i * 200.0;
            objs.add(VectorArtHelper.rect(
              id: '$projectId-pot-$i',
              layerId: layerId,
              order: order++,
              rect: Rect.fromLTWH(cx - 60, 20, 120, 100),
              strokeColor: const Color(0xFF0F172A),
              fillColor: const Color(0xFFDCFCE7),
              strokeWidth: 2.5,
              isFilled: true,
            ));

            objs.add(VectorArtHelper.circle(
              id: '$projectId-cactus-$i',
              layerId: layerId,
              order: order++,
              center: Offset(cx, -40),
              radius: 50,
              strokeColor: const Color(0xFF15803D),
              fillColor: const Color(0xFF86EFAC),
              strokeWidth: 2.5,
              isFilled: true,
            ));
          }
          return objs;
        },
      ),

      TemplateModel(
        id: 'doodle_wanderlust_travel',
        title: 'Explorer Travel Kit',
        category: 'Doodle Art',
        description: 'Adventure map essentials: vintage camera, compass, flight passport, and postal stamps.',
        icon: Icons.flight_takeoff_rounded,
        difficulty: 'Intermediate',
        tags: const ['Doodle', 'Travel', 'Adventure', 'Map', 'Camera'],
        backgroundColor: const Color(0xFFFAF5FF),
        gridStyle: 'dots',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Vintage Camera Body
          objs.add(VectorArtHelper.rect(
            id: '$projectId-camera',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-160, -90, 320, 190),
            strokeColor: const Color(0xFF1E293B),
            fillColor: const Color(0xFFF1F5F9),
            strokeWidth: 3.0,
            isFilled: true,
          ));

          // Camera Lens
          objs.add(VectorArtHelper.circle(
            id: '$projectId-lens',
            layerId: layerId,
            order: order++,
            center: const Offset(0, 10),
            radius: 60,
            strokeColor: const Color(0xFF0284C7),
            fillColor: const Color(0xFFE0F2FE),
            strokeWidth: 3.0,
            isFilled: true,
          ));

          return objs;
        },
      ),

      // ---------------- ABSTRACT ART ----------------
      TemplateModel(
        id: 'abstract_bauhaus_study',
        title: 'Bauhaus Geometric Composition',
        category: 'Abstract Art',
        description: 'Rigorous modernist composition inspired by Bauhaus primary forms, intersecting arcs, and bold fields.',
        icon: Icons.category_rounded,
        difficulty: 'Intermediate',
        tags: const ['Abstract', 'Bauhaus', 'Modern', 'Minimal', 'Geometric'],
        isFeatured: true,
        suggestedUsage: 'Experiment with solid color blocking and high-contrast linework.',
        backgroundColor: const Color(0xFFF8FAFC),
        gridStyle: 'dots',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Red Primary Circle
          objs.add(VectorArtHelper.circle(
            id: '$projectId-red-circle',
            layerId: layerId,
            order: order++,
            center: const Offset(-80, -60),
            radius: 140,
            strokeColor: const Color(0xFFDC2626),
            fillColor: const Color(0xFFFEE2E2),
            strokeWidth: 3.5,
            isFilled: true,
          ));

          // Yellow Triangle / Polygon
          objs.add(VectorArtHelper.polygon(
            id: '$projectId-yellow-poly',
            layerId: layerId,
            order: order++,
            center: const Offset(120, 80),
            radius: 120,
            sides: 3,
            strokeColor: const Color(0xFFD97706),
            fillColor: const Color(0xFFFEF3C7),
            strokeWidth: 3.5,
            isFilled: true,
            rotation: 0.4,
          ));

          // Black Structural Spine
          objs.add(VectorArtHelper.line(
            id: '$projectId-spine',
            layerId: layerId,
            order: order++,
            start: const Offset(-260, 200),
            end: const Offset(260, -220),
            color: const Color(0xFF0F172A),
            strokeWidth: 4.0,
          ));

          return objs;
        },
      ),

      TemplateModel(
        id: 'abstract_memphis_pop',
        title: 'Memphis Neo-Pop Waves',
        category: 'Abstract Art',
        description: 'Vibrant 80s Memphis movement squiggles, floating confetti triangles, and bold grid accents.',
        icon: Icons.auto_awesome_rounded,
        difficulty: 'Beginner',
        tags: const ['Abstract', 'Memphis', 'Pop', 'Vibrant', 'Playful'],
        backgroundColor: const Color(0xFFFFFBEB),
        gridStyle: 'dots',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Squiggle 1
          objs.add(VectorArtHelper.stroke(
            id: '$projectId-sq1',
            layerId: layerId,
            order: order++,
            points: [
              const Offset(-220, -120),
              const Offset(-180, -70),
              const Offset(-140, -130),
              const Offset(-100, -70),
              const Offset(-60, -120),
            ],
            color: const Color(0xFF0284C7),
            strokeWidth: 6.0,
          ));

          // Circle cluster
          for (int c = 0; c < 5; c++) {
            objs.add(VectorArtHelper.circle(
              id: '$projectId-dot-$c',
              layerId: layerId,
              order: order++,
              center: Offset(80.0 + c * 35.0, -100.0 + (c.isEven ? 25 : -25)),
              radius: 14,
              strokeColor: const Color(0xFFE11D48),
              fillColor: const Color(0xFFFECDD3),
              strokeWidth: 2.5,
              isFilled: true,
            ));
          }

          return objs;
        },
      ),

      TemplateModel(
        id: 'abstract_fluid_balance',
        title: 'Fluid Organic Equilibrium',
        category: 'Abstract Art',
        description: 'Soothing asymmetrical organic blobs arranged in visual harmony inspired by Japanese minimalism.',
        icon: Icons.spa_rounded,
        difficulty: 'Intermediate',
        tags: const ['Abstract', 'Fluid', 'Minimal', 'Zen', 'Organic'],
        backgroundColor: const Color(0xFFF5F5F4),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          objs.add(VectorArtHelper.circle(
            id: '$projectId-stone1',
            layerId: layerId,
            order: order++,
            center: const Offset(-50, -80),
            radius: 110,
            strokeColor: const Color(0xFF475569),
            fillColor: const Color(0xFFE2E8F0),
            strokeWidth: 2.0,
            isFilled: true,
          ));

          objs.add(VectorArtHelper.circle(
            id: '$projectId-stone2',
            layerId: layerId,
            order: order++,
            center: const Offset(70, 70),
            radius: 80,
            strokeColor: const Color(0xFFB45309),
            fillColor: const Color(0xFFFED7AA),
            strokeWidth: 2.0,
            isFilled: true,
          ));

          return objs;
        },
      ),

      TemplateModel(
        id: 'abstract_optical_lattice',
        title: 'Optical Moiré Lattice',
        category: 'Abstract Art',
        description: 'Precision parallel line grids intersecting at critical angles to create optical illusion depths.',
        icon: Icons.grid_4x4_rounded,
        difficulty: 'Advanced',
        tags: const ['Abstract', 'Optical', 'Lines', 'Precision', 'BlackWhite'],
        backgroundColor: const Color(0xFFFFFFFF),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          for (int i = -10; i <= 10; i++) {
            objs.add(VectorArtHelper.line(
              id: '$projectId-v-$i',
              layerId: layerId,
              order: order++,
              start: Offset(i * 24.0, -260),
              end: Offset(i * 24.0, 260),
              color: const Color(0xFF0F172A),
              strokeWidth: 1.6,
            ));
          }

          objs.add(VectorArtHelper.circle(
            id: '$projectId-lens-focus',
            layerId: layerId,
            order: order++,
            center: Offset.zero,
            radius: 130,
            strokeColor: const Color(0xFF0284C7),
            strokeWidth: 3.5,
          ));

          return objs;
        },
      ),

      // ---------------- NATURE & LANDSCAPE ----------------
      TemplateModel(
        id: 'nature_alpine_peaks',
        title: 'Alpine Mountain Ridge',
        category: 'Nature & Landscape',
        description: 'Crisp layered mountain silhouettes, snow-capped ridges, and rising twilight moon.',
        icon: Icons.landscape_rounded,
        difficulty: 'Beginner',
        tags: const ['Landscape', 'Mountains', 'Alpine', 'Nature', 'Scenery'],
        isTrending: true,
        suggestedUsage: 'Ink the mountain facets with crosshatching or add watercolor wash sky gradients.',
        backgroundColor: const Color(0xFFF0FDF4),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Moon
          objs.add(VectorArtHelper.circle(
            id: '$projectId-moon',
            layerId: layerId,
            order: order++,
            center: const Offset(180, -140),
            radius: 45,
            strokeColor: const Color(0xFFD97706),
            fillColor: const Color(0xFFFEF3C7),
            strokeWidth: 2.0,
            isFilled: true,
          ));

          // Mountain 1 (Center)
          objs.add(VectorArtHelper.polygon(
            id: '$projectId-mt-center',
            layerId: layerId,
            order: order++,
            center: const Offset(0, 40),
            radius: 200,
            sides: 3,
            strokeColor: const Color(0xFF0F172A),
            fillColor: const Color(0xFFE2E8F0),
            strokeWidth: 3.0,
            isFilled: true,
          ));

          // Mountain 2 (Left)
          objs.add(VectorArtHelper.polygon(
            id: '$projectId-mt-left',
            layerId: layerId,
            order: order++,
            center: const Offset(-180, 80),
            radius: 160,
            sides: 3,
            strokeColor: const Color(0xFF334155),
            fillColor: const Color(0xFFCBD5E1),
            strokeWidth: 2.5,
            isFilled: true,
          ));

          return objs;
        },
      ),

      TemplateModel(
        id: 'nature_desert_dunes',
        title: 'Sahara Golden Dunes',
        category: 'Nature & Landscape',
        description: 'Sweeping S-curve ridgelines of wind-sculpted sand dunes beneath a desert sun.',
        icon: Icons.terrain_rounded,
        difficulty: 'Beginner',
        tags: const ['Nature', 'Desert', 'Dunes', 'Sunset', 'Warm'],
        backgroundColor: const Color(0xFFFFFBEB),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          for (int d = 0; d < 3; d++) {
            final y = -40.0 + d * 80.0;
            objs.add(VectorArtHelper.stroke(
              id: '$projectId-dune-$d',
              layerId: layerId,
              order: order++,
              points: [
                Offset(-320, y + 60),
                Offset(-140, y - 20),
                Offset(60, y + 40),
                Offset(320, y - 10),
              ],
              color: const Color(0xFFB45309),
              strokeWidth: 3.5,
            ));
          }
          return objs;
        },
      ),

      TemplateModel(
        id: 'nature_pine_forest',
        title: 'Pine Forest Lake Reflection',
        category: 'Nature & Landscape',
        description: 'Layered evergreen conifers along a tranquil mirrored forest shoreline.',
        icon: Icons.forest_rounded,
        difficulty: 'Intermediate',
        tags: const ['Nature', 'Forest', 'Pines', 'Trees', 'Calm'],
        backgroundColor: const Color(0xFFF1F5F9),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Conifer silhouettes
          for (int t = -3; t <= 3; t++) {
            final tx = t * 75.0;
            final th = 140.0 + (t.abs() % 2) * 30.0;
            objs.add(VectorArtHelper.polygon(
              id: '$projectId-pine-$t',
              layerId: layerId,
              order: order++,
              center: Offset(tx, 0),
              radius: th * 0.5,
              sides: 3,
              strokeColor: const Color(0xFF065F46),
              fillColor: const Color(0xFFA7F3D0),
              strokeWidth: 2.0,
              isFilled: true,
            ));
          }

          // Lake Shoreline
          objs.add(VectorArtHelper.line(
            id: '$projectId-shore',
            layerId: layerId,
            order: order++,
            start: const Offset(-300, 80),
            end: const Offset(300, 80),
            color: const Color(0xFF0284C7),
            strokeWidth: 2.5,
          ));

          return objs;
        },
      ),

      TemplateModel(
        id: 'nature_celestial_constellation',
        title: 'Deep Space Constellations',
        category: 'Nature & Landscape',
        description: 'Major stellar constellations mapped across a dark sky with connected astronomical lines.',
        icon: Icons.nights_stay_rounded,
        difficulty: 'Intermediate',
        tags: const ['Nature', 'Space', 'Stars', 'Constellation', 'Cosmic'],
        backgroundColor: const Color(0xFF0B0F19),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          final starPoints = [
            const Offset(-160, -100),
            const Offset(-80, -60),
            const Offset(-20, 20),
            const Offset(60, 40),
            const Offset(140, -40),
            const Offset(200, -120),
          ];

          for (int i = 0; i < starPoints.length - 1; i++) {
            objs.add(VectorArtHelper.line(
              id: '$projectId-link-$i',
              layerId: layerId,
              order: order++,
              start: starPoints[i],
              end: starPoints[i + 1],
              color: const Color(0xFF38BDF8).withValues(alpha: 0.6),
              strokeWidth: 1.5,
            ));
          }

          for (int i = 0; i < starPoints.length; i++) {
            objs.add(VectorArtHelper.circle(
              id: '$projectId-st-$i',
              layerId: layerId,
              order: order++,
              center: starPoints[i],
              radius: 7,
              strokeColor: const Color(0xFFFDE047),
              fillColor: Colors.white,
              strokeWidth: 2.0,
              isFilled: true,
            ));
          }

          return objs;
        },
      ),

      // ---------------- TYPOGRAPHY ART ----------------
      TemplateModel(
        id: 'typo_creative_studio',
        title: 'Creative Studio Monogram',
        category: 'Typography Art',
        description: 'Framed geometric editorial layout with bold center monogram, guidelines, and serif quotes.',
        icon: Icons.title_rounded,
        difficulty: 'Beginner',
        tags: const ['Typography', 'Monogram', 'Editorial', 'Poster', 'Quote'],
        isFeatured: true,
        suggestedUsage: 'Customize the central text, adjust letter-spacing, or add floral flourishes.',
        backgroundColor: const Color(0xFFF8FAFC),
        gridStyle: 'dots',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Double Border Frame
          objs.add(VectorArtHelper.rect(
            id: '$projectId-frame-out',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-240, -160, 480, 320),
            strokeColor: const Color(0xFF0F172A),
            strokeWidth: 3.0,
          ));

          objs.add(VectorArtHelper.rect(
            id: '$projectId-frame-in',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-220, -140, 440, 280),
            strokeColor: const Color(0xFF64748B),
            strokeWidth: 1.2,
          ));

          // Center Text
          objs.add(VectorArtHelper.text(
            id: '$projectId-txt-title',
            layerId: layerId,
            order: order++,
            text: 'INFINITE DREAMS',
            position: const Offset(-155, -20),
            fontSize: 26,
            color: const Color(0xFF0F172A),
            isBold: true,
          ));

          objs.add(VectorArtHelper.text(
            id: '$projectId-txt-sub',
            layerId: layerId,
            order: order++,
            text: 'WHERE EVERY DETAIL EXPANDS FOREVER',
            position: const Offset(-170, 25),
            fontSize: 12,
            color: const Color(0xFF0284C7),
            isBold: false,
          ));

          return objs;
        },
      ),

      TemplateModel(
        id: 'typo_geometric_poster',
        title: 'Swiss Bauhaus Grid Poster',
        category: 'Typography Art',
        description: 'Clean modernist layout structured with Swiss typography grid columns and asymmetric focal points.',
        icon: Icons.newspaper_rounded,
        difficulty: 'Intermediate',
        tags: const ['Typography', 'Swiss', 'Minimal', 'Poster', 'Grid'],
        backgroundColor: const Color(0xFFFFFFFF),
        gridStyle: 'lines',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Column guidelines
          for (int col = -2; col <= 2; col++) {
            objs.add(VectorArtHelper.line(
              id: '$projectId-grid-$col',
              layerId: layerId,
              order: order++,
              start: Offset(col * 90.0, -220),
              end: Offset(col * 90.0, 220),
              color: const Color(0xFFE2E8F0),
              strokeWidth: 1.0,
            ));
          }

          objs.add(VectorArtHelper.text(
            id: '$projectId-swiss-num',
            layerId: layerId,
            order: order++,
            text: '01',
            position: const Offset(-180, -190),
            fontSize: 64,
            color: const Color(0xFFE11D48),
            isBold: true,
          ));

          objs.add(VectorArtHelper.text(
            id: '$projectId-swiss-head',
            layerId: layerId,
            order: order++,
            text: 'PRECISION\nAND FORM',
            position: const Offset(-180, -90),
            fontSize: 32,
            color: const Color(0xFF0F172A),
            isBold: true,
          ));

          return objs;
        },
      ),

      TemplateModel(
        id: 'typo_calligraphy_banner',
        title: 'Ribbon Calligraphy Crest',
        category: 'Typography Art',
        description: 'Ornate curved ribbon banner designed for hand-drawn lettering, crests, and flourishes.',
        icon: Icons.brush_rounded,
        difficulty: 'Beginner',
        tags: const ['Typography', 'Banner', 'Calligraphy', 'Ribbon', 'Lettering'],
        backgroundColor: const Color(0xFFFFFBEB),
        gridStyle: 'dots',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Banner Box
          objs.add(VectorArtHelper.rect(
            id: '$projectId-banner',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-200, -45, 400, 90),
            strokeColor: const Color(0xFF78350F),
            fillColor: const Color(0xFFFEF3C7),
            strokeWidth: 2.5,
            isFilled: true,
          ));

          objs.add(VectorArtHelper.text(
            id: '$projectId-lettering',
            layerId: layerId,
            order: order++,
            text: 'MASTERPIECE',
            position: const Offset(-120, -12),
            fontSize: 24,
            color: const Color(0xFF78350F),
            isBold: true,
          ));

          return objs;
        },
      ),

      TemplateModel(
        id: 'typo_inspirational_manifesto',
        title: 'Creator Daily Manifesto',
        category: 'Typography Art',
        description: 'Multi-line typographic manifesto layout with emphasis callouts and quotation markers.',
        icon: Icons.format_quote_rounded,
        difficulty: 'Beginner',
        tags: const ['Typography', 'Manifesto', 'Inspiration', 'Quotes', 'Creative'],
        backgroundColor: const Color(0xFFFAFAFA),
        gridStyle: 'dots',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          objs.add(VectorArtHelper.text(
            id: '$projectId-q-mark',
            layerId: layerId,
            order: order++,
            text: '"',
            position: const Offset(-180, -120),
            fontSize: 72,
            color: const Color(0xFF0284C7),
            isBold: true,
          ));

          objs.add(VectorArtHelper.text(
            id: '$projectId-body-line',
            layerId: layerId,
            order: order++,
            text: 'CREATE EVERY DAY.\nSTART BEFORE YOU ARE READY.\nTHE CANVAS IS UNBOUNDED.',
            position: const Offset(-160, -30),
            fontSize: 16,
            color: const Color(0xFF1E293B),
            isBold: true,
          ));

          return objs;
        },
      ),

      // ---------------- COLORING TEMPLATES ----------------
      TemplateModel(
        id: 'coloring_sacred_elephant',
        title: 'Regal Mandala Elephant',
        category: 'Coloring Templates',
        description: 'Decorated royal elephant silhouette filled with fine paisley and floral line segments.',
        icon: Icons.color_lens_rounded,
        difficulty: 'Intermediate',
        tags: const ['Coloring', 'Elephant', 'Animals', 'Mandala', 'Relaxing'],
        isFeatured: true,
        suggestedUsage: 'Select watercolor brush or marker tool to bring each segment alive with rich tones.',
        backgroundColor: const Color(0xFFFFFFFF),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Elephant Head Arch
          objs.add(VectorArtHelper.circle(
            id: '$projectId-head',
            layerId: layerId,
            order: order++,
            center: const Offset(0, -30),
            radius: 120,
            strokeColor: const Color(0xFF0F172A),
            strokeWidth: 2.5,
          ));

          // Trunk Curve
          objs.add(VectorArtHelper.stroke(
            id: '$projectId-trunk',
            layerId: layerId,
            order: order++,
            points: [
              const Offset(0, 90),
              const Offset(40, 160),
              const Offset(90, 200),
              const Offset(130, 180),
              const Offset(110, 140),
            ],
            color: const Color(0xFF0F172A),
            strokeWidth: 3.0,
          ));

          // Ears
          for (final side in [-1, 1]) {
            objs.add(VectorArtHelper.circle(
              id: '$projectId-ear-$side',
              layerId: layerId,
              order: order++,
              center: Offset(side * 150.0, -40),
              radius: 65,
              strokeColor: const Color(0xFF0F172A),
              strokeWidth: 2.0,
            ));
          }

          return objs;
        },
      ),

      TemplateModel(
        id: 'coloring_botanical_butterfly',
        title: 'Symmetrical Floral Butterfly',
        category: 'Coloring Templates',
        description: 'Intricately patterned butterfly wings composed of flowering vines, buds, and teardrop cells.',
        icon: Icons.flutter_dash_rounded,
        difficulty: 'Intermediate',
        tags: const ['Coloring', 'Butterfly', 'Symmetry', 'Flowers', 'Insects'],
        backgroundColor: const Color(0xFFFFFFFF),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Body
          objs.add(VectorArtHelper.line(
            id: '$projectId-bf-body',
            layerId: layerId,
            order: order++,
            start: const Offset(0, -120),
            end: const Offset(0, 120),
            color: const Color(0xFF0F172A),
            strokeWidth: 5.0,
          ));

          // Symmetrical Wings
          for (final s in [-1, 1]) {
            objs.add(VectorArtHelper.circle(
              id: '$projectId-wing-top-$s',
              layerId: layerId,
              order: order++,
              center: Offset(s * 110.0, -40),
              radius: 90,
              strokeColor: const Color(0xFF0F172A),
              strokeWidth: 2.2,
            ));

            objs.add(VectorArtHelper.circle(
              id: '$projectId-wing-btm-$s',
              layerId: layerId,
              order: order++,
              center: Offset(s * 90.0, 70),
              radius: 65,
              strokeColor: const Color(0xFF0F172A),
              strokeWidth: 2.2,
            ));
          }

          return objs;
        },
      ),

      TemplateModel(
        id: 'coloring_cosmic_astronaut',
        title: 'Deep Space Astronaut',
        category: 'Coloring Templates',
        description: 'Retro space explorer helmet reflecting planets, orbit lines, and asteroid fields.',
        icon: Icons.rocket_launch_rounded,
        difficulty: 'Beginner',
        tags: const ['Coloring', 'Space', 'Astronaut', 'Cosmic', 'Planets'],
        backgroundColor: const Color(0xFF0F172A),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Helmet Outer
          objs.add(VectorArtHelper.circle(
            id: '$projectId-helmet',
            layerId: layerId,
            order: order++,
            center: Offset.zero,
            radius: 140,
            strokeColor: Colors.white,
            strokeWidth: 3.5,
          ));

          // Visor
          objs.add(VectorArtHelper.rect(
            id: '$projectId-visor',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-90, -45, 180, 90),
            strokeColor: const Color(0xFF38BDF8),
            fillColor: const Color(0xFF0369A1).withValues(alpha: 0.3),
            strokeWidth: 2.5,
            isFilled: true,
          ));

          return objs;
        },
      ),

      TemplateModel(
        id: 'coloring_ocean_turtle',
        title: 'Sea Turtle Coral Reef',
        category: 'Coloring Templates',
        description: 'Gentle marine sea turtle swimming through ocean sea kelp and coral gardens.',
        icon: Icons.water_drop_rounded,
        difficulty: 'Beginner',
        tags: const ['Coloring', 'Turtle', 'Ocean', 'Marine', 'Coral'],
        backgroundColor: const Color(0xFFF0FDF4),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Turtle Shell
          objs.add(VectorArtHelper.circle(
            id: '$projectId-shell',
            layerId: layerId,
            order: order++,
            center: Offset.zero,
            radius: 95,
            strokeColor: const Color(0xFF065F46),
            fillColor: const Color(0xFFA7F3D0).withValues(alpha: 0.3),
            strokeWidth: 3.0,
            isFilled: true,
          ));

          // Shell Scutes
          for (int s = 0; s < 6; s++) {
            final a = s * (2 * math.pi / 6);
            objs.add(VectorArtHelper.circle(
              id: '$projectId-scute-$s',
              layerId: layerId,
              order: order++,
              center: Offset(45 * math.cos(a), 45 * math.sin(a)),
              radius: 20,
              strokeColor: const Color(0xFF047857),
              strokeWidth: 1.8,
            ));
          }

          return objs;
        },
      ),

      // ---------------- DIGITAL ART ----------------
      TemplateModel(
        id: 'digital_color_palette_studio',
        title: 'Master Color Palette Studio',
        category: 'Digital Art',
        description: 'Professional color swatches, contrast test zones, gradient blend channels, and mood board slots.',
        icon: Icons.palette_rounded,
        difficulty: 'Beginner',
        tags: const ['Digital Art', 'Color', 'Palette', 'Swatches', 'Studio'],
        isEditorsPick: true,
        suggestedUsage: 'Organize your project color harmony with primary, secondary, and accent color mixes.',
        backgroundColor: const Color(0xFFF8FAFC),
        gridStyle: 'dots',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          final swatchColors = [
            const Color(0xFF0F172A),
            const Color(0xFF0284C7),
            const Color(0xFF059669),
            const Color(0xFFD97706),
            const Color(0xFFE11D48),
          ];

          for (int i = 0; i < swatchColors.length; i++) {
            final x = -240.0 + i * 105.0;
            objs.add(VectorArtHelper.rect(
              id: '$projectId-swatch-$i',
              layerId: layerId,
              order: order++,
              rect: Rect.fromLTWH(x, -120, 80, 110),
              strokeColor: const Color(0xFF1E293B),
              fillColor: swatchColors[i],
              strokeWidth: 2.0,
              isFilled: true,
            ));

            objs.add(VectorArtHelper.text(
              id: '$projectId-lbl-$i',
              layerId: layerId,
              order: order++,
              text: 'SLOT 0${i + 1}',
              position: Offset(x + 12, 10),
              fontSize: 11,
              color: const Color(0xFF64748B),
              isBold: true,
            ));
          }

          return objs;
        },
      ),

      TemplateModel(
        id: 'digital_golden_ratio_grid',
        title: 'Golden Ratio Composition Spiral',
        category: 'Digital Art',
        description: 'Golden spiral and phi proportion rectangles for drafting balanced cinematic compositions.',
        icon: Icons.aspect_ratio_rounded,
        difficulty: 'Intermediate',
        tags: const ['Digital Art', 'Golden Ratio', 'Composition', 'Grid', 'Design'],
        backgroundColor: const Color(0xFFFAFAFA),
        gridStyle: 'lines',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          objs.add(VectorArtHelper.rect(
            id: '$projectId-phi-outer',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-260, -160, 520, 320),
            strokeColor: const Color(0xFF0284C7),
            strokeWidth: 2.5,
          ));

          objs.add(VectorArtHelper.line(
            id: '$projectId-phi-split',
            layerId: layerId,
            order: order++,
            start: const Offset(60, -160),
            end: const Offset(60, 160),
            color: const Color(0xFF0284C7),
            strokeWidth: 2.0,
          ));

          return objs;
        },
      ),

      TemplateModel(
        id: 'digital_character_silhouette',
        title: 'Character Silhouette Lineup',
        category: 'Digital Art',
        description: 'Standard 8-head proportional guidelines for drafting dynamic hero and creature silhouettes.',
        icon: Icons.accessibility_new_rounded,
        difficulty: 'Intermediate',
        tags: const ['Digital Art', 'Character', 'Anatomy', 'Silhouette', 'Illustration'],
        backgroundColor: const Color(0xFFFFFFFF),
        gridStyle: 'dots',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // 8 Head height guidelines
          for (int h = 0; h <= 8; h++) {
            final y = -240.0 + h * 60.0;
            objs.add(VectorArtHelper.line(
              id: '$projectId-hl-$h',
              layerId: layerId,
              order: order++,
              start: Offset(-200, y),
              end: Offset(200, y),
              color: const Color(0xFFCBD5E1),
              strokeWidth: 1.0,
            ));

            objs.add(VectorArtHelper.text(
              id: '$projectId-ht-$h',
              layerId: layerId,
              order: order++,
              text: 'Head $h',
              position: Offset(-260, y - 8),
              fontSize: 10,
              color: const Color(0xFF94A3B8),
            ));
          }

          return objs;
        },
      ),

      TemplateModel(
        id: 'digital_isometric_room_starter',
        title: 'Isometric 3D Room Grid',
        category: 'Digital Art',
        description: 'Accurate 30-degree isometric room walls and floor guide for gaming assets and 3D scenes.',
        icon: Icons.view_in_ar_rounded,
        difficulty: 'Advanced',
        tags: const ['Digital Art', 'Isometric', '3D', 'Room', 'Gamedev'],
        isPremium: true,
        backgroundColor: const Color(0xFFF1F5F9),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Corner vertex
          const corner = Offset(0, 40);

          // Floor lines
          objs.add(VectorArtHelper.line(
            id: '$projectId-floor-l',
            layerId: layerId,
            order: order++,
            start: corner,
            end: const Offset(-240, -100),
            color: const Color(0xFF1E293B),
            strokeWidth: 2.5,
          ));

          objs.add(VectorArtHelper.line(
            id: '$projectId-floor-r',
            layerId: layerId,
            order: order++,
            start: corner,
            end: const Offset(240, -100),
            color: const Color(0xFF1E293B),
            strokeWidth: 2.5,
          ));

          // Center wall spine
          objs.add(VectorArtHelper.line(
            id: '$projectId-wall-spine',
            layerId: layerId,
            order: order++,
            start: corner,
            end: const Offset(0, -260),
            color: const Color(0xFF1E293B),
            strokeWidth: 2.5,
          ));

          return objs;
        },
      ),
    ];
  }
}
