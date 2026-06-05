// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Dinner Sticks';

  @override
  String activePoolLabel(String name) {
    return 'Active pool: $name. Tap to switch.';
  }

  @override
  String get startNewWeekTooltip => 'Start new week';

  @override
  String get manageMealIdeasTooltip => 'Manage meal ideas';

  @override
  String get randomPickTooltip => 'Pick a random meal from this week\'s plan';

  @override
  String get replaceWeekMealsTitle => 'Replace this week\'s meals?';

  @override
  String get replaceWeekMealsContent =>
      'You already have meals selected. Starting over will replace them.';

  @override
  String get keepCurrentLabel => 'Keep current';

  @override
  String get startOverLabel => 'Start over';

  @override
  String get replaceLabel => 'Replace';

  @override
  String get removeLabel => 'Remove';

  @override
  String get cancelLabel => 'Cancel';

  @override
  String get confirmLabel => 'Confirm';

  @override
  String get randomLabel => 'Random';

  @override
  String get pickOneLabel => 'Pick one';

  @override
  String get noOtherMealsAvailable => 'No other meal ideas available.';

  @override
  String get removeFromWeekTitle => 'Remove from this week?';

  @override
  String removeStickMessage(String name) {
    return '$name will be removed from this week\'s plan but stay in your pool.';
  }

  @override
  String get selectWeekMealsTitle => 'Select this week\'s meals';

  @override
  String get discardTooltip => 'Discard';

  @override
  String discardStickLabel(String name) {
    return 'Discard $name and draw a replacement';
  }

  @override
  String limitedMealsMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Only $count meals available in this pool.',
      one: 'Only 1 meal available in this pool.',
    );
    return '$_temp0';
  }

  @override
  String mealIdeasTitle(String name) {
    return 'Meal Ideas: $name';
  }

  @override
  String get emptyPoolMessage => 'No meal ideas yet.\nTap + to add one.';

  @override
  String get addMealIdeaTooltip => 'Add meal idea';

  @override
  String get deleteMealIdeaTitle => 'Delete meal idea';

  @override
  String deleteMealIdeaMessage(String name) {
    return 'Remove \"$name\" from this pool?';
  }

  @override
  String get editLabel => 'Edit';

  @override
  String get deleteLabel => 'Delete';

  @override
  String get switchPoolTitle => 'Switch pool';

  @override
  String get addPoolTooltip => 'Add pool';

  @override
  String get newPoolTitle => 'New pool';

  @override
  String get poolNameHint => 'e.g. Breakfast';

  @override
  String get createLabel => 'Create';

  @override
  String get emptyBinMessage => 'No meals planned this week';

  @override
  String get selectWeekMealsButton => 'Select this week\'s meals';

  @override
  String get stickSelectedHint => 'selected for tonight';

  @override
  String get stickInPlanHint => 'in this week\'s plan';

  @override
  String markStickDoneLabel(String name) {
    return 'Mark $name as done and remove from this week\'s plan';
  }

  @override
  String get doneLabel => 'Done';

  @override
  String errorMessage(String error) {
    return 'Error: $error';
  }
}
