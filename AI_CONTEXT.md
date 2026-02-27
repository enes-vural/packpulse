## AI Context – Architecture & Style Guide

This guide describes your current Flutter project’s architecture and coding style so you can extend it consistently. Save this file as `AI_CONTEXT.md` in the project root and keep it updated as the codebase evolves.

---

## High-Level Architecture

Your app follows a **layered / clean-ish architecture** with a clear separation between:

- **Presentation layer**: `lib/presentation/**`
- **State & global app context**: `lib/provider/**`
- **Domain layer (business rules)**: `lib/domain/**`
- **Data layer (Firebase, WebSocket, cache)**: `lib/data/**`
- **Core / cross-cutting concerns**: `lib/core/**`
- **Application-level services**: `lib/application/**`
- **Configuration & environment**: `lib/env/**`, `lib/core/config/**`, `lib/injection.dart`, `lib/main.dart`

Data generally flows:

`UI (View)` → `ViewModel / Provider` → `UseCase` → `Repository` → `Service` → **External APIs (Firebase, WebSocket, cache, etc.)**

State management is built on **Riverpod** (`flutter_riverpod`) using `ProviderScope`, with `ChangeNotifierProvider`, `StateNotifierProvider`, and `AsyncNotifierProvider`, together with **GetIt** for dependency injection of services, repositories, and use cases.

---

## Folder Structure & Responsibilities

### lib/

- **`main.dart`**  
  - Entry point, background tasks, Firebase initialization hooks, WorkManager setup, and root `MyApp` widget.
  - Wraps the app in `EasyLocalization` and `ProviderScope`.
  - Reads initial state (auth and theme) using Riverpod (`authGlobalProvider`, `appThemeProvider`) and configures `MaterialApp.router` with:
    - Router: `appRouter` (`auto_route`)
    - Themes: `defaultTheme`, `darkTheme` from `core/config/theme/default_theme.dart`
    - Localization: via `LocalizationManager`.

- **`injection.dart`**  
  - Central **DI setup** using **GetIt**:
    - Registers **services** (`ICacheService`, `IWebSocketService`, `IFirestoreService`, `IMessagingService`, auth services).
    - Registers **repositories** (`ICacheRepository`, `IFirestoreRepository`, `IMessagingRepository`, auth repositories, `IWebSocketRepository`).
    - Registers **use cases** (`CacheUseCase`, `AuthUseCase`, `DatabaseUseCase`, `NotificationUseCase`, `SocialSignInUseCase`, `GetSocketStreamUseCase`).
    - Registers **managers** (e.g. `SyncManager`).
  - Declares **Riverpod providers**:
    - Global app providers: `appGlobalProvider`, `authGlobalProvider`, `appThemeProvider`, `webSocketProvider`, `syncManagerProvider`.
    - Feature view model providers: `authViewModelProvider`, `homeViewModelProvider`, `tradeViewModelProvider`, `dashboardViewModelProvider`, `settingsViewModelProvider`, `alarmViewModelProvider`, `splashViewModelProvider`.

### lib/core/

