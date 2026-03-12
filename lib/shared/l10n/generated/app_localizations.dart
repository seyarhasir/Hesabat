import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_ps.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
    Locale('en'),
    Locale('fa'),
    Locale('ps')
  ];

  /// The app name
  ///
  /// In en, this message translates to:
  /// **'Hesabat'**
  String get appName;

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Phone number input label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// OTP input label
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOtp;

  /// Verify button
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// Resend OTP button
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// Language selection
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// English language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Dari language
  ///
  /// In en, this message translates to:
  /// **'Dari'**
  String get dari;

  /// Pashto language
  ///
  /// In en, this message translates to:
  /// **'Pashto'**
  String get pashto;

  /// Shop name input
  ///
  /// In en, this message translates to:
  /// **'Shop Name'**
  String get shopName;

  /// Shop type selection
  ///
  /// In en, this message translates to:
  /// **'Shop Type'**
  String get shopType;

  /// Grocery shop type
  ///
  /// In en, this message translates to:
  /// **'Grocery'**
  String get grocery;

  /// Pharmacy shop type
  ///
  /// In en, this message translates to:
  /// **'Pharmacy'**
  String get pharmacy;

  /// Hardware shop type
  ///
  /// In en, this message translates to:
  /// **'Hardware'**
  String get hardware;

  /// Electronics shop type
  ///
  /// In en, this message translates to:
  /// **'Electronics'**
  String get electronics;

  /// Clothing shop type
  ///
  /// In en, this message translates to:
  /// **'Clothing'**
  String get clothing;

  /// Bakery shop type
  ///
  /// In en, this message translates to:
  /// **'Bakery'**
  String get bakery;

  /// Restaurant shop type
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get restaurant;

  /// General shop type
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// Currency selection
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// AFN currency
  ///
  /// In en, this message translates to:
  /// **'Afghan Afghani'**
  String get afn;

  /// USD currency
  ///
  /// In en, this message translates to:
  /// **'US Dollar'**
  String get usd;

  /// PKR currency
  ///
  /// In en, this message translates to:
  /// **'Pakistani Rupee'**
  String get pkr;

  /// Continue button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Skip button
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Edit button
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Add button
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Search hint
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No results message
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// Error title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Success title
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Offline status
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// Online status
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// Syncing status
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get syncing;
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
      <String>['en', 'fa', 'ps'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
    case 'ps':
      return AppLocalizationsPs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
