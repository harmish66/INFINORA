import 'package:flutter/material.dart';
import '../../../canvas/domain/models/canvas_object.dart';
import '../../domain/models/template_model.dart';
import 'vector_template_helpers.dart';

class ProductivityTemplateGenerators {
  static List<TemplateModel> getTemplates() {
    return [
      // ---------------- MIND MAPS ----------------
      TemplateModel(
        id: 'mindmap_central_idea',
        title: 'Radial Concept Mind Map',
        category: 'Mind Maps',
        description: 'Clean central node surrounded by 4 branching thematic clusters and directional connector arrows.',
        icon: Icons.hub_rounded,
        difficulty: 'Beginner',
        tags: const ['Mind Map', 'Ideas', 'Brainstorm', 'Planning', 'Strategy'],
        isFeatured: true,
        isTrending: true,
        suggestedUsage: 'Replace node text with your primary goal and branch out into subtasks and deliverables.',
        backgroundColor: const Color(0xFFF8FAFC),
        gridStyle: 'dots',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Central Core Node
          objs.add(VectorArtHelper.rect(
            id: '$projectId-core-box',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-130, -45, 260, 90),
            strokeColor: const Color(0xFF0284C7),
            fillColor: const Color(0xFFE0F2FE),
            strokeWidth: 3.0,
            isFilled: true,
          ));

          objs.add(VectorArtHelper.text(
            id: '$projectId-core-text',
            layerId: layerId,
            order: order++,
            text: 'PRIMARY VISION',
            position: const Offset(-80, -10),
            fontSize: 18,
            color: const Color(0xFF0F172A),
            isBold: true,
          ));

          // 4 Satellite Nodes
          final satellites = [
            {'title': 'MARKET & USERS', 'pos': const Offset(-320, -180), 'color': const Color(0xFF059669), 'bg': const Color(0xFFDCFCE7)},
            {'title': 'PRODUCT ARCH', 'pos': const Offset(180, -180), 'color': const Color(0xFF2563EB), 'bg': const Color(0xFFDBEAFE)},
            {'title': 'GROWTH & OPS', 'pos': const Offset(-320, 140), 'color': const Color(0xFFD97706), 'bg': const Color(0xFFFEF3C7)},
            {'title': 'FINANCIAL RUNWAY', 'pos': const Offset(180, 140), 'color': const Color(0xFFDC2626), 'bg': const Color(0xFFFEE2E2)},
          ];

          for (int i = 0; i < satellites.length; i++) {
            final sat = satellites[i];
            final p = sat['pos'] as Offset;
            final col = sat['color'] as Color;
            final bg = sat['bg'] as Color;
            final title = sat['title'] as String;

            // Connector line from center
            objs.add(VectorArtHelper.arrow(
              id: '$projectId-arrow-$i',
              layerId: layerId,
              order: order++,
              start: p.dx < 0 ? const Offset(-130, 0) : const Offset(130, 0),
              end: Offset(p.dx + 80, p.dy + 35),
              color: col.withValues(alpha: 0.6),
              strokeWidth: 2.0,
            ));

            objs.add(VectorArtHelper.rect(
              id: '$projectId-node-$i',
              layerId: layerId,
              order: order++,
              rect: Rect.fromLTWH(p.dx, p.dy, 170, 70),
              strokeColor: col,
              fillColor: bg,
              strokeWidth: 2.0,
              isFilled: true,
            ));

            objs.add(VectorArtHelper.text(
              id: '$projectId-txt-$i',
              layerId: layerId,
              order: order++,
              text: title,
              position: Offset(p.dx + 16, p.dy + 25),
              fontSize: 12,
              color: const Color(0xFF0F172A),
              isBold: true,
            ));
          }

          return objs;
        },
      ),