- **`core/config/`**  
  - **`theme/`**
    - `default_theme.dart`: 
      - Defines `defaultTheme` and `darkTheme` (`ThemeData`) and **central color palettes**:
        - `DefaultColorPalette` for light theme (static `Color` fields, including grey scales, primary colors, and utility colors).
        - `DarkColorPalette` for dark theme (static `Color` fields, including dark background/surface and text colors).
      - Defines `defaultColorScheme` and `darkColorScheme` used by the themes.
    - `style_theme.dart`:
      - `CustomTextStyle`: centralized text styles using `GoogleFonts` and `DefaultColorPalette`, with theme-aware helpers (e.g. `primaryTextStyle`, `greyColorManrope`, `balanceTextStyle`).
      - `CustomDecoration`: theme-aware `BoxDecoration` helpers.
      - `CustomInputDecoration`: standardized input styles with theme-aware and size-aware borders.
    - `app_size.dart`: centralizes spacing, radius, and font sizes (`AppSize` constants).
    - `extension/`:
      - `currency_widget_title_extension.dart`: mapping of currency codes ↔ localized labels.
      - Other formatting/string/number extensions as helpers.
  - **`localization/`**
    - Generated localization code from `easy_localization` (`codegen_loader.g.dart`, `locale_keys.g.dart`) and localization manager utilities.
  - **`init/`**
    - `init.dart` (`AppInit`): global app initialization flow:
      - `WidgetsFlutterBinding.ensureInitialized`
      - Orientation & system UI setup.
      - Hive initialization (via `HiveCacheService`).
      - `setupDependencies()` (GetIt registration).
      - `EasyLocalization.ensureInitialized()`.
      - `Firebase.initializeApp` and `FirebaseAppCheck`.
  - **`routers/`**
    - `app_router.dart` and its generated counterpart: route definitions using `auto_route`.
    - `router.dart` (`Routers`): helper class for route navigation (`pushNamed`, `replaceAll`, `pushAndRemoveUntil`, etc.) wrapping AutoRoute.
  - **`constants/`**
    - Various enums, strings, and domain constants:
      - Enums under subfolders like `enums/theme`, `enums/widgets`, `enums/auth`, `enums/socket`, etc.
      - `string_constant.dart`, `asset_constant.dart`, `firestore_constants.dart`, `filtered_codes_constants.dart`, etc.
  - **`widgets/`**
    - Generic, reusable UI building blocks:
      - `CustomSizedBox`: spacing utilities (`smallGap`, `mediumGap`, `largeGap`, `hugeGap`, width variants).
      - `CustomPadding`: shorthand padding widgets.
      - `CustomAlign`, `CustomIcon`, etc.
  - **`helpers/`**
    - `snackbar.dart` (`EasySnackBar`), `dialog_helper.dart` and other utilities for showing messages/UI feedback.
  - **`mixins/`**
    - `validation_mixin.dart`, currency icon mixins, snackbar mixin, and other behavior mix-ins reusable across view models and widgets.

### lib/data/

- **Purpose**: Implements **data sources** and concrete access to external systems (Firebase Auth, Firestore, WebSocket, Hive cache, etc.), plus low-level models.

- **`data/model/`**
  - **Auth models**: `user_login_model.dart`, `user_register_model.dart`, `firebase_auth_user_model.dart`, error models.
  - **Database models**: 
    - Request/response models: `user_data_model.dart`, `user_currency_data_model.dart`, `save_user_model.dart`, `buy_currency_model.dart`, `sell_currency_model.dart`, `user_uid_model.dart`, `alarm_model.dart`, `user_info_model.dart`, etc.
  - **Web models**: currency and pricing data from WebSocket, meta/error models.
  - Models typically expose conversion to/from domain entities (`toEntity`, `fromEntity`, `fromJson`, `toJson`).

- **`data/service/`**
  - **`remote/`**
    - **Auth**: `FirebaseAuthService`, `GoogleSignInService`, `FirebaseAppleSignInService`, `MockAuthService` via interfaces like `IFirebaseAuthService`, `ISignInService`.
    - **Database**: `FirestoreService` implementing `IFirestoreService` for Firestore CRUD and Cloud Functions.
    - **WebSocket**: `WebSocketService` implementing `IWebSocketService` for real-time price feeds.
    - **Messaging**: `FirebaseMessagingService` implementing `IMessagingService` for FCM.
  - **`cache/`**
    - `HiveCacheService` implementing `ICacheService` for theme, offline actions, and other cached data.

- **`data/repository/`**
  - Implements **repository interfaces** from `domain/repository/**`:
    - `FirestoreRepository` implements `IFirestoreRepository`:
      - Performs Firestore reads/writes and transforms `UserDataModel` ↔ `UserDataEntity`, `AlarmModel` ↔ `AlarmEntity`, etc.
    - `WebSocketRepository`, `FirebaseMessagingRepository`, `CacheRepository`, `BaseAuthRepository`, `FirebaseAuthEmailRepository`, `SocialSignInRepository`, etc.
  - Repositories receive services via DI and expose domain entities + `Either` types.

