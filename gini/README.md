# Gini - Star Wars Characters App

Gini est une application Flutter moderne qui vous permet de rechercher, explorer et visualiser les personnages de l'univers Star Wars en utilisant l'API SWAPI. L'interface est immersive, inspirée de Star Wars, et offre une expérience utilisateur fluide et élégante.

## Fonctionnalités Principales

- **Recherche Instantanée** : Barre de recherche optimisée avec suggestions dynamiques à partir de 3 caractères.
- **Affichage des Personnages** : Liste détaillée avec nom, taille, genre, année de naissance, favoris et plus encore.
- **Effets Visuels Star Wars** : Thème sombre, couleurs dynamiques, logo animé et éléments graphiques immersifs.
- **Responsive** : S'adapte automatiquement aux modes portrait et paysage.
- **Défilement Infini** : Pagination automatique lors du défilement pour charger plus de personnages.
- **Gestion des Erreurs** : Affiche un message d'erreur et permet de réessayer en cas de problèmes réseau.
- **Favoris** : Possibilité de marquer les personnages comme favoris (peut être étendu selon les besoins).
- **Animations Fluides** : Transitions et animations élégantes pour une expérience utilisateur premium.
- **Thème Adaptatif** : Support du mode sombre et clair avec des couleurs thématiques Star Wars.

## Configuration Technique

### Versions Minimales Supportées
- **iOS/iPadOS** : iOS 15.0 et versions ultérieures
- **Android** : Android 10 (API level 29) et versions ultérieures

### Prérequis
- Flutter SDK (dernière version stable)
- Dart SDK (dernière version stable)
- Xcode 14+ (pour iOS)
- Android Studio (pour Android)
- JDK 11+

## Installation

1. **Cloner le dépôt**
   ```bash
   git clone https://github.com/Tomyshh/gini.git
   cd gini
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Lancer l'application**
   ```bash
   flutter run
   ```

## Configuration
- **Police Personnalisée** : La police "News Gothic Extra Condensed Regular" est incluse dans `assets/fonts` et utilisée pour le logo.
- **Images** : Le logo principal se trouve dans `assets/images/logo_yellow.png`.
- **API** : Les données proviennent de [SWAPI](https://swapi.dev/).

## Technologies Utilisées
- **Flutter** (Dart)
- **Provider** (gestion d'état)
- **SWAPI** (Star Wars API)
- **Animations** : flutter_animate
- **UI/UX** : Design responsive, thème sombre, effets visuels Star Wars
- **Gestion des Versions** : Configuration optimisée pour iOS 15+ et Android 10+

## Structure du Projet
- `lib/screens/` : Écrans principaux (accueil, etc.)
- `lib/widgets/` : Composants réutilisables (barre de recherche, liste des personnages, etc.)
- `lib/providers/` : Gestionnaires d'état (PeopleProvider)
- `lib/constants/` : Constantes et thèmes
- `lib/models/` : Modèles de données
- `assets/` : Images, polices, etc.

## Fonctionnalités Techniques
- **Gestion d'État** : Utilisation de Provider pour une gestion efficace de l'état
- **Navigation** : Navigation fluide entre les écrans
- **Mise en Cache** : Gestion optimisée des données
- **Performance** : Optimisations pour les appareils mobiles
- **Accessibilité** : Support des fonctionnalités d'accessibilité

## Auteur
- [Tomyshh](https://github.com/Tomyshh)

## Licence
Ce projet est open-source sous la licence MIT. 