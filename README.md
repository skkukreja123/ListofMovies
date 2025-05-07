

A Flutter app that displays a list of movies fetched from the TMDB API. It demonstrates **Clean Architecture**, **MVVM**, **Repository Pattern**, **Dependency Injection**, and **Provider** for state management.

---
API calling : 'https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey',

APi Key store in .env


 Features

- **Home screen** displays a list of movies (poster, title, overview)
- **Detail screen** shows more information about the selected movie
- Pull to refresh support
- Loading, error, and no internet handling
- Reusable `MovieCard` widget
- Clean Architecture + MVVM + Repository Pattern
- **Unit tests** for the repository

---

get_it – Dependency Injection
This app uses the get_it package to manage dependencies cleanly and efficiently. It registers and provides instances like network checkers, services, and view models throughout the app.

Why?

Decouples object creation from usage

Enables easier testing and mocking

Centralized configuration


This app uses the provider package to manage UI state through the ViewModel (MovieViewModel). This ensures a reactive UI that responds to loading, success, and error states.

Why?

Easy to use and efficient

Encourages MVVM structure

Great for listening to and updating UI state


![image](https://github.com/user-attachments/assets/5d0a208b-da1e-4a15-8b91-5d094e0a6f6b)


![image](https://github.com/user-attachments/assets/dbe5aadf-d8cc-4736-be90-a82ba942d259)