### lib/domain/

- **Purpose**: Contains **business logic abstraction**: entities, repository interfaces, and use cases. This is the layer the presentation interacts with, independent of frameworks.

- **`domain/entities/`**
  - `auth/`, `database/`, `web/`, `general/`, `cache/` entity classes.
  - Examples:
    - `UserDataEntity`, `UserCurrencyEntity`, `UserInfoEntity`, `UserUidEntity`, `AlarmEntity`.
    - Error entities: `DatabaseErrorEntity`, `AuthErrorEntity`, `BaseErrorEntity`.
  - Entities often have `fromModel` factory constructors for transforming from data models.

- **`domain/repository/`**
  - Interfaces such as:
    - `IFirestoreRepository`, `ICacheRepository`, `IWebSocketRepository`, `IMessagingRepository`, `IAuthRepository` variants.
  - Define contracts consumed by use cases.

- **`domain/usecase/`**
  - **Use cases** encapsulate single actions:
    - `AuthUseCase`, `SocialSignInUseCase`, `CacheUseCase`, `DatabaseUseCase`, `GetSocketStreamUseCase`, `MessagingUseCase`, etc.
  - `DatabaseUseCase` is a façade around `IFirestoreRepository` for `buyCurrency`, `sellCurrency`, `getUserData`, `saveUserData`, `saveUserAlarm`, `toggleAlarmStatus`, etc.
  - Most use cases extend a base generic `BaseUseCase<Params, Result>`.

### lib/presentation/

- **Purpose**: All UI, user interaction, and feature-specific view models.

- **`presentation/view/`**
  - **Feature-first structure**:
    - `auth/`: `login_view.dart`, `register_view.dart`, `forgot_password_view.dart`, auth widgets.
    - `home/`:
      - Feature subfolders: `alarm/`, `dashboard/`, `trade/`, `settings/`, `widgets/`.
      - Screens such as `home_view.dart`, `dashboard_view.dart`, `trade_view.dart`, `alarm_view.dart`, `settings_view.dart`.
      - Each feature-specific view uses a matching view model from `presentation/view_model/**`.
    - `splash/`: `splash_view.dart`.
    - `optional/`: e.g. `update_view.dart`.
  - Widgets under `presentation/view/home/widgets/` encapsulate reusable parts of the home screen (balance widgets, currency cards, filters, navigation bar, theme switcher, etc.).

- **`presentation/view_model/`**
  - **ViewModels as `ChangeNotifier`**:
    - `home/home_view_model.dart`
    - `home/alarm/alarm_view_model.dart`
    - `home/trade/trade_view_model.dart`
    - `home/dashboard/dashboard_view_model.dart`
    - `auth/auth_view_model.dart`
    - `settings/settings_view_model.dart`
    - `splash/splash_view_model.dart`
  - View models:
    - Hold controllers (`TextEditingController`, `TabController`).
    - Expose command-like methods (e.g. `signInUser`, `registerUser`, `saveAlarm`, `listenToSocketData`).
    - Interact with use cases via DI (`getIt<T>()`).
    - Are exposed to the UI through `ChangeNotifierProvider` in `injection.dart`.

- **`presentation/common/`**
  - Shared/reusable, domain-agnostic widgets (`custom_dropdown_widget.dart`, `custom_datepicker_widget.dart`, `user_email_text_widget.dart`, etc.).

### lib/provider/

- **Purpose**: Cross-screen **global state** and Riverpod integration with imperative `ChangeNotifier` and `StateNotifier` objects.

- **`app_global_provider.dart`** (`AppGlobalProvider` – `ChangeNotifier`)
  - Stores global, user-specific data:
    - `menuNavigationIndex`, `assetCodes`, `globalAssets` (stream data from WebSocket), `UserDataEntity` (`_userData`), profit/balance totals.
  - Provides methods for:
    - Updating and clearing user data (`getLatestUserData`, `updateUserData`, `clearData`).
    - Managing user alarms (`updateUserAlarm`, `addSingleUserAlamr`, `updateSingleUserAlarm`, `removeSingleAlarm`).
    - Listening to streaming WebSocket data (`updateSocketCurrency`, `_listenData`).
    - Computing profit and derived fields (`calculateProfitOrLoss`, `_calculateProfitBalanceInternal`).
    - Syncing widget data via `HomeWidget` and `SharedPreferences`.

