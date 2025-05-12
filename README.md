

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


![image](https://github.com/user-attachments/assets/e99eb96d-fecd-4dec-961e-353b3a10e10c)
![image](https://github.com/user-attachments/assets/dae7b070-aa78-4664-905a-5ba647c96103)

![image](https://github.com/user-attachments/assets/04a4cbb9-a22f-4cbd-84d7-640072be7e7c)

![image](https://github.com/user-attachments/assets/c575194b-65b3-4de0-8a7f-3e128ff460c1)