      TemplateModel(
        id: 'mindmap_product_roadmap',
        title: 'Quarterly Product Roadmap',
        category: 'Mind Maps',
        description: 'Multi-stream timeline matrix dividing Q1 through Q4 feature epics, UX, and backend infrastructure.',
        icon: Icons.alt_route_rounded,
        difficulty: 'Intermediate',
        tags: const ['Mind Map', 'Roadmap', 'Product', 'Agile', 'Software'],
        isEditorsPick: true,
        backgroundColor: const Color(0xFFFFFFFF),
        gridStyle: 'lines',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // 4 Quarter Columns
          for (int q = 0; q < 4; q++) {
            final x = -300.0 + q * 155.0;
            objs.add(VectorArtHelper.rect(
              id: '$projectId-q-col-$q',
              layerId: layerId,
              order: order++,
              rect: Rect.fromLTWH(x, -160, 140, 320),
              strokeColor: const Color(0xFFE2E8F0),
              fillColor: const Color(0xFFF8FAFC),
              strokeWidth: 1.5,
              isFilled: true,
            ));

            objs.add(VectorArtHelper.text(
              id: '$projectId-q-title-$q',
              layerId: layerId,
              order: order++,
              text: 'QUARTER 0${q + 1}',
              position: Offset(x + 22, -140),
              fontSize: 13,
              color: const Color(0xFF0F172A),
              isBold: true,
            ));
          }

          return objs;
        },
      ),

      TemplateModel(
        id: 'mindmap_skill_tree',
        title: 'Creative Skill Mastery Tree',
        category: 'Mind Maps',
        description: 'Hierarchical prerequisite node tree tracking foundation art skills, software mastery, and portfolio projects.',
        icon: Icons.account_tree_rounded,
        difficulty: 'Intermediate',
        tags: const ['Mind Map', 'Skills', 'Learning', 'Mastery', 'Growth'],
        backgroundColor: const Color(0xFFFAFAFA),
        gridStyle: 'dots',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Root Node
          objs.add(VectorArtHelper.rect(
            id: '$projectId-root',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-110, 100, 220, 65),
            strokeColor: const Color(0xFF059669),
            fillColor: const Color(0xFFDCFCE7),
            strokeWidth: 2.5,
            isFilled: true,
          ));

          objs.add(VectorArtHelper.text(
            id: '$projectId-root-txt',
            layerId: layerId,
            order: order++,
            text: 'FOUNDATIONS',
            position: const Offset(-60, 122),
            fontSize: 14,
            color: const Color(0xFF065F46),
            isBold: true,
          ));

          // Level 1 Nodes
          for (int i = -1; i <= 1; i++) {
            final x = i * 180.0;
            objs.add(VectorArtHelper.rect(
              id: '$projectId-lvl1-$i',
              layerId: layerId,
              order: order++,
              rect: Rect.fromLTWH(x - 70, -20, 140, 55),
              strokeColor: const Color(0xFF0284C7),
              fillColor: const Color(0xFFE0F2FE),
              strokeWidth: 2.0,
              isFilled: true,
            ));
          }

          return objs;
        },
      ),

      TemplateModel(
        id: 'mindmap_brainstorm_matrix',
        title: 'Exploration Idea Matrix',
        category: 'Mind Maps',
        description: 'Radial constellation connecting core brand values with customer pain points and creative hooks.',
        icon: Icons.bubble_chart_rounded,
        difficulty: 'Beginner',
        tags: const ['Mind Map', 'Matrix', 'Brainstorm', 'Constellation'],
        backgroundColor: const Color(0xFFF8FAFC),
        gridStyle: 'dots',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          objs.add(VectorArtHelper.circle(
            id: '$projectId-center-matrix',
            layerId: layerId,
            order: order++,
            center: Offset.zero,
            radius: 75,
            strokeColor: const Color(0xFFD97706),
            fillColor: const Color(0xFFFEF3C7),
            strokeWidth: 2.5,
            isFilled: true,
          ));

          objs.add(VectorArtHelper.text(
            id: '$projectId-mat-txt',
            layerId: layerId,
            order: order++,
            text: 'CORE VALUE',
            position: const Offset(-45, -8),
            fontSize: 14,
            color: const Color(0xFF78350F),
            isBold: true,
          ));

          return objs;
        },
      ),

      // ---------------- BRAINSTORMING ----------------
      TemplateModel(
        id: 'brainstorm_crazy_eights',
        title: 'Crazy Eights Rapid Sketching',
        category: 'Brainstorming',
        description: 'Design Sprint standard 8-box rapid prototyping canvas for generating 8 distinct concepts in 8 minutes.',
        icon: Icons.dashboard_customize_rounded,
        difficulty: 'Beginner',
        tags: const ['Brainstorming', 'Design Sprint', 'Crazy Eights', 'UX', 'Rapid'],
        isFeatured: true,
        suggestedUsage: 'Spend one minute sketching in each box without judging or editing your initial instinct.',
        backgroundColor: const Color(0xFFFFFFFF),
        gridStyle: 'dots',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // 2 Rows x 4 Columns
          for (int r = 0; r < 2; r++) {
            for (int c = 0; c < 4; c++) {
              final x = -310.0 + c * 160.0;
              final y = -150.0 + r * 155.0;
              final idx = r * 4 + c + 1;

              objs.add(VectorArtHelper.rect(
                id: '$projectId-box-$idx',
                layerId: layerId,
                order: order++,
                rect: Rect.fromLTWH(x, y, 145, 140),
                strokeColor: const Color(0xFF94A3B8),
                strokeWidth: 2.0,
              ));

              objs.add(VectorArtHelper.text(
                id: '$projectId-num-$idx',
                layerId: layerId,
                order: order++,
                text: '0$idx',
                position: Offset(x + 12, y + 10),
                fontSize: 13,
                color: const Color(0xFF0284C7),
                isBold: true,
              ));
            }
          }

          return objs;
        },
      ),

      TemplateModel(
        id: 'brainstorm_six_thinking_hats',
        title: 'Six Thinking Hats Evaluation',
        category: 'Brainstorming',
        description: 'Edward de Bono framework organizing white (facts), red (emotions), black (risks), and yellow (optimism) perspectives.',
        icon: Icons.psychology_rounded,
        difficulty: 'Intermediate',
        tags: const ['Brainstorming', 'Six Hats', 'Evaluation', 'Decision', 'Critical'],
        backgroundColor: const Color(0xFFF8FAFC),
        gridStyle: 'dots',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          final hats = [
            {'title': 'WHITE: FACTS & DATA', 'col': const Color(0xFF64748B), 'bg': const Color(0xFFF1F5F9)},
            {'title': 'RED: GUT FEELINGS', 'col': const Color(0xFFDC2626), 'bg': const Color(0xFFFEE2E2)},
            {'title': 'BLACK: CRITICAL RISKS', 'col': const Color(0xFF0F172A), 'bg': const Color(0xFFE2E8F0)},
            {'title': 'YELLOW: VALUE & PERKS', 'col': const Color(0xFFD97706), 'bg': const Color(0xFFFEF3C7)},
            {'title': 'GREEN: CREATIVE WAYS', 'col': const Color(0xFF15803D), 'bg': const Color(0xFFDCFCE7)},
            {'title': 'BLUE: METAPLAN & NEXT', 'col': const Color(0xFF2563EB), 'bg': const Color(0xFFDBEAFE)},
          ];

          for (int i = 0; i < hats.length; i++) {
            final col = i % 3;
            final row = i ~/ 3;
            final x = -300.0 + col * 205.0;
            final y = -140.0 + row * 150.0;
            final item = hats[i];

            objs.add(VectorArtHelper.rect(
              id: '$projectId-hat-$i',
              layerId: layerId,
              order: order++,
              rect: Rect.fromLTWH(x, y, 190, 130),
              strokeColor: item['col'] as Color,
              fillColor: item['bg'] as Color,
              strokeWidth: 2.0,
              isFilled: true,
            ));

            objs.add(VectorArtHelper.text(
              id: '$projectId-hat-txt-$i',
              layerId: layerId,
              order: order++,
              text: item['title'] as String,
              position: Offset(x + 12, y + 14),
              fontSize: 11,
              color: const Color(0xFF0F172A),
              isBold: true,
            ));
          }

          return objs;
        },
      ),

      TemplateModel(
        id: 'brainstorm_scamper',
        title: 'SCAMPER Creative Catalyst',
        category: 'Brainstorming',
        description: 'Substitute, Combine, Adapt, Modify, Put to other uses, Eliminate, and Reverse ideation triggers.',
        icon: Icons.lightbulb_rounded,
        difficulty: 'Intermediate',
        tags: const ['Brainstorming', 'SCAMPER', 'Ideation', 'Innovation', 'Design'],
        backgroundColor: const Color(0xFFFFFBEB),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          final triggers = ['SUBSTITUTE', 'COMBINE', 'ADAPT', 'MAGNIFY', 'PUT TO USE', 'ELIMINATE', 'REVERSE'];
          for (int i = 0; i < triggers.length; i++) {
            final y = -180.0 + i * 54.0;
            objs.add(VectorArtHelper.rect(
              id: '$projectId-scamper-$i',
              layerId: layerId,
              order: order++,
              rect: Rect.fromLTWH(-280, y, 560, 44),
              strokeColor: const Color(0xFFB45309),
              fillColor: const Color(0xFFFEF3C7),
              strokeWidth: 1.5,
              isFilled: true,
            ));

            objs.add(VectorArtHelper.text(
              id: '$projectId-scamper-txt-$i',
              layerId: layerId,
              order: order++,
              text: triggers[i],
              position: Offset(-260, y + 12),
              fontSize: 13,
              color: const Color(0xFF78350F),
              isBold: true,
            ));
          }

          return objs;
        },
      ),

      TemplateModel(
        id: 'brainstorm_affinity_diagram',
        title: 'Affinity Diagramming Wall',
        category: 'Brainstorming',
        description: 'Virtual sticky-note clustering board with color-coded thematic columns for user interview insights.',
        icon: Icons.sticky_note_2_rounded,
        difficulty: 'Beginner',
        tags: const ['Brainstorming', 'Sticky Notes', 'Affinity', 'User Research', 'Synthesis'],
        backgroundColor: const Color(0xFFF1F5F9),
        gridStyle: 'dots',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          final noteColors = [const Color(0xFFFEF08A), const Color(0xFFBAE6FD), const Color(0xFFBBF7D0)];
          for (int c = 0; c < 3; c++) {
            for (int r = 0; r < 3; r++) {
              final x = -280.0 + c * 195.0;
              final y = -140.0 + r * 110.0;
              objs.add(VectorArtHelper.rect(
                id: '$projectId-sticky-$c-$r',
                layerId: layerId,
                order: order++,
                rect: Rect.fromLTWH(x, y, 160, 95),
                strokeColor: const Color(0xFF64748B),
                fillColor: noteColors[c],
                strokeWidth: 1.5,
                isFilled: true,
              ));
            }
          }

          return objs;
        },
      ),

      // ---------------- STUDY NOTES ----------------
      TemplateModel(
        id: 'study_cornell_notes',
        title: 'Cornell Note-Taking System',
        category: 'Study Notes',
        description: 'The golden standard academic layout with left cue column, wide note-taking field, and bottom summary block.',
        icon: Icons.menu_book_rounded,
        difficulty: 'Beginner',
        tags: const ['Study Notes', 'Cornell', 'Academic', 'Lecture', 'Exam'],
        isFeatured: true,
        suggestedUsage: 'Write keywords and questions on the left column, main lecture notes on right, and synthesize at the bottom.',
        backgroundColor: const Color(0xFFFFFFFF),
        gridStyle: 'lines',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Sheet Border
          objs.add(VectorArtHelper.rect(
            id: '$projectId-sheet',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-280, -200, 560, 400),
            strokeColor: const Color(0xFF0F172A),
            strokeWidth: 2.5,
          ));

          // Cue Column Divider
          objs.add(VectorArtHelper.line(
            id: '$projectId-cue-div',
            layerId: layerId,
            order: order++,
            start: const Offset(-100, -200),
            end: const Offset(-100, 110),
            color: const Color(0xFF0284C7),
            strokeWidth: 2.0,
          ));

          // Summary Section Divider
          objs.add(VectorArtHelper.line(
            id: '$projectId-sum-div',
            layerId: layerId,
            order: order++,
            start: const Offset(-280, 110),
            end: const Offset(280, 110),
            color: const Color(0xFF0284C7),
            strokeWidth: 2.0,
          ));

          objs.add(VectorArtHelper.text(
            id: '$projectId-cue-lbl',
            layerId: layerId,
            order: order++,
            text: 'CUES / QUESTIONS',
            position: const Offset(-260, -180),
            fontSize: 12,
            color: const Color(0xFF64748B),
            isBold: true,
          ));

          objs.add(VectorArtHelper.text(
            id: '$projectId-notes-lbl',
            layerId: layerId,
            order: order++,
            text: 'MAIN CLASS LECTURE NOTES',
            position: const Offset(-80, -180),
            fontSize: 12,
            color: const Color(0xFF64748B),
            isBold: true,
          ));

          objs.add(VectorArtHelper.text(
            id: '$projectId-sum-lbl',
            layerId: layerId,
            order: order++,
            text: 'SUMMARY & SYNTHESIS',
            position: const Offset(-260, 130),
            fontSize: 12,
            color: const Color(0xFF64748B),
            isBold: true,
          ));

          return objs;
        },
      ),

      TemplateModel(
        id: 'study_concept_matrix',
        title: 'Concept Comparison Matrix',
        category: 'Study Notes',
        description: 'Side-by-side analytical table comparing two complex historical periods, theories, or algorithms.',
        icon: Icons.table_chart_rounded,
        difficulty: 'Beginner',
        tags: const ['Study Notes', 'Comparison', 'Matrix', 'Research', 'Academic'],
        backgroundColor: const Color(0xFFFAFAFA),
        gridStyle: 'lines',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Header Row
          objs.add(VectorArtHelper.rect(
            id: '$projectId-th1',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-280, -160, 270, 60),
            strokeColor: const Color(0xFF0F172A),
            fillColor: const Color(0xFFE2E8F0),
            strokeWidth: 2.0,
            isFilled: true,
          ));

          objs.add(VectorArtHelper.rect(
            id: '$projectId-th2',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(10, -160, 270, 60),
            strokeColor: const Color(0xFF0F172A),
            fillColor: const Color(0xFFE2E8F0),
            strokeWidth: 2.0,
            isFilled: true,
          ));

          return objs;
        },
      ),

      TemplateModel(
        id: 'study_vocabulary_builder',
        title: 'Language Vocabulary Cards',
        category: 'Study Notes',
        description: 'Structured index-card grid for language acquisition: terms, phonetic breakdown, context, and examples.',
        icon: Icons.translate_rounded,
        difficulty: 'Beginner',
        tags: const ['Study Notes', 'Vocabulary', 'Language', 'Flashcards', 'Grammar'],
        backgroundColor: const Color(0xFFFFFBEB),
        gridStyle: 'dots',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          for (int i = 0; i < 4; i++) {
            final col = i % 2;
            final row = i ~/ 2;
            final x = -260.0 + col * 270.0;
            final y = -140.0 + row * 160.0;

            objs.add(VectorArtHelper.rect(
              id: '$projectId-vcard-$i',
              layerId: layerId,
              order: order++,
              rect: Rect.fromLTWH(x, y, 250, 140),
              strokeColor: const Color(0xFFB45309),
              fillColor: Colors.white,
              strokeWidth: 2.0,
              isFilled: true,
            ));
          }

          return objs;
        },
      ),

      TemplateModel(
        id: 'study_weekly_lecture_digest',
        title: 'Weekly Module Synthesis',
        category: 'Study Notes',
        description: 'Comprehensive 5-day lecture synthesis sheet with readings checklist and assignment priority bar.',
        icon: Icons.calendar_view_week_rounded,
        difficulty: 'Beginner',
        tags: const ['Study Notes', 'Weekly', 'Digest', 'Syllabus', 'Homework'],
        backgroundColor: const Color(0xFFF0FDF4),
        gridStyle: 'dots',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          objs.add(VectorArtHelper.rect(
            id: '$projectId-digest-head',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-280, -180, 560, 60),
            strokeColor: const Color(0xFF15803D),
            fillColor: const Color(0xFFDCFCE7),
            strokeWidth: 2.0,
            isFilled: true,
          ));

          return objs;
        },
      ),

      // ---------------- VISION BOARDS ----------------
      TemplateModel(
        id: 'vision_yearly_manifesto',
        title: 'Annual Aspirations Canvas',
        category: 'Vision Boards',
        description: 'Multi-aspect vision board organizing health, creative projects, relationships, financial growth, and travel.',
        icon: Icons.auto_awesome_mosaic_rounded,
        difficulty: 'Beginner',
        tags: const ['Vision Board', 'Yearly', 'Goals', 'Inspiration', 'Dreams'],
        isFeatured: true,
        isTrending: true,
        suggestedUsage: 'Insert inspiring photo clips, write affirmations, and hand-draw key milestones for your year.',
        backgroundColor: const Color(0xFFFBFBFB),
        gridStyle: 'dots',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          final domains = [
            {'title': 'CAREER & ART', 'rect': const Rect.fromLTWH(-280, -160, 260, 140), 'col': const Color(0xFF0284C7)},
            {'title': 'MINDFULNESS', 'rect': const Rect.fromLTWH(20, -160, 260, 140), 'col': const Color(0xFF059669)},
            {'title': 'WORLD TRAVEL', 'rect': const Rect.fromLTWH(-280, 10, 260, 140), 'col': const Color(0xFFD97706)},
            {'title': 'FINANCIAL GOALS', 'rect': const Rect.fromLTWH(20, 10, 260, 140), 'col': const Color(0xFFDC2626)},
          ];

          for (int i = 0; i < domains.length; i++) {
            final d = domains[i];
            final r = d['rect'] as Rect;
            final col = d['col'] as Color;
            final title = d['title'] as String;

            objs.add(VectorArtHelper.rect(
              id: '$projectId-dom-$i',
              layerId: layerId,
              order: order++,
              rect: r,
              strokeColor: col,
              fillColor: col.withValues(alpha: 0.08),
              strokeWidth: 2.0,
              isFilled: true,
            ));

            objs.add(VectorArtHelper.text(
              id: '$projectId-dom-txt-$i',
              layerId: layerId,
              order: order++,
              text: title,
              position: Offset(r.left + 16, r.top + 16),
              fontSize: 13,
              color: col,
              isBold: true,
            ));
          }

          return objs;
        },
      ),

      TemplateModel(
        id: 'vision_creative_milestones',
        title: 'Creative Milestones Horizon',
        category: 'Vision Boards',
        description: 'Step-by-step visual mountain path marking studio launches, art exhibitions, and publication goals.',
        icon: Icons.flag_rounded,
        difficulty: 'Intermediate',
        tags: const ['Vision Board', 'Milestones', 'Career', 'Launch', 'Success'],
        backgroundColor: const Color(0xFFF8FAFC),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          objs.add(VectorArtHelper.stroke(
            id: '$projectId-path',
            layerId: layerId,
            order: order++,
            points: [
              const Offset(-260, 140),
              const Offset(-130, 60),
              const Offset(20, -20),
              const Offset(160, -90),
              const Offset(260, -160),
            ],
            color: const Color(0xFF0284C7),
            strokeWidth: 4.0,
          ));

          return objs;
        },
      ),

      TemplateModel(
        id: 'vision_wellness_sanctuary',
        title: 'Wellness & Daily Vitality',
        category: 'Vision Boards',
        description: 'Holistic wellness visualizer: hydration tracker, sleep hygiene, nutrition harmony, and nature walks.',
        icon: Icons.self_improvement_rounded,
        difficulty: 'Beginner',
        tags: const ['Vision Board', 'Wellness', 'Health', 'Habits', 'Peace'],
        backgroundColor: const Color(0xFFF0FDF4),
        gridStyle: 'dots',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          objs.add(VectorArtHelper.circle(
            id: '$projectId-vitality-center',
            layerId: layerId,
            order: order++,
            center: Offset.zero,
            radius: 90,
            strokeColor: const Color(0xFF059669),
            fillColor: const Color(0xFFDCFCE7),
            strokeWidth: 3.0,
            isFilled: true,
          ));

          return objs;
        },
      ),

      TemplateModel(
        id: 'vision_personal_manifesto',
        title: 'Core Values & Principles',
        category: 'Vision Boards',
        description: 'Centered typography pillars articulating personal non-negotiables, creative integrity, and life axioms.',
        icon: Icons.shield_rounded,
        difficulty: 'Beginner',
        tags: const ['Vision Board', 'Values', 'Integrity', 'Principles', 'Focus'],
        backgroundColor: const Color(0xFFFAFAFA),
        gridStyle: 'dots',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          objs.add(VectorArtHelper.rect(
            id: '$projectId-man-frame',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-240, -160, 480, 320),
            strokeColor: const Color(0xFF0F172A),
            strokeWidth: 2.5,
          ));

          return objs;
        },
      ),

      // ---------------- DAILY PLANNING ----------------
      TemplateModel(
        id: 'plan_timeblock_agenda',
        title: 'Time-Blocking Daily Agenda',
        category: 'Daily Planning',
        description: 'Structured hour-by-hour vertical schedule from 6 AM to 10 PM with priority checkboxes and focus tags.',
        icon: Icons.access_time_filled_rounded,
        difficulty: 'Beginner',
        tags: const ['Daily Planning', 'Schedule', 'Timeblock', 'Routine', 'Productivity'],
        isFeatured: true,
        suggestedUsage: 'Group your deep work hours into uninterrupted 90-minute blocks and color code tasks.',
        backgroundColor: const Color(0xFFFFFFFF),
        gridStyle: 'lines',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Hourly schedule lines
          for (int h = 0; h < 8; h++) {
            final y = -160.0 + h * 42.0;
            objs.add(VectorArtHelper.line(
              id: '$projectId-h-line-$h',
              layerId: layerId,
              order: order++,
              start: Offset(-280, y),
              end: Offset(280, y),
              color: const Color(0xFFE2E8F0),
              strokeWidth: 1.2,
            ));

            final hourStr = '${6 + h * 2}:00';
            objs.add(VectorArtHelper.text(
              id: '$projectId-h-txt-$h',
              layerId: layerId,
              order: order++,
              text: hourStr,
              position: Offset(-260, y - 10),
              fontSize: 12,
              color: const Color(0xFF64748B),
              isBold: true,
            ));
          }

          return objs;
        },
      ),

      TemplateModel(
        id: 'plan_eisenhower_matrix',
        title: 'Eisenhower Priority Matrix',
        category: 'Daily Planning',
        description: 'Four quadrants separating Do First, Schedule, Delegate, and Don’t Do urgent vs important items.',
        icon: Icons.grid_view_rounded,
        difficulty: 'Beginner',
        tags: const ['Daily Planning', 'Eisenhower', 'Priority', 'Tasks', 'Focus'],
        isEditorsPick: true,
        backgroundColor: const Color(0xFFF8FAFC),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          final quads = [
            {'title': 'DO FIRST (URGENT & CRITICAL)', 'rect': const Rect.fromLTWH(-280, -150, 260, 130), 'col': const Color(0xFFDC2626)},
            {'title': 'SCHEDULE (IMPORTANT & STRATEGIC)', 'rect': const Rect.fromLTWH(20, -150, 260, 130), 'col': const Color(0xFF2563EB)},
            {'title': 'DELEGATE (URGENT BUT AUTOMATABLE)', 'rect': const Rect.fromLTWH(-280, 10, 260, 130), 'col': const Color(0xFFD97706)},
            {'title': 'ELIMINATE (DISTRACTIONS)', 'rect': const Rect.fromLTWH(20, 10, 260, 130), 'col': const Color(0xFF64748B)},
          ];

          for (int i = 0; i < quads.length; i++) {
            final q = quads[i];
            final r = q['rect'] as Rect;
            final col = q['col'] as Color;
            final title = q['title'] as String;

            objs.add(VectorArtHelper.rect(
              id: '$projectId-quad-$i',
              layerId: layerId,
              order: order++,
              rect: r,
              strokeColor: col,
              fillColor: col.withValues(alpha: 0.08),
              strokeWidth: 2.0,
              isFilled: true,
            ));

            objs.add(VectorArtHelper.text(
              id: '$projectId-quad-txt-$i',
              layerId: layerId,
              order: order++,
              text: title,
              position: Offset(r.left + 12, r.top + 12),
              fontSize: 10,
              color: col,
              isBold: true,
            ));
          }

          return objs;
        },
      ),

      TemplateModel(
        id: 'plan_habit_streak_tracker',
        title: '30-Day Habit Streak Tracker',
        category: 'Daily Planning',
        description: 'Month-at-a-glance circular punch tracker for building daily drawing, reading, and wellness streaks.',
        icon: Icons.check_circle_rounded,
        difficulty: 'Beginner',
        tags: const ['Daily Planning', 'Habits', 'Streaks', 'Routine', 'Month'],
        backgroundColor: const Color(0xFFFAFAFA),
        gridStyle: 'dots',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // 5 Rows x 6 Cols = 30 Days
          for (int r = 0; r < 5; r++) {
            for (int c = 0; c < 6; c++) {
              final x = -250.0 + c * 90.0;
              final y = -140.0 + r * 65.0;
              final day = r * 6 + c + 1;

              objs.add(VectorArtHelper.circle(
                id: '$projectId-day-$day',
                layerId: layerId,
                order: order++,
                center: Offset(x, y),
                radius: 22,
                strokeColor: const Color(0xFF059669),
                fillColor: const Color(0xFFDCFCE7),
                strokeWidth: 2.0,
                isFilled: true,
              ));

              objs.add(VectorArtHelper.text(
                id: '$projectId-day-num-$day',
                layerId: layerId,
                order: order++,
                text: '$day',
                position: Offset(x - (day < 10 ? 5 : 9), y - 8),
                fontSize: 12,
                color: const Color(0xFF065F46),
                isBold: true,
              ));
            }
          }

          return objs;
        },
      ),

      TemplateModel(
        id: 'plan_weekly_sprint_board',
        title: 'Weekly Sprint Kanban Board',
        category: 'Daily Planning',
        description: 'Agile Kanban column board with Backlog, Doing, Review, and Shipped swimlanes.',
        icon: Icons.view_column_rounded,
        difficulty: 'Intermediate',
        tags: const ['Daily Planning', 'Kanban', 'Sprint', 'Agile', 'Tasks'],
        backgroundColor: const Color(0xFFF1F5F9),
        gridStyle: 'dots',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          final cols = ['TO DO', 'IN PROGRESS', 'REVIEW', 'SHIPPED'];
          for (int c = 0; c < 4; c++) {
            final x = -290.0 + c * 150.0;
            objs.add(VectorArtHelper.rect(
              id: '$projectId-kanban-$c',
              layerId: layerId,
              order: order++,
              rect: Rect.fromLTWH(x, -160, 135, 320),
              strokeColor: const Color(0xFFCBD5E1),
              fillColor: Colors.white,
              strokeWidth: 1.5,
              isFilled: true,
            ));

            objs.add(VectorArtHelper.text(
              id: '$projectId-kanban-txt-$c',
              layerId: layerId,
              order: order++,
              text: cols[c],
              position: Offset(x + 14, -140),
              fontSize: 11,
              color: const Color(0xFF0F172A),
              isBold: true,
            ));
          }

          return objs;
        },
      ),

      // ---------------- BUSINESS PLANNING ----------------
      TemplateModel(
        id: 'biz_lean_canvas',
        title: 'Startup Lean Canvas Model',
        category: 'Business Planning',
        description: 'Single-page business blueprint mapping Problem, Solution, Unique Value, Channels, and Unit Economics.',
        icon: Icons.business_center_rounded,
        difficulty: 'Intermediate',
        tags: const ['Business', 'Lean Canvas', 'Startup', 'Strategy', 'Model'],
        isFeatured: true,
        suggestedUsage: 'Draft your complete venture hypothesis in an afternoon; iterate based on customer feedback.',
        backgroundColor: const Color(0xFFFFFFFF),
        gridStyle: 'lines',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Outer Boundary
          objs.add(VectorArtHelper.rect(
            id: '$projectId-canvas-border',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-300, -180, 600, 360),
            strokeColor: const Color(0xFF0F172A),
            strokeWidth: 2.5,
          ));

          // Vertical splits
          for (int i = 1; i < 5; i++) {
            final x = -300.0 + i * 120.0;
            objs.add(VectorArtHelper.line(
              id: '$projectId-vsplit-$i',
              layerId: layerId,
              order: order++,
              start: Offset(x, -180),
              end: Offset(x, 80),
              color: const Color(0xFF94A3B8),
              strokeWidth: 1.5,
            ));
          }

          // Horizontal unit economics split
          objs.add(VectorArtHelper.line(
            id: '$projectId-hsplit',
            layerId: layerId,
            order: order++,
            start: const Offset(-300, 80),
            end: const Offset(300, 80),
            color: const Color(0xFF0F172A),
            strokeWidth: 2.0,
          ));

          return objs;
        },
      ),

      TemplateModel(
        id: 'biz_swot_matrix',
        title: 'SWOT Strategy Framework',
        category: 'Business Planning',
        description: 'Comprehensive 2x2 matrix analyzing Strengths, Weaknesses, Opportunities, and Threats.',
        icon: Icons.pie_chart_rounded,
        difficulty: 'Beginner',
        tags: const ['Business', 'SWOT', 'Strategy', 'Analysis', 'Market'],
        isEditorsPick: true,
        backgroundColor: const Color(0xFFF8FAFC),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          final swot = [
            {'title': 'STRENGTHS', 'rect': const Rect.fromLTWH(-270, -140, 250, 130), 'col': const Color(0xFF059669)},
            {'title': 'WEAKNESSES', 'rect': const Rect.fromLTWH(20, -140, 250, 130), 'col': const Color(0xFFDC2626)},
            {'title': 'OPPORTUNITIES', 'rect': const Rect.fromLTWH(-270, 10, 250, 130), 'col': const Color(0xFF2563EB)},
            {'title': 'THREATS', 'rect': const Rect.fromLTWH(20, 10, 250, 130), 'col': const Color(0xFFD97706)},
          ];

          for (int i = 0; i < swot.length; i++) {
            final s = swot[i];
            final r = s['rect'] as Rect;
            final col = s['col'] as Color;
            final title = s['title'] as String;

            objs.add(VectorArtHelper.rect(
              id: '$projectId-swot-$i',
              layerId: layerId,
              order: order++,
              rect: r,
              strokeColor: col,
              fillColor: col.withValues(alpha: 0.08),
              strokeWidth: 2.0,
              isFilled: true,
            ));

            objs.add(VectorArtHelper.text(
              id: '$projectId-swot-txt-$i',
              layerId: layerId,
              order: order++,
              text: title,
              position: Offset(r.left + 14, r.top + 14),
              fontSize: 12,
              color: col,
              isBold: true,
            ));
          }

          return objs;
        },
      ),

      TemplateModel(
        id: 'biz_value_prop_canvas',
        title: 'Value Proposition Canvas',
        category: 'Business Planning',
        description: 'Customer profile (Gains, Pains, Jobs-to-be-done) mapped directly against Product Value Map.',
        icon: Icons.handshake_rounded,
        difficulty: 'Intermediate',
        tags: const ['Business', 'Value Proposition', 'Customer', 'Product', 'Fit'],
        backgroundColor: const Color(0xFFFFFFFF),
        gridStyle: 'dots',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Product Square (Left)
          objs.add(VectorArtHelper.rect(
            id: '$projectId-product-sq',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-280, -120, 240, 240),
            strokeColor: const Color(0xFF0284C7),
            strokeWidth: 2.5,
          ));

          // Customer Circle (Right)
          objs.add(VectorArtHelper.circle(
            id: '$projectId-customer-circ',
            layerId: layerId,
            order: order++,
            center: const Offset(160, 0),
            radius: 120,
            strokeColor: const Color(0xFF059669),
            strokeWidth: 2.5,
          ));

          return objs;
        },
      ),

      TemplateModel(
        id: 'biz_user_journey_map',
        title: 'End-to-End User Journey Map',
        category: 'Business Planning',
        description: '5-phase customer journey mapping Discovery, Onboarding, Engagement, Value Aha, and Advocacy.',
        icon: Icons.timeline_rounded,
        difficulty: 'Intermediate',
        tags: const ['Business', 'Journey Map', 'UX', 'Customer Experience', 'Phases'],
        backgroundColor: const Color(0xFFFAFAFA),
        gridStyle: 'lines',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          final phases = ['DISCOVERY', 'ONBOARDING', 'CORE USE', 'DELIGHT', 'ADVOCACY'];
          for (int p = 0; p < 5; p++) {
            final x = -290.0 + p * 120.0;
            objs.add(VectorArtHelper.rect(
              id: '$projectId-phase-$p',
              layerId: layerId,
              order: order++,
              rect: Rect.fromLTWH(x, -140, 105, 280),
              strokeColor: const Color(0xFF94A3B8),
              fillColor: Colors.white,
              strokeWidth: 1.5,
              isFilled: true,
            ));

            objs.add(VectorArtHelper.text(
              id: '$projectId-phase-txt-$p',
              layerId: layerId,
              order: order++,
              text: phases[p],
              position: Offset(x + 10, -120),
              fontSize: 10,
              color: const Color(0xFF0F172A),
              isBold: true,
            ));
          }

          return objs;
        },
      ),

      // ---------------- CREATIVE SKETCHES ----------------
      TemplateModel(
        id: 'sketch_storyboard_6panel',
        title: 'Cinematic 6-Panel Storyboard',
        category: 'Creative Sketches',
        description: '16:9 widescreen film storyboard panels complete with camera action lines and dialogue fields.',
        icon: Icons.movie_creation_rounded,
        difficulty: 'Beginner',
        tags: const ['Sketches', 'Storyboard', 'Film', 'Animation', 'Comics'],
        isFeatured: true,
        suggestedUsage: 'Sketch narrative camera keyframes, character staging, and sound effects for video or comic.',
        backgroundColor: const Color(0xFF0F172A),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // 2 Rows x 3 Cols
          for (int r = 0; r < 2; r++) {
            for (int c = 0; c < 3; c++) {
              final x = -290.0 + c * 200.0;
              final y = -140.0 + r * 155.0;
              final idx = r * 3 + c + 1;

              objs.add(VectorArtHelper.rect(
                id: '$projectId-panel-$idx',
                layerId: layerId,
                order: order++,
                rect: Rect.fromLTWH(x, y, 180, 105),
                strokeColor: Colors.white,
                fillColor: const Color(0xFF1E293B),
                strokeWidth: 2.0,
                isFilled: true,
              ));

              objs.add(VectorArtHelper.text(
                id: '$projectId-p-num-$idx',
                layerId: layerId,
                order: order++,
                text: 'SHOT 0$idx',
                position: Offset(x + 8, y + 115),
                fontSize: 11,
                color: const Color(0xFF38BDF8),
                isBold: true,
              ));
            }
          }

          return objs;
        },
      ),

      TemplateModel(
        id: 'sketch_character_turnaround',
        title: 'Character Turnaround Model Sheet',
        category: 'Creative Sketches',
        description: 'Front, three-quarter, side profile, and back pose guidelines with aligned eye/shoulder height rulers.',
        icon: Icons.accessibility_rounded,
        difficulty: 'Intermediate',
        tags: const ['Sketches', 'Character', 'Turnaround', 'Animation', 'Model Sheet'],
        backgroundColor: const Color(0xFFFAFAFA),
        gridStyle: 'lines',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Alignment height guidelines
          final guides = [-120.0, -80.0, -20.0, 60.0, 140.0];
          for (int g = 0; g < guides.length; g++) {
            objs.add(VectorArtHelper.line(
              id: '$projectId-guide-$g',
              layerId: layerId,
              order: order++,
              start: Offset(-280, guides[g]),
              end: Offset(280, guides[g]),
              color: const Color(0xFFCBD5E1),
              strokeWidth: 1.0,
            ));
          }

          final poses = ['FRONT', '3/4 VIEW', 'SIDE', 'BACK'];
          for (int p = 0; p < 4; p++) {
            final x = -260.0 + p * 145.0;
            objs.add(VectorArtHelper.text(
              id: '$projectId-pose-$p',
              layerId: layerId,
              order: order++,
              text: poses[p],
              position: Offset(x + 25, -150),
              fontSize: 11,
              color: const Color(0xFF0F172A),
              isBold: true,
            ));
          }

          return objs;
        },
      ),

      TemplateModel(
        id: 'sketch_mobile_wireframe',
        title: 'Mobile App Wireframing Canvas',
        category: 'Creative Sketches',
        description: 'Three high-fidelity smartphone device bezels ready for sketching user flows and interactive wireframes.',
        icon: Icons.phone_iphone_rounded,
        difficulty: 'Beginner',
        tags: const ['Sketches', 'Wireframe', 'UI UX', 'Mobile', 'App'],
        backgroundColor: const Color(0xFFF8FAFC),
        gridStyle: 'dots',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          for (int d = -1; d <= 1; d++) {
            final x = d * 190.0;
            objs.add(VectorArtHelper.rect(
              id: '$projectId-phone-$d',
              layerId: layerId,
              order: order++,
              rect: Rect.fromLTWH(x - 75, -160, 150, 300),
              strokeColor: const Color(0xFF0F172A),
              fillColor: Colors.white,
              strokeWidth: 2.5,
              isFilled: true,
            ));
          }

          return objs;
        },
      ),

      TemplateModel(
        id: 'sketch_icon_design_grid',
        title: 'Precision Icon Design Grid',
        category: 'Creative Sketches',
        description: 'Standard 24dp/48dp pixel grid with keyline circles, diagonal diagonals, and live square bounds.',
        icon: Icons.interests_rounded,
        difficulty: 'Intermediate',
        tags: const ['Sketches', 'Icons', 'Keylines', 'Vector', 'Pixel Grid'],
        backgroundColor: const Color(0xFFFFFFFF),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Keyline Circle
          objs.add(VectorArtHelper.circle(
            id: '$projectId-keyline-circ',
            layerId: layerId,
            order: order++,
            center: Offset.zero,
            radius: 110,
            strokeColor: const Color(0xFF0284C7),
            strokeWidth: 1.8,
          ));

          // Keyline Square
          objs.add(VectorArtHelper.rect(
            id: '$projectId-keyline-sq',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-95, -95, 190, 190),
            strokeColor: const Color(0xFF0284C7),
            strokeWidth: 1.8,
          ));

          return objs;
        },
      ),

      // ---------------- SOCIAL MEDIA ART ----------------
      TemplateModel(
        id: 'social_instagram_carousel',
        title: 'Seamless 3-Slide Social Carousel',
        category: 'Social Media Art',
        description: 'Triple connected slide canvas with boundary alignment markers for creating seamless Instagram carousels.',
        icon: Icons.view_carousel_rounded,
        difficulty: 'Beginner',
        tags: const ['Social Media', 'Instagram', 'Carousel', 'Slides', 'Content'],
        isFeatured: true,
        suggestedUsage: 'Draw graphics that cross slide seams so they appear continuous when swiped on mobile.',
        backgroundColor: const Color(0xFFFBFBFB),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          for (int s = -1; s <= 1; s++) {
            final x = s * 190.0;
            objs.add(VectorArtHelper.rect(
              id: '$projectId-slide-$s',
              layerId: layerId,
              order: order++,
              rect: Rect.fromLTWH(x - 90, -140, 180, 260),
              strokeColor: const Color(0xFFE2E8F0),
              fillColor: Colors.white,
              strokeWidth: 2.0,
              isFilled: true,
            ));
          }

          return objs;
        },
      ),

      TemplateModel(
        id: 'social_story_aesthetic_collage',
        title: 'Editorial Story Aesthetic Collage',
        category: 'Social Media Art',
        description: '9:16 vertical story template with asymmetric polaroid frames, washi tape accents, and caption lines.',
        icon: Icons.photo_library_rounded,
        difficulty: 'Beginner',
        tags: const ['Social Media', 'Story', 'Collage', 'Aesthetic', 'Polaroid'],
        backgroundColor: const Color(0xFFFFFBEB),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Polaroid 1
          objs.add(VectorArtHelper.rect(
            id: '$projectId-polaroid-1',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-160, -120, 180, 220),
            strokeColor: const Color(0xFF1E293B),
            fillColor: Colors.white,
            strokeWidth: 2.0,
            isFilled: true,
            rotation: -0.06,
          ));

          return objs;
        },
      ),

      TemplateModel(
        id: 'social_youtube_banner',
        title: 'Video Banner Safe Zones',
        category: 'Social Media Art',
        description: 'Standard 16:9 banner canvas outlining TV, Desktop, Tablet, and Mobile safe center zones.',
        icon: Icons.smart_display_rounded,
        difficulty: 'Intermediate',
        tags: const ['Social Media', 'YouTube', 'Banner', 'Safe Area', 'Header'],
        backgroundColor: const Color(0xFF0F172A),
        gridStyle: 'lines',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Outer Canvas
          objs.add(VectorArtHelper.rect(
            id: '$projectId-yt-full',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-300, -150, 600, 300),
            strokeColor: const Color(0xFF334155),
            fillColor: const Color(0xFF1E293B),
            strokeWidth: 2.0,
            isFilled: true,
          ));

          // Mobile Safe Zone
          objs.add(VectorArtHelper.rect(
            id: '$projectId-yt-mobile',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-160, -40, 320, 80),
            strokeColor: const Color(0xFF38BDF8),
            strokeWidth: 2.0,
          ));

          return objs;
        },
      ),

      TemplateModel(
        id: 'social_moodboard_grid',
        title: 'Fashion Mood Board Grid',
        category: 'Social Media Art',
        description: 'Multi-pane mosaic grid for assembling texture references, font pairing tests, and color palettes.',
        icon: Icons.dashboard_rounded,
        difficulty: 'Beginner',
        tags: const ['Social Media', 'Moodboard', 'Fashion', 'Aesthetic', 'Textures'],
        backgroundColor: const Color(0xFFFAFAFA),
        gridStyle: 'dots',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Main Hero Tile
          objs.add(VectorArtHelper.rect(
            id: '$projectId-mb-hero',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-260, -140, 240, 280),
            strokeColor: const Color(0xFF1E293B),
            fillColor: const Color(0xFFF1F5F9),
            strokeWidth: 2.0,
            isFilled: true,
          ));

          return objs;
        },
      ),

      // ---------------- EDUCATIONAL DIAGRAMS ----------------
      TemplateModel(
        id: 'edu_solar_system',
        title: 'Solar System Planetarium',
        category: 'Educational Diagrams',
        description: 'Accurate orbital ellipse paths mapping inner terrestrial planets and outer gas giants around the Sun.',
        icon: Icons.public_rounded,
        difficulty: 'Intermediate',
        tags: const ['Educational', 'Solar System', 'Planets', 'Science', 'Astronomy'],
        isFeatured: true,
        suggestedUsage: 'Annotate planetary diameters, orbital velocity, and moon systems on each orbital track.',
        backgroundColor: const Color(0xFF070B14),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Center Sun
          objs.add(VectorArtHelper.circle(
            id: '$projectId-sun',
            layerId: layerId,
            order: order++,
            center: const Offset(-200, 0),
            radius: 50,
            strokeColor: const Color(0xFFF59E0B),
            fillColor: const Color(0xFFFEF3C7),
            strokeWidth: 3.0,
            isFilled: true,
          ));

          // Orbit rings
          for (int o = 1; o <= 5; o++) {
            objs.add(VectorArtHelper.circle(
              id: '$projectId-orbit-$o',
              layerId: layerId,
              order: order++,
              center: const Offset(-200, 0),
              radius: 50.0 + o * 75.0,
              strokeColor: const Color(0xFF38BDF8).withValues(alpha: 0.35),
              strokeWidth: 1.2,
            ));
          }

          return objs;
        },
      ),

      TemplateModel(
        id: 'edu_water_cycle',
        title: 'Hydrological Water Cycle',
        category: 'Educational Diagrams',
        description: 'Complete environmental diagram charting Evaporation, Condensation, Precipitation, and Ground Runoff.',
        icon: Icons.cloud_sync_rounded,
        difficulty: 'Beginner',
        tags: const ['Educational', 'Water Cycle', 'Earth Science', 'Weather', 'Ecology'],
        backgroundColor: const Color(0xFFF0FDF4),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          // Cloud
          objs.add(VectorArtHelper.circle(
            id: '$projectId-cloud-1',
            layerId: layerId,
            order: order++,
            center: const Offset(-80, -110),
            radius: 45,
            strokeColor: const Color(0xFF0284C7),
            fillColor: const Color(0xFFBAE6FD),
            strokeWidth: 2.5,
            isFilled: true,
          ));

          // Mountain & Ocean Surface
          objs.add(VectorArtHelper.polygon(
            id: '$projectId-mt-edu',
            layerId: layerId,
            order: order++,
            center: const Offset(140, 20),
            radius: 140,
            sides: 3,
            strokeColor: const Color(0xFF065F46),
            fillColor: const Color(0xFFA7F3D0),
            strokeWidth: 2.5,
            isFilled: true,
          ));

          return objs;
        },
      ),

      TemplateModel(
        id: 'edu_human_brain_anatomy',
        title: 'Brain Hemispheres & Lobes',
        category: 'Educational Diagrams',
        description: 'Sagittal view diagram delineating Frontal, Parietal, Occipital, and Temporal cognitive regions.',
        icon: Icons.psychology_alt_rounded,
        difficulty: 'Intermediate',
        tags: const ['Educational', 'Brain', 'Anatomy', 'Biology', 'Medicine'],
        backgroundColor: const Color(0xFFFBFBFB),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          objs.add(VectorArtHelper.circle(
            id: '$projectId-cortex',
            layerId: layerId,
            order: order++,
            center: Offset.zero,
            radius: 125,
            strokeColor: const Color(0xFFE11D48),
            fillColor: const Color(0xFFFEE2E2),
            strokeWidth: 3.0,
            isFilled: true,
          ));

          return objs;
        },
      ),

      TemplateModel(
        id: 'edu_carbon_cycle',
        title: 'Biogeochemical Carbon Cycle',
        category: 'Educational Diagrams',
        description: 'Atmospheric carbon flow mapping photosynthesis capture, plant respiration, and soil sequestration.',
        icon: Icons.eco_rounded,
        difficulty: 'Intermediate',
        tags: const ['Educational', 'Carbon Cycle', 'Ecology', 'Biology', 'Atmosphere'],
        backgroundColor: const Color(0xFFF7FEE7),
        gridStyle: 'none',
        buildObjects: (projectId, layerId) {
          final objs = <CanvasObject>[];
          int order = 0;

          objs.add(VectorArtHelper.rect(
            id: '$projectId-atmosphere',
            layerId: layerId,
            order: order++,
            rect: const Rect.fromLTWH(-280, -160, 560, 80),
            strokeColor: const Color(0xFF0284C7),
            fillColor: const Color(0xFFE0F2FE),
            strokeWidth: 2.0,
            isFilled: true,
          ));

          return objs;
        },
      ),
    ];
  }
}