- **`auth_global_provider.dart`** (`AuthGlobalProvider` – `ChangeNotifier`)
  - Tracks global auth state:
    - `_currentUser` (`FirebaseAuthUser`), `_currentUserId`, `_notificationToken`.
  - Defers initialization until the widget tree is idle.
  - Subscribes to Firebase `authStateChanges()` and updates the state accordingly.
  - Provides convenience getters: `isUserAuthorized`, `getCurrentUser`, `getCurrentUserId`, `notificationToken`.

- **`theme_provider.dart`** (`AppThemeNotifier` – `AsyncNotifier<AppThemeState>`)
  - Handles theme state with persisted `AppThemeEntity` using `CacheUseCase`.
  - Exposes `AppThemeState` (`currentTheme`, `isInitialized`) and a `switchAppTheme` method that cycles between `LIGHT`, `DARK`, and `SYSTEM`.

- **`web_socket_notifier.dart`** (`WebSocketNotifier` – `StateNotifier<WebSocketState>`)
  - Manages a centralized WebSocket stream:
    - Uses `GetSocketStreamUseCase` (via GetIt) to establish connection.
    - Exposes a broadcast `socketDataStream` and basic error/connected flags.

---

## Naming Conventions

### Files & Directories

- **File names**: **snake_case** with a descriptive suffix:
  - **Views**: `*_view.dart` (e.g. `home_view.dart`, `alarm_view.dart`, `login_view.dart`).
  - **ViewModels**: `*_view_model.dart` (e.g. `home_view_model.dart`, `auth_view_model.dart`).
  - **Entities**: `*_entity.dart` or `*_entity_model.dart`.
  - **Models**: `*_model.dart` (data layer).
  - **Use cases**: `*_use_case.dart`.
  - **Repositories**: `*_repository.dart`.
  - **Services**: `*_service.dart`, interface-prefixed with `i` (e.g. `ifirestore_service.dart`).
  - **Providers & Notifiers**: `*_provider.dart`, `*_notifier.dart`.
  - **Widgets**: `*_widget.dart` for reusable widgets; `*_view.dart` for full-screen pages.
  - **Enums**: `*_enum.dart` or `*_enums.dart`.
- **Folders**:
  - Feature-first under `presentation/view` and `presentation/view_model` (`home/alarm`, `home/trade`, etc.).
  - Layer-based at the root (`core`, `data`, `domain`, `presentation`, `provider`, `application`).

### Classes & Types

- **PascalCase** for classes, enums, type aliases:
  - `HomeView`, `AlarmViewModel`, `UserDataEntity`, `UserDataModel`, `AuthUseCase`, `CacheUseCase`, `AppGlobalProvider`, `WebSocketNotifier`, `CustomSizedBox`, `DefaultColorPalette`.
- **Interfaces & abstract contracts**:
  - **Repositories**: `IFirestoreRepository`, `ICacheRepository`, `IWebSocketRepository`.
  - **Services**: `IFirestoreService`, `ICacheService`, `IMessagingService`, `ISignInService`.
- **Enums**:
  - Class name ends with `Enum` or `Enums`: `AppThemeModeEnum`, `TransactionTypeEnum`, `AuthErrorStateEnums`.
  - Enum values mostly **UPPER_SNAKE_CASE** (e.g. `DARK`, `LIGHT`, `SYSTEM`).

### Methods & Variables

- **Methods**: camelCase, verb-first:
  - Examples: `initHomeView`, `getLatestUserData`, `updateSocketCurrency`, `saveAlarm`, `signInUser`, `switchAppTheme`.
