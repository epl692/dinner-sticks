import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
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
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// The application title.
  ///
  /// In en, this message translates to:
  /// **'Dinner Sticks'**
  String get appTitle;

  /// Semantic label for the pool-name chip on the home screen.
  ///
  /// In en, this message translates to:
  /// **'Active pool: {name}. Tap to switch.'**
  String activePoolLabel(String name);

  /// Tooltip for the start-new-week icon button.
  ///
  /// In en, this message translates to:
  /// **'Start new week'**
  String get startNewWeekTooltip;

  /// Tooltip / semantic label for the pool management icon button.
  ///
  /// In en, this message translates to:
  /// **'Manage meal ideas'**
  String get manageMealIdeasTooltip;

  /// Tooltip / semantic label for the random-pick FAB.
  ///
  /// In en, this message translates to:
  /// **'Pick a random meal from this week\'s plan'**
  String get randomPickTooltip;

  /// Title of the confirmation dialog when a bin already exists.
  ///
  /// In en, this message translates to:
  /// **'Replace this week\'s meals?'**
  String get replaceWeekMealsTitle;

  /// Body text of the replace-week-meals confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'You already have meals selected. Starting over will replace them.'**
  String get replaceWeekMealsContent;

  /// Button to dismiss the replace-week-meals dialog without changing.
  ///
  /// In en, this message translates to:
  /// **'Keep current'**
  String get keepCurrentLabel;

  /// Button to confirm replacing the current bin.
  ///
  /// In en, this message translates to:
  /// **'Start over'**
  String get startOverLabel;

  /// Action label for replacing a bin stick.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get replaceLabel;

  /// Action label for removing a bin stick.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeLabel;

  /// Generic cancel button label.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelLabel;

  /// Generic confirm button label.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmLabel;

  /// Option to pick a random replacement stick.
  ///
  /// In en, this message translates to:
  /// **'Random'**
  String get randomLabel;

  /// Option to pick a specific replacement stick.
  ///
  /// In en, this message translates to:
  /// **'Pick one'**
  String get pickOneLabel;

  /// Shown in the pick-one sheet when no replacements exist.
  ///
  /// In en, this message translates to:
  /// **'No other meal ideas available.'**
  String get noOtherMealsAvailable;

  /// Title of the confirmation dialog when removing a stick from the bin.
  ///
  /// In en, this message translates to:
  /// **'Remove from this week?'**
  String get removeFromWeekTitle;

  /// Body of the remove-from-week confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'{name} will be removed from this week\'s plan but stay in your pool.'**
  String removeStickMessage(String name);

  /// Title of the WeeklySelectionScreen app bar.
  ///
  /// In en, this message translates to:
  /// **'Select this week\'s meals'**
  String get selectWeekMealsTitle;

  /// Tooltip on the discard button in the weekly-selection list.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discardTooltip;

  /// Semantic label for the discard button in WeeklySelectionScreen.
  ///
  /// In en, this message translates to:
  /// **'Discard {name} and draw a replacement'**
  String discardStickLabel(String name);

  /// Notice shown when the pool has fewer than 5 sticks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Only 1 meal available in this pool.} other{Only {count} meals available in this pool.}}'**
  String limitedMealsMessage(int count);

  /// App-bar title for the pool management screen.
  ///
  /// In en, this message translates to:
  /// **'Meal Ideas: {name}'**
  String mealIdeasTitle(String name);

  /// Shown when a pool has no sticks.
  ///
  /// In en, this message translates to:
  /// **'No meal ideas yet.\nTap + to add one.'**
  String get emptyPoolMessage;

  /// Tooltip for the add-meal-idea FAB.
  ///
  /// In en, this message translates to:
  /// **'Add meal idea'**
  String get addMealIdeaTooltip;

  /// Title of the delete-meal-idea confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Delete meal idea'**
  String get deleteMealIdeaTitle;

  /// Body of the delete-meal-idea confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{name}\" from this pool?'**
  String deleteMealIdeaMessage(String name);

  /// Generic edit action label.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editLabel;

  /// Generic delete action label.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteLabel;

  /// App-bar title for the pool-switcher screen.
  ///
  /// In en, this message translates to:
  /// **'Switch pool'**
  String get switchPoolTitle;

  /// Tooltip for the add-pool FAB.
  ///
  /// In en, this message translates to:
  /// **'Add pool'**
  String get addPoolTooltip;

  /// Title shown above the new-pool text field.
  ///
  /// In en, this message translates to:
  /// **'New pool'**
  String get newPoolTitle;

  /// Placeholder text for the pool-name text field.
  ///
  /// In en, this message translates to:
  /// **'e.g. Breakfast'**
  String get poolNameHint;

  /// Button to confirm creating a new pool.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createLabel;

  /// Headline shown on the empty-bin prompt.
  ///
  /// In en, this message translates to:
  /// **'No meals planned this week'**
  String get emptyBinMessage;

  /// CTA button text on the empty-bin prompt.
  ///
  /// In en, this message translates to:
  /// **'Select this week\'s meals'**
  String get selectWeekMealsButton;

  /// Semantic hint when a bin stick is highlighted.
  ///
  /// In en, this message translates to:
  /// **'selected for tonight'**
  String get stickSelectedHint;

  /// Semantic hint for a bin stick that is not highlighted.
  ///
  /// In en, this message translates to:
  /// **'in this week\'s plan'**
  String get stickInPlanHint;

  /// Semantic label for the Done button on a highlighted bin stick.
  ///
  /// In en, this message translates to:
  /// **'Mark {name} as done and remove from this week\'s plan'**
  String markStickDoneLabel(String name);

  /// Label on the Done button for a highlighted bin stick.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneLabel;

  /// Generic error display.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorMessage(String error);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
