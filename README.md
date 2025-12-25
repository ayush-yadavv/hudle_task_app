# Weather App

A feature-rich weather application built with Flutter, demonstrating the extensive use of the BLoC pattern and Clean Architecture. This project fetches real-time weather data from the OpenWeatherMap API and supports offline caching, geolocation, and dynamic theming.

## 📱 Demo & Download

- **📹 Demo Video:** [Watch on YouTube](https://youtu.be/k_CqvoQTPFE)
- **📦 Download APK:** [Latest Release](https://github.com/ayush-yadavv/hudle_task_app/tree/master/apk_files)

## Features

- **Real-time Weather:** Fetches current weather data including temperature, humidity, wind speed, pressure, and more.
- **Search & Autocomplete:** Search for cities globally with search history.
- **Geolocation:** Automatically detects user location (if permitted) or defaults to a preset location.
- **Caching & Offline Support:** Uses `Hive` to cache the last known weather and search history, allowing the app to work offline.
- **Dynamic Theming:** Supports Light and Dark modes with a custom togglable setting.
- **Unit Conversion:** Toggle between Units.
- **Responsive Design:** Optimized for various screen sizes.
- **Animations:** Smooth transitions and micro-interactions.

## Architecture

The application follows **Clean Architecture** combined with the **BLoC (Business Logic Component)** pattern to ensure separation of concerns, testability, and scalability.

### Layers:

1.  **Presentation:** Contains UI (Screens, Widgets) and BLoC (State Management). The UI reacts to States emitted by BLoCs.
2.  **Domain:** Contains the business logic contracts (Repository Interfaces) and Entities. It is independent of external data sources.
3.  **Data:** Handles data retrieval from Remote (API via Dio) and Local (Hive) sources. It implements the Domain interfaces.

## Setup & Installation

### Prerequisites

- Flutter SDK (3.10.0 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- A valid OpenWeatherMap API key

### Installation Steps

1. **Clone the repository:**

   ```bash
   git clone https://github.com/ayush-yadavv/hudle_task_app.git
   cd hudle_task_app
   ```

2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Environment Configuration:**

   - Create a `.env` file in the project root directory
   - Add your OpenWeatherMap API key:

     ```env
     OPEN_WEATHER_API_KEY=your_api_key_here
     ```

   - Get your free API key from: [OpenWeatherMap API](https://openweathermap.org/api)
   - **Note:** Ensure your API key has access to both `/weather` (Current Weather) and `/forecast` (5-day Forecast) endpoints.

4. **Run the app:**

   ```bash
   flutter run
   ```

5. **Build for release (optional):**

   ```bash
   # Android APK
   flutter build apk --release

   # iOS
   flutter build ios --release
   ```

## My Learning Journey

### BLoC Pattern

Understanding BLoC involved a deep dive into reactive programming:

1.  **Event-Driven Architecture:** I learned to model every user interaction as an `Event` and every UI change as a `State`.
2.  **Action States:** I discovered the importance of distinguishing between "Data States" (for UI rendering) and "Action States" (for side effects like navigation), resolving issues where one-off events would conflict with persistent data.
3.  **BLoC Widgets:** I explored the use of:
    - `BlocProvider` - to inject BLoCs into the widget tree and make them accessible to child widgets.
    - `MultiBlocProvider` - to provide multiple BLoCs at once, keeping the code clean when multiple state managers are needed.
    - `BlocBuilder` - to rebuild UI when specific states change, using `buildWhen` to filter unnecessary rebuilds.
    - `BlocListener` - to handle side effects (navigation, snackbars) using `listenWhen` for precise control.
    - `BlocConsumer` - to combine both Builder and Listener when a widget needs to react to states AND handle side effects simultaneously.

### Efficient Networking with Dio

1.  **Why Dio over HTTP?** I discovered that Dio offers several advantages over Flutter's basic `http` package:
    - Built-in interceptors for logging, authentication, and global error handling.
    - More detailed exception types (`DioException`) with specific error codes (connection timeout, receive timeout, bad response).
    - Request cancellation and retry mechanisms out of the box.
    - Automatic JSON serialization and better configuration options (base URLs, default headers).
2.  **Robust Error Handling:** I learned to intercept `DioException` types (timeouts, bad responses) and map them to domain-specific failures (`WeatherFailure`), ensuring the UI gets clean, usable error messages.
3.  **Architecture:** I learned to encapsulate Dio within a `RemoteDataSource`, preventing the Repository or BLoC layers from knowing about HTTP implementation details.

### Clean Architecture

1.  **Repository Interfaces:** I learned to define clear contracts (interfaces) for data access, ensuring the UI layer doesn't know about the data source.
2.  **Dependency Injection:** I explored the use of `get_it` for dependency injection, making it easier to swap out implementations (like switching from Hive to SQLite for local storage).

## Challenges Faced & Solutions

### 1. Handling API & Network Errors Gracefully

- **Challenge:** ensuring the user sees friendly error messages (e.g., "No Internet") instead of raw exceptions.
- **Solution:** Implemented a robust `ApiException` handler in the Data layer and mapped these to typed `WeatherFailure` objects in the BLoC layer, ensuring the UI always receives structured error data.

### 2. Offline Persistence

- **Challenge:** Displaying data when the user has no connectivity.
- **Solution:** Integrated `Hive` for local storage. The Repository follows a strategy: _Try Network -> If Fail, Return Cache_. This ensures a seamless "Offline First" experience.

### 3. Dynamic Search & Debouncing

- **Challenge:** Preventing API rate limits while the user types.
- **Solution:** Used `rxdart` transformers within the BLoC specifically for the Search event to add a 500ms debounce, ensuring we only query the API after the user stops typing.

### 4. Location Name vs. Weather Station Mismatch

- **Challenge:** I discovered that city names returned by the Location Search API often didn't match the specific station names expected by the Weather API, treating valid locations as "Not Found."
- **Solution:** I refactored the flow to prioritize **Coordinates over Names**. The app first resolves the City Name to (Lat/Long) using the Geolocation API. Then, it passes these coordinates to the Weather API. This guarantees that the Weather API always finds the nearest weather station to the user's selected point, regardless of naming differences.

### 5. Managing Side-Effects vs. UI State

- **Challenge:** A common issue in state management is distinguishing between state changes that should rebuild the UI (like new weather data) and one-off events (like a specialized "City Not Found" toast or navigation). Using a single state stream can lead to lost data or multiple snackbars.
- **Solution:** I resolved this by categorizing states into standard UI states and specific **`ActionState`** classes. I configured `buildWhen` to only trigger rebuilds for persistent data changes and `listenWhen` to react only to `ActionState` emissions (like navigation or SnackBars). This prevents one-off events from destabilizing the main UI.

## Dependencies

### Core State Management & Architecture

- **`flutter_bloc`** (^9.1.1) - State management using the BLoC pattern.
- **`bloc`** (^9.1.0) - Core BLoC library.
- **`get_it`** (^9.2.0) - Dependency injection container.
- **`equatable`** (^2.0.7) - Simplifies value equality comparisons.

### Networking & Data

- **`dio`** (^5.9.0) - Powerful HTTP client with interceptors and error handling.
- **`hive`** (^2.2.3) - Fast, lightweight NoSQL database.
- **`hive_flutter`** (^1.1.0) - Flutter extensions for Hive.
- **`rxdart`** (^0.28.0) - Reactive extensions for Dart (used for debouncing).

### UI & Presentation

- **`google_fonts`** (^6.3.3) - Google Fonts integration.
- **`iconsax_flutter`** (^1.0.1) - Modern icon set.
- **`shimmer`** (^3.0.0) - Shimmer loading effect.
- **`flutter_svg`** (^2.2.3) - SVG rendering.
- **`custom_refresh_indicator`** (^4.0.1) - Custom pull-to-refresh.

### Utilities

- **`connectivity_plus`** (^7.0.0) - Network connectivity detection.
- **`fluttertoast`** (^9.0.0) - Toast notifications.
- **`flutter_dotenv`** (^6.0.0) - Environment variable management.
- **`intl`** (^0.20.2) - Internationalization and formatting.
- **`flutter_native_splash`** (^2.4.7) - Native splash screen generation.

---

**Developed for the Hudle Flutter Developer Task**
