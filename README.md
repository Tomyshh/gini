# Gini - Star Wars Characters App

Gini is a modern Flutter application that lets you search, explore, and view characters from the Star Wars universe using the SWAPI API. The interface is immersive, inspired by Star Wars, and offers a smooth and elegant user experience.

## Main Features

- **Instant Search**: Optimized search bar with dynamic suggestions from 3 characters.
- **Character Display**: Detailed list with name, height, gender, birth year, favorites, and more.
- **Star Wars Visual Effects**: Dark theme, dynamic colors, animated logo, and immersive graphical elements.
- **Responsive**: Automatically adapts to portrait and landscape modes.
- **Infinite Scrolling**: Automatic pagination when scrolling to load more characters.
- **Error Handling**: Displays an error message and allows retrying in case of network issues.
- **Favorites**: Ability to mark characters as favorites (can be extended as needed).

## Preview

![App Preview](assets/images/logo_yellow.png)

## Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Tomyshh/gini.git
   cd gini
   ```
2. **Install dependencies**
   ```bash
   flutter pub get
   ```
3. **Run the app**
   ```bash
   flutter run
   ```

## Configuration
- **Custom Font**: The font "News Gothic Extra Condensed Regular" is included in `assets/fonts` and used for the logo.
- **Images**: The main logo is located at `assets/images/logo_yellow.png`.
- **API**: Data comes from [SWAPI](https://swapi.dev/).

## Technologies Used
- **Flutter** (Dart)
- **Provider** (state management)
- **SWAPI** (Star Wars API)
- **Animations**: flutter_animate
- **UI/UX**: Responsive design, dark theme, Star Wars visual effects

## Project Structure
- `lib/screens/`: Main screens (home, etc.)
- `lib/widgets/`: Reusable components (search bar, people list, etc.)
- `lib/providers/`: State managers (PeopleProvider)
- `assets/`: Images, fonts, etc.

## Author
- [Tomyshh](https://github.com/Tomyshh)

## License
This project is open-source under the MIT license. 