- **Private fields**: prefix with `_` (e.g. `_userData`, `_totalProfitPercent`, `_authSubscription`).
- **Booleans**: `isX`, `hasX`, `canX`, `shouldX`, `showX`.
- **Controllers**: `*Controller` suffix (`emailController`, `passwordController`, `searchBarController`, `tabController`).
- **Streams**: `*Stream`, `*StreamController`.

### Widgets

- **Screens**: `SomethingView` (e.g. `HomeView`, `AlarmView`, `DashboardView`).
- **Reusable components**: `SomethingWidget` (e.g. `CustomCardWidget`, `CurrencyListWidget`, `BalanceTextWidget`).
- **Common helpers**: `CustomSizedBox`, `CustomPadding`, `CustomDropDownWidget` centralize styling and layout.

---

## State Management Patterns

### Riverpod Setup

- The entire app is wrapped with a **`ProviderScope`** in `main.dart`.
- Global and feature providers are defined in `injection.dart`:
  - `ChangeNotifierProvider<...>` for most view models and global providers.
  - `StateNotifierProvider<WebSocketNotifier, WebSocketState>` for WebSocket connection state.
  - `AsyncNotifierProvider<AppThemeNotifier, AppThemeState>` for theme state.

### Global State

- **Auth**:
  - `AuthGlobalProvider` (via `authGlobalProvider`) tracks the current Firebase user, user ID, and notification token.
  - Called early in `MyApp.build` to ensure user availability:
    - `ref.read(authGlobalProvider.notifier).initCurrentUser(ref);`
  - Consumers typically use:
    - `ref.watch(authGlobalProvider.select((value) => value.isUserAuthorized));`

- **App-level data & calculations**:
  - `AppGlobalProvider` (`appGlobalProvider`) stores:
    - `UserDataEntity` (`getUserData` getter).
    - Current asset list (`globalAssets`, `assetCodes`, `userCurrencies`).
    - Computed fields: profit, balance, latest balance.
  - It is updated by:
    - `HomeViewModel.listenToSocketData` and `WebSocketNotifier` for WebSocket updates.
    - `DatabaseUseCase.getUserData` for Firestore user data.

- **Theme**:
  - `AppThemeNotifier` manages `ThemeMode` using `CacheUseCase`.
  - Exposed as `appThemeProvider` and consumed in `MyApp.build` as `AsyncValue<AppThemeState>`:
    - `.when(loading: ..., error: ..., data: ...)`.

### Feature State

- **ViewModels** as `ChangeNotifier`:
  - Each feature has a dedicated view model provider, e.g.:
    - `homeViewModelProvider` → `HomeViewModel`
    - `alarmViewModelProvider` → `AlarmViewModel`
    - `authViewModelProvider` → `AuthViewModel`
  - Views access them with `ref.read(..)` for commands, `ref.watch(..)` for reactive properties.

- **WebSocket**:
  - `WebSocketNotifier.initializeSocket()` establishes a connection and exposes `socketDataStream`.
  - `HomeViewModel.listenToSocketData` watches `webSocketProvider` and forwards the stream to `AppGlobalProvider.updateSocketCurrency`.

---

## Separation of UI, Business Logic, and Services

### UI (Views)

- **Screens** like `HomeView`, `AlarmView`, `LoginView`, `SplashView`:
  - Manage ephemeral UI concerns (animations, controllers, timers, skeleton states, error flags).
  - Read from providers for reactive state (e.g. `isAuthorized`, global assets).
  - Call **view model methods** for business operations and navigation:
    - Examples:
      - `HomeView` calls `homeViewModelProvider.initHomeView()` and uses `HomeViewModel` for search and socket data.
      - `AlarmView` calls `AlarmViewModel.saveAlarm` to persist alarms.
      - `LoginView` calls `AuthViewModel.signInUser`, `registerUser`, etc.

### ViewModels

