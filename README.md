# Cineverse

A bit overview, it uses [The Movie Database(TMDb)](https://www.themoviedb.org/) API to get movies data in JSON format and show it's details. It's a Flutter spinoff of a similar app I created for Udacity Nanodegree - [Cineverse Android](https://github.com/AbhishekChd/Cineverse)


## Features
- [x] List **Popular** and **Top Rated** movies
- [x] List movies as cards and show more details on selecting
- [ ] Favourite you watched movies
- [ ] Add movies to watchlist
- [x] Settings to add Auth token and switch Dark Mode
- [x] Cached Images
- [x] BLoC Pattern
- [ ] Custom Error Handling
- [ ] Repository Pattern

## Screenshots

### Dark Mode
<img src="screenshot/home_dark.png" width="33%"/> <img src="screenshot/movie_detail_dark.png" width="33%"/> <img src="screenshot/settings_dark.png" width="33%"/>

### Light Mode
<img src="screenshot/home_light.png" width="33%"/> <img src="screenshot/movie_detail_light.png" width="33%"/> <img src="screenshot/settings_light.png" width="33%"/>


## Run the app
1. Clone the project
2. Fetch dependencies using `flutter get`
3. Run: `flutter pub run build_runner watch --delete-conflicting-outputs`
4. Then hit the <kbd>Run</kbd> button
5. When app loads you need to add the Authentication token in settings screen


## Auth Token
To run the app you have to add [The Movie DB](https://developers.themoviedb.org/3/getting-started/introduction) Authentication token. You can register on the developer website and fill some basic app information, then get the Auth token.


## Libraries used
- [retrofit](https://pub.dev/packages/retrofit)
- [json_serializable](https://pub.dev/packages/json_serializable)
- [google_fonts](https://pub.dev/packages/google_fonts)
- [hive](https://pub.dev/packages/hive)
- [cached_network_image](https://pub.dev/packages/cached_network_image)
- [flutter_layout_grid](https://pub.dev/packages/flutter_layout_grid)