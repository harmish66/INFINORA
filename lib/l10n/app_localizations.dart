import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('gu'),
    Locale('hi'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Infinora'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Create Beyond Boundaries'**
  String get appTagline;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'Infinite canvas drawing, sketching, and note-taking workspace.'**
  String get appDescription;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Infinite Creativity'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Explore an unbounded canvas with seamless zoom and pan to capture your biggest ideas.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Draw Without Limits'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Sketch with precision using versatile pens, brushes, markers, highlighters, and shapes.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Zoom Into Every Detail'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Zoom in thousands of times to craft intricate details or pull back for the complete picture.'**
  String get onboardingDesc3;

  /// No description provided for @onboardingTitle4.
  ///
  /// In en, this message translates to:
  /// **'Your Ideas, Always Saved'**
  String get onboardingTitle4;

  /// No description provided for @onboardingDesc4.
  ///
  /// In en, this message translates to:
  /// **'Every stroke and object is safely stored locally on your device with complete offline access.'**
  String get onboardingDesc4;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @welcomeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Infinora'**
  String get welcomeGreeting;

  /// No description provided for @searchProjects.
  ///
  /// In en, this message translates to:
  /// **'Search projects...'**
  String get searchProjects;

  /// No description provided for @createNewCanvas.
  ///
  /// In en, this message translates to:
  /// **'Create New Canvas'**
  String get createNewCanvas;

  /// No description provided for @continueRecent.
  ///
  /// In en, this message translates to:
  /// **'Continue Recent Project'**
  String get continueRecent;

  /// No description provided for @importImage.
  ///
  /// In en, this message translates to:
  /// **'Import Image'**
  String get importImage;

  /// No description provided for @openTemplates.
  ///
  /// In en, this message translates to:
  /// **'Open Templates'**
  String get openTemplates;

  /// No description provided for @recentProjects.
  ///
  /// In en, this message translates to:
  /// **'Recent Projects'**
  String get recentProjects;

  /// No description provided for @myDrawings.
  ///
  /// In en, this message translates to:
  /// **'My Drawings'**
  String get myDrawings;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @archived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archived;

  /// No description provided for @noProjectsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Projects Yet'**
  String get noProjectsTitle;

  /// No description provided for @noProjectsDesc.
  ///
  /// In en, this message translates to:
  /// **'Create your first canvas or choose from starter templates to begin sketching.'**
  String get noProjectsDesc;

  /// No description provided for @noFavoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'No Favorite Projects'**
  String get noFavoritesTitle;

  /// No description provided for @noFavoritesDesc.
  ///
  /// In en, this message translates to:
  /// **'Star your key projects to access them quickly here.'**
  String get noFavoritesDesc;

  /// No description provided for @noArchivedTitle.
  ///
  /// In en, this message translates to:
  /// **'No Archived Projects'**
  String get noArchivedTitle;

  /// No description provided for @noArchivedDesc.
  ///
  /// In en, this message translates to:
  /// **'Archived projects will appear here.'**
  String get noArchivedDesc;

  /// No description provided for @lastModified.
  ///
  /// In en, this message translates to:
  /// **'Last modified'**
  String get lastModified;

  /// No description provided for @dimensions.
  ///
  /// In en, this message translates to:
  /// **'Dimensions'**
  String get dimensions;

  /// No description provided for @infiniteCanvas.
  ///
  /// In en, this message translates to:
  /// **'Infinite Canvas'**
  String get infiniteCanvas;

  /// No description provided for @moreOptions.
  ///
  /// In en, this message translates to:
  /// **'More Options'**
  String get moreOptions;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @duplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get duplicate;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @unfavorite.
  ///
  /// In en, this message translates to:
  /// **'Unfavorite'**
  String get unfavorite;

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @unarchive.
  ///
  /// In en, this message translates to:
  /// **'Unarchive'**
  String get unarchive;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @projectDetails.
  ///
  /// In en, this message translates to:
  /// **'Project Details'**
  String get projectDetails;

  /// No description provided for @newCanvasTitle.
  ///
  /// In en, this message translates to:
  /// **'New Canvas'**
  String get newCanvasTitle;

  /// No description provided for @canvasPresets.
  ///
  /// In en, this message translates to:
  /// **'Canvas Presets'**
  String get canvasPresets;

  /// No description provided for @presetSquare.
  ///
  /// In en, this message translates to:
  /// **'Square (1080 x 1080)'**
  String get presetSquare;

  /// No description provided for @presetPortrait.
  ///
  /// In en, this message translates to:
  /// **'Portrait (1080 x 1920)'**
  String get presetPortrait;

  /// No description provided for @presetLandscape.
  ///
  /// In en, this message translates to:
  /// **'Landscape (1920 x 1080)'**
  String get presetLandscape;

  /// No description provided for @presetA4Portrait.
  ///
  /// In en, this message translates to:
  /// **'A4 Portrait (1240 x 1754)'**
  String get presetA4Portrait;

  /// No description provided for @presetA4Landscape.
  ///
  /// In en, this message translates to:
  /// **'A4 Landscape (1754 x 1240)'**
  String get presetA4Landscape;

  /// No description provided for @presetInfinite.
  ///
  /// In en, this message translates to:
  /// **'Infinite Workspace'**
  String get presetInfinite;

  /// No description provided for @presetCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom Dimensions'**
  String get presetCustom;

  /// No description provided for @projectName.
  ///
  /// In en, this message translates to:
  /// **'Project Name'**
  String get projectName;

  /// No description provided for @enterProjectName.
  ///
  /// In en, this message translates to:
  /// **'Enter project name'**
  String get enterProjectName;

  /// No description provided for @width.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get width;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @backgroundColor.
  ///
  /// In en, this message translates to:
  /// **'Background Color'**
  String get backgroundColor;

  /// No description provided for @transparentBackground.
  ///
  /// In en, this message translates to:
  /// **'Transparent Background'**
  String get transparentBackground;

  /// No description provided for @showGrid.
  ///
  /// In en, this message translates to:
  /// **'Show Grid'**
  String get showGrid;

  /// No description provided for @gridStyle.
  ///
  /// In en, this message translates to:
  /// **'Grid Style'**
  String get gridStyle;

  /// No description provided for @gridDots.
  ///
  /// In en, this message translates to:
  /// **'Dots'**
  String get gridDots;

  /// No description provided for @gridLines.
  ///
  /// In en, this message translates to:
  /// **'Lines'**
  String get gridLines;

  /// No description provided for @gridCross.
  ///
  /// In en, this message translates to:
  /// **'Crosses'**
  String get gridCross;

  /// No description provided for @gridIsometric.
  ///
  /// In en, this message translates to:
  /// **'Isometric'**
  String get gridIsometric;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create Canvas'**
  String get create;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @pen.
  ///
  /// In en, this message translates to:
  /// **'Pen'**
  String get pen;

  /// No description provided for @pencil.
  ///
  /// In en, this message translates to:
  /// **'Pencil'**
  String get pencil;

  /// No description provided for @brush.
  ///
  /// In en, this message translates to:
  /// **'Brush'**
  String get brush;

  /// No description provided for @marker.
  ///
  /// In en, this message translates to:
  /// **'Marker'**
  String get marker;

  /// No description provided for @highlighter.
  ///
  /// In en, this message translates to:
  /// **'Highlighter'**
  String get highlighter;

  /// No description provided for @eraser.
  ///
  /// In en, this message translates to:
  /// **'Eraser'**
  String get eraser;

  /// No description provided for @laserPointer.
  ///
  /// In en, this message translates to:
  /// **'Laser Pointer'**
  String get laserPointer;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @panTool.
  ///
  /// In en, this message translates to:
  /// **'Pan'**
  String get panTool;

  /// No description provided for @line.
  ///
  /// In en, this message translates to:
  /// **'Line'**
  String get line;

  /// No description provided for @arrow.
  ///
  /// In en, this message translates to:
  /// **'Arrow'**
  String get arrow;

  /// No description provided for @rectangle.
  ///
  /// In en, this message translates to:
  /// **'Rectangle'**
  String get rectangle;

  /// No description provided for @circle.
  ///
  /// In en, this message translates to:
  /// **'Circle'**
  String get circle;

  /// No description provided for @triangle.
  ///
  /// In en, this message translates to:
  /// **'Triangle'**
  String get triangle;

  /// No description provided for @polygon.
  ///
  /// In en, this message translates to:
  /// **'Polygon'**
  String get polygon;

  /// No description provided for @star.
  ///
  /// In en, this message translates to:
  /// **'Star'**
  String get star;

  /// No description provided for @text.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get text;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

  /// No description provided for @sticker.
  ///
  /// In en, this message translates to:
  /// **'Sticker'**
  String get sticker;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @brushSize.
  ///
  /// In en, this message translates to:
  /// **'Brush Size'**
  String get brushSize;

  /// No description provided for @opacity.
  ///
  /// In en, this message translates to:
  /// **'Opacity'**
  String get opacity;

  /// No description provided for @smoothing.
  ///
  /// In en, this message translates to:
  /// **'Smoothing'**
  String get smoothing;

  /// No description provided for @strokePreview.
  ///
  /// In en, this message translates to:
  /// **'Stroke Preview'**
  String get strokePreview;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @redo.
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get redo;

  /// No description provided for @zoomFit.
  ///
  /// In en, this message translates to:
  /// **'Fit to Screen'**
  String get zoomFit;

  /// No description provided for @zoomSelection.
  ///
  /// In en, this message translates to:
  /// **'Zoom to Selection'**
  String get zoomSelection;

  /// No description provided for @resetCamera.
  ///
  /// In en, this message translates to:
  /// **'Reset Camera'**
  String get resetCamera;

  /// No description provided for @minimap.
  ///
  /// In en, this message translates to:
  /// **'Minimap'**
  String get minimap;

  /// No description provided for @layers.
  ///
  /// In en, this message translates to:
  /// **'Layers'**
  String get layers;

  /// No description provided for @addLayer.
  ///
  /// In en, this message translates to:
  /// **'Add Layer'**
  String get addLayer;

  /// No description provided for @deleteLayer.
  ///
  /// In en, this message translates to:
  /// **'Delete Layer'**
  String get deleteLayer;

  /// No description provided for @renameLayer.
  ///
  /// In en, this message translates to:
  /// **'Rename Layer'**
  String get renameLayer;

  /// No description provided for @hideLayer.
  ///
  /// In en, this message translates to:
  /// **'Hide Layer'**
  String get hideLayer;

  /// No description provided for @showLayer.
  ///
  /// In en, this message translates to:
  /// **'Show Layer'**
  String get showLayer;

  /// No description provided for @lockLayer.
  ///
  /// In en, this message translates to:
  /// **'Lock Layer'**
  String get lockLayer;

  /// No description provided for @unlockLayer.
  ///
  /// In en, this message translates to:
  /// **'Unlock Layer'**
  String get unlockLayer;

  /// No description provided for @duplicateLayer.
  ///
  /// In en, this message translates to:
  /// **'Duplicate Layer'**
  String get duplicateLayer;

  /// No description provided for @layerOpacity.
  ///
  /// In en, this message translates to:
  /// **'Layer Opacity'**
  String get layerOpacity;

  /// No description provided for @activeLayer.
  ///
  /// In en, this message translates to:
  /// **'Active Layer'**
  String get activeLayer;

  /// No description provided for @moveUp.
  ///
  /// In en, this message translates to:
  /// **'Move Up'**
  String get moveUp;

  /// No description provided for @moveDown.
  ///
  /// In en, this message translates to:
  /// **'Move Down'**
  String get moveDown;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @paste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get paste;

  /// No description provided for @deleteObject.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteObject;

  /// No description provided for @group.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group;

  /// No description provided for @ungroup.
  ///
  /// In en, this message translates to:
  /// **'Ungroup'**
  String get ungroup;

  /// No description provided for @font.
  ///
  /// In en, this message translates to:
  /// **'Font'**
  String get font;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// No description provided for @bold.
  ///
  /// In en, this message translates to:
  /// **'Bold'**
  String get bold;

  /// No description provided for @italic.
  ///
  /// In en, this message translates to:
  /// **'Italic'**
  String get italic;

  /// No description provided for @underline.
  ///
  /// In en, this message translates to:
  /// **'Underline'**
  String get underline;

  /// No description provided for @alignLeft.
  ///
  /// In en, this message translates to:
  /// **'Align Left'**
  String get alignLeft;

  /// No description provided for @alignCenter.
  ///
  /// In en, this message translates to:
  /// **'Align Center'**
  String get alignCenter;

  /// No description provided for @alignRight.
  ///
  /// In en, this message translates to:
  /// **'Align Right'**
  String get alignRight;

  /// No description provided for @fillColor.
  ///
  /// In en, this message translates to:
  /// **'Fill Color'**
  String get fillColor;

  /// No description provided for @strokeColor.
  ///
  /// In en, this message translates to:
  /// **'Stroke Color'**
  String get strokeColor;

  /// No description provided for @strokeWidth.
  ///
  /// In en, this message translates to:
  /// **'Stroke Width'**
  String get strokeWidth;

  /// No description provided for @autosaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get autosaved;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @errorSaving.
  ///
  /// In en, this message translates to:
  /// **'Error saving'**
  String get errorSaving;

  /// No description provided for @templatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Starter Templates'**
  String get templatesTitle;

  /// No description provided for @categoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoryAll;

  /// No description provided for @categoryMindMap.
  ///
  /// In en, this message translates to:
  /// **'Mind Maps'**
  String get categoryMindMap;

  /// No description provided for @categoryNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get categoryNotes;

  /// No description provided for @categoryBrainstorm.
  ///
  /// In en, this message translates to:
  /// **'Brainstorming'**
  String get categoryBrainstorm;

  /// No description provided for @categorySketch.
  ///
  /// In en, this message translates to:
  /// **'Sketching'**
  String get categorySketch;

  /// No description provided for @categoryPlanning.
  ///
  /// In en, this message translates to:
  /// **'Planning'**
  String get categoryPlanning;

  /// No description provided for @categoryEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get categoryEducation;

  /// No description provided for @categoryCreative.
  ///
  /// In en, this message translates to:
  /// **'Creative Art'**
  String get categoryCreative;

  /// No description provided for @useTemplate.
  ///
  /// In en, this message translates to:
  /// **'Use Template'**
  String get useTemplate;

  /// No description provided for @previewTemplate.
  ///
  /// In en, this message translates to:
  /// **'Preview Template'**
  String get previewTemplate;

  /// No description provided for @exportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Canvas'**
  String get exportTitle;

  /// No description provided for @formatPng.
  ///
  /// In en, this message translates to:
  /// **'PNG Image'**
  String get formatPng;

  /// No description provided for @formatJpeg.
  ///
  /// In en, this message translates to:
  /// **'JPEG Image'**
  String get formatJpeg;

  /// No description provided for @formatPdf.
  ///
  /// In en, this message translates to:
  /// **'PDF Document'**
  String get formatPdf;

  /// No description provided for @exportBounds.
  ///
  /// In en, this message translates to:
  /// **'Export Bounds'**
  String get exportBounds;

  /// No description provided for @boundsArtwork.
  ///
  /// In en, this message translates to:
  /// **'Complete Artwork'**
  String get boundsArtwork;

  /// No description provided for @boundsViewport.
  ///
  /// In en, this message translates to:
  /// **'Current Viewport'**
  String get boundsViewport;

  /// No description provided for @boundsCustom.
  ///
  /// In en, this message translates to:
  /// **'Selected Region'**
  String get boundsCustom;

  /// No description provided for @resolution.
  ///
  /// In en, this message translates to:
  /// **'Resolution'**
  String get resolution;

  /// No description provided for @scale1x.
  ///
  /// In en, this message translates to:
  /// **'Standard (1x)'**
  String get scale1x;

  /// No description provided for @scale2x.
  ///
  /// In en, this message translates to:
  /// **'High (2x)'**
  String get scale2x;

  /// No description provided for @scale3x.
  ///
  /// In en, this message translates to:
  /// **'Ultra (3x)'**
  String get scale3x;

  /// No description provided for @exportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export completed successfully'**
  String get exportSuccess;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to export project'**
  String get exportFailed;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @saveToDevice.
  ///
  /// In en, this message translates to:
  /// **'Save to Device'**
  String get saveToDevice;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @sectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get sectionAppearance;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeMode;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get themeDark;

  /// No description provided for @sectionLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get sectionLanguage;

  /// No description provided for @sectionCanvas.
  ///
  /// In en, this message translates to:
  /// **'Canvas Preferences'**
  String get sectionCanvas;

  /// No description provided for @defaultBrushSize.
  ///
  /// In en, this message translates to:
  /// **'Default Brush Size'**
  String get defaultBrushSize;

  /// No description provided for @defaultColor.
  ///
  /// In en, this message translates to:
  /// **'Default Stroke Color'**
  String get defaultColor;

  /// No description provided for @gestureSensitivity.
  ///
  /// In en, this message translates to:
  /// **'Gesture Sensitivity'**
  String get gestureSensitivity;

  /// No description provided for @sectionStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage & Data'**
  String get sectionStorage;

  /// No description provided for @storageUsage.
  ///
  /// In en, this message translates to:
  /// **'Storage Used'**
  String get storageUsage;

  /// No description provided for @clearTempFiles.
  ///
  /// In en, this message translates to:
  /// **'Clear Temporary Cache'**
  String get clearTempFiles;

  /// No description provided for @backupProjects.
  ///
  /// In en, this message translates to:
  /// **'Backup Projects'**
  String get backupProjects;

  /// No description provided for @restoreProjects.
  ///
  /// In en, this message translates to:
  /// **'Restore Projects'**
  String get restoreProjects;

  /// No description provided for @sectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get sectionAbout;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get appVersion;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Project'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this project? This action cannot be undone.'**
  String get confirmDeleteMessage;

  /// No description provided for @confirmDiscardTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard Changes'**
  String get confirmDiscardTitle;

  /// No description provided for @confirmDiscardMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to discard your unsaved changes?'**
  String get confirmDiscardMessage;

  /// No description provided for @confirmClearCacheTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get confirmClearCacheTitle;

  /// No description provided for @confirmClearCacheMessage.
  ///
  /// In en, this message translates to:
  /// **'This will remove temporary export files. Your projects remain safe.'**
  String get confirmClearCacheMessage;

  /// No description provided for @confirmAction.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmAction;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get languageHindi;

  /// No description provided for @languageGujarati.
  ///
  /// In en, this message translates to:
  /// **'Gujarati'**
  String get languageGujarati;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get languageSpanish;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languageFrench;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'en',
    'es',
    'fr',
    'gu',
    'hi',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