- Encapsulate **feature-specific business logic** and glue:
  - `HomeViewModel`:
    - Controls search text and filter logic for currency data.
    - Bridges `webSocketProvider` and `appGlobalProvider`.
  - `AlarmViewModel`:
    - Encapsulates alarm configuration state (`AlarmType`, `AlarmCondition`, `AlarmOrderType`), selected currency, and value.
    - Performs validation and constructs `AlarmEntity`.
    - Calls `DatabaseUseCase.saveUserAlarm` and updates `AppGlobalProvider`.
  - `AuthViewModel`:
    - Manages form controllers and orchestrates `AuthUseCase`, `DatabaseUseCase`, and `CacheUseCase` to register and log in users.
    - Handles routing through `Routers`.

### Domain & Data Layers

- **Use Cases**:
  - Provide a **simple API** to the view models and providers, e.g.:
    - `authUseCase.registerUser`, `authUseCase.call` for sign-in.
    - `databaseUseCase.getUserData`, `saveUserData`, `saveUserAlarm`.
    - `cacheUseCase.getTheme`, `saveTheme`, `saveOfflineAction`.
    - `getSocketStreamUseCase.call` for WebSocket streaming.

- **Repositories**:
  - Implement the actual IO and map external models into domain entities:
    - `FirestoreRepository.getUserData`:
      - Orchestrates `IFirestoreService` calls for user info, assets, and alarms, then builds `UserDataModel` and transforms to `UserDataEntity`.
    - `WebSocketRepository` uses `IWebSocketService` and optionally `ICacheService`.
    - `CacheRepository` uses `ICacheService` for offline storage.

- **Services**:
  - Wrap external packages (Firebase, Hive, WebSocket, FCM) into your own interfaces, keeping the domain independent from concrete SDKs.

---

## Themes, Colors, and Styling

### Theme Structure

- **Centralized themes** in `core/config/theme/default_theme.dart`:
  - `defaultTheme` and `darkTheme` define:
    - `useMaterial3`, typography via `GoogleFonts.manropeTextTheme()`.
    - `colorScheme` from `defaultColorScheme` / `darkColorScheme`.
    - `scaffoldBackgroundColor`, `appBarTheme`, `snackBarTheme`,
      `elevatedButtonTheme`, `filledButtonTheme`, `cardTheme`,
      `navigationBarTheme`.

- **Color Palettes**:
  - `DefaultColorPalette`:
    - Base colors such as `mainBlue`, `mainWhite`, `mainTextBlack`, `primaryGold`, `errorRed`, etc.
    - Grey scale variations and opacity helpers.
  - `DarkColorPalette`:
    - Dark background/surface and text colors.
    - Primary/secondary color pairs for dark mode.
    - Utility colors for outlines and opacity.

### Text & Component Styles

- **`CustomTextStyle`**:
  - Provides theme-aware text styles:
    - `balanceTextStyle`, `blackColorPoppins`, `greyColorPoppins`, `greyColorManrope`, `loginButtonTextStyle`, `profitColorPoppins`, etc.
  - Prefer using these for repeated typography patterns instead of ad hoc `TextStyle`.

- **`CustomDecoration` & `CustomInputDecoration`**:
  - Provide consistent visual variants for containers and input fields.
  - Use theme-aware border and background colors to support both light and dark modes.

### Layout Helpers

- **`CustomSizedBox`**:
  - Prefer `CustomSizedBox.smallGap`, `.mediumGap`, `.largeGap`, `.hugeGap` over manually specified `SizedBox(height: x)` to keep spacing consistent.
- **`CustomPadding`**, `CustomAlign`, `CustomIcon`:
  - Wrap common layout patterns in reusable components to keep widgets clean.

### Guidelines for New UI

- **Use theme and palettes**:
  - Avoid hard-coded `Colors.*` when possible.
  - Prefer `Theme.of(context).colorScheme.*` and `DefaultColorPalette` / `DarkColorPalette`.
- **Use shared styles**:
  - Reuse `CustomTextStyle`, `CustomInputDecoration`, and layout utilities for consistency across screens.
- **Support dark mode**:
  - Check `Theme.of(context).brightness` and use theme-aware helpers (as done in `CustomTextStyle` and `CustomInputDecoration.mediumRoundInputThemeAware`).

---

## Reusable Patterns & Components

- **Reusable widgets**:
  - `CustomCardWidget`: general-purpose card with title and description.
  - `CustomDropDownWidget`: type-ahead dropdown for currencies, integrated with `AppGlobalProvider` and view models (`changeSelectedCurrency`, `getPriceSelectedCurrency`).
  - Home widgets like `BalanceTextWidget`, `BalanceProfitTextWidget`, `CurrencyListWidget`, `DashboardFilterWidget`, `MenuBottomNavigationBarWidget`, etc.

- **Utility patterns**:
  - **Localization**:
    - Always use `LocaleKeys.*.tr()` and `LocalizationManager`.
  - **Currency labeling**:
    - `setCurrencyLabel(code)` and `getCurrencyCodeFromLabel(label)` via `currency_widget_title_extension.dart`.
  - **Dialog/Toast patterns**:
    - `EasySnackBar.show` and `DialogHelper` centralize feedback.

- **Background synchronization & widgets**:
  - `AppGlobalProvider.updateHomeWidget` and headless update functions in `main.dart` update the iOS/Android home widgets and `SharedPreferences` using the latest prices.

---

## Data Flow Examples

### Example 1 – Alarms (UI → Provider/State → Repository → Service → API)

1. **UI**: `AlarmView` (in `alarm_view.dart`)
   - Reads `AlarmViewModel` via `alarmViewModelProvider`.
   - Uses UI controls to set `AlarmType`, `AlarmCondition`, `AlarmOrderType`, selected currency, and target value.
   - Calls `viewModel.saveAlarm(context, ref)` when the user taps “Create Alarm”.

2. **ViewModel**: `AlarmViewModel.saveAlarm`
   - Validates inputs and uses `getCurrencyCodeFromLabel` to convert the display label to a code.
   - Retrieves user ID from `authGlobalProvider`.
   - Computes snapshot price via `AppGlobalProvider.getSelectedCurrencyBuyPrice` / `getSelectedCurrencySellPrice`.
   - Builds an `AlarmEntity` and calls `DatabaseUseCase.saveUserAlarm`.
   - On success:
     - Updates `AppGlobalProvider` with `addSingleUserAlamr`.
     - Shows a localized success `SnackBar`.
     - Switches to the alarm list tab (via `tabController`).

3. **UseCase**: `DatabaseUseCase.saveUserAlarm`
   - Delegates to `IFirestoreRepository.saveUserAlarm`.

4. **Repository**: `FirestoreRepository.saveUserAlarm`
   - Converts `AlarmEntity` to `AlarmModel`.
   - Calls `IFirestoreService.saveUserAlarm(model)`.
   - Maps result (`DatabaseErrorModel` / success) to `DatabaseErrorEntity` / `bool`.

5. **Service**: `FirestoreService.saveUserAlarm`
   - Makes the actual Firestore call to save the alarm document.

### Example 2 – WebSocket Prices (UI → Provider → UseCase → Repository → Service)

1. **Initialization**:
   - `WebSocketNotifier.initializeSocket()` uses `GetSocketStreamUseCase` to open a WebSocket and exposes a broadcast `socketDataStream` in `WebSocketState`.

2. **ViewModel**: `HomeViewModel.listenToSocketData`
   - Watches `webSocketProvider`.
   - If `socketDataStream != null`, passes it to `AppGlobalProvider.updateSocketCurrency`.

3. **Provider**: `AppGlobalProvider.updateSocketCurrency`
   - Assigns the stream to `_dataStream` and calls `_listenData`.
   - `_listenData`:
     - Updates `globalAssets` on each event.
     - Updates `assetCodes` and schedules profit calculation via `scheduleCalculation`.
     - Notifies listeners for the UI to update.

4. **UI**: `HomeView`
   - Watches `appGlobalProvider.globalAssets` and uses them to render `CurrencyListWidget` and date/time text.
   - Displays skeletons, error states, and fallback UI when data is missing.

---

## How to Structure New Features

When adding a new feature, align with the current **feature + layer** structure.

### Example: New “Notifications” Feature

- **Domain**
  - Add entities (if needed) under `domain/entities/notifications/`, e.g. `notification_entity.dart`.
  - Add repository interface under `domain/repository/notifications/inotification_repository.dart`.
  - Add use cases under `domain/usecase/notifications/`, e.g. `notifications_use_case.dart`.

- **Data**
  - Implement models under `data/model/notifications/`, e.g. `notification_model.dart`.
  - Implement services under `data/service/remote/notifications/`, or extend existing messaging services.
  - Implement `NotificationRepository` under `data/repository/notifications/notification_repository.dart` fulfilling the interface.

- **DI**
  - Register any new services, repositories, and use cases in `setupDependencies()` in `injection.dart`.

- **State & Presentation**
  - Create a `NotificationsViewModel` under `presentation/view_model/home/notifications/notifications_view_model.dart` (or appropriate section).
    - Extends `ChangeNotifier`.
    - Injects use cases from `getIt`.
  - Create a `NotificationsView` under `presentation/view/home/notifications/notifications_view.dart`.
    - Annotate with `@RoutePage()` if using `auto_route`.
    - Use `ConsumerWidget` or `ConsumerStatefulWidget`.
  - Add a provider in `injection.dart`:
    - `final notificationsViewModelProvider = ChangeNotifierProvider<NotificationsViewModel>((ref) { ... });`
  - Wire navigation via `auto_route` and `Routers`.

- **Styling**
  - Use:
    - `CustomTextStyle` for typography.
    - `CustomInputDecoration` / `CustomDecoration` for inputs and cards.
    - `CustomPadding` / `CustomSizedBox` for layout.
  - Rely on `Theme.of(context).colorScheme` and `DefaultColorPalette` instead of raw colors.

---

## Best Practices Observed

- **Clear layering and DI**: Domain/usecase/repository/service separation with GetIt and Riverpod is consistent and scalable.
- **Feature-first structure in presentation**: Views and view models are organized by feature (`home`, `auth`, `alarm`, etc.).
- **Reusable styling**: Centralized theme, palette, and style helpers promote consistent look & feel.
- **Single source of truth for global data**: `AppGlobalProvider` and `AuthGlobalProvider` handle cross-screen concerns cleanly.
- **Error handling via `Either`**: Repositories and use cases consistently return `Either<ErrorEntity, Result>`.

---

## Anti-Patterns / Things to Watch

- **Mixed DI and state-management styles**:
  - You use Riverpod, `ChangeNotifier`, `StateNotifier`, and GetIt together.
  - This is workable but can be complex; when adding new features, follow the **existing pattern** for that area (e.g. for a new view, use `ChangeNotifierProvider` + `ChangeNotifier` + GetIt for use cases).
- **`dynamic` viewModel in `CustomDropDownWidget`**:
  - The `viewModel` parameter is `dynamic` and relies on convention (`changeSelectedCurrency`, `getPriceSelectedCurrency`).
  - For new components, prefer strongly typed generics where possible.
- **Some business logic in widgets**:
  - For example, date parsing and delay calculations in `HomeView` are in the widget.
  - When extending functionality, consider moving heavier logic into view models to keep widgets declarative.

---

## Summary

- **Architecture**: Layered (core/data/domain/presentation/provider/application) with feature-first presentation structure and GetIt + Riverpod for DI and state.
- **Naming & Organization**: Snake_case filenames, PascalCase types, clear suffixes (`View`, `ViewModel`, `Entity`, `Model`, `UseCase`, `Repository`, `Service`, `Provider`, `Widget`).
- **State & Data Flow**: Views → ViewModels/Providers → UseCases → Repositories → Services → External APIs, with global app/auth/theme state handled by dedicated providers.
- **Styling & Reuse**: Centralized themes, palettes, and style helpers (`DefaultColorPalette`, `CustomTextStyle`, `CustomSizedBox`, `CustomPadding`) should be the default for any new UI, keeping the app visually and structurally consistent.

