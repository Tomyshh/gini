# Gini - Star Wars Characters App

Gini est une application Flutter moderne qui permet de rechercher, explorer et visualiser les personnages de l'univers Star Wars grâce à l'API SWAPI. L'interface est immersive, inspirée de l'univers Star Wars, et propose une expérience utilisateur fluide et élégante.

## Fonctionnalités principales

- **Recherche instantanée** : Barre de recherche optimisée avec suggestions dynamiques dès 3 caractères.
- **Affichage des personnages** : Liste détaillée avec nom, taille, genre, date de naissance, favoris, etc.
- **Effets visuels Star Wars** : Thème sombre, couleurs dynamiques, logo animé, et éléments graphiques immersifs.
- **Responsive** : Adaptation automatique en mode portrait et paysage.
- **Chargement infini** : Pagination automatique lors du scroll pour charger plus de personnages.
- **Gestion des erreurs** : Affichage d'un message d'erreur et possibilité de recharger en cas de problème réseau.
- **Favoris** : Possibilité de marquer des personnages comme favoris (à implémenter/étendre selon besoin).

## Aperçu

![Aperçu de l'application](assets/images/logo_yellow.png)

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
- **Police personnalisée** : La police "News Gothic Extra Condensed Regular" est incluse dans `assets/fonts` et utilisée pour le logo.
- **Images** : Le logo principal se trouve dans `assets/images/logo_yellow.png`.
- **API** : Les données proviennent de [SWAPI](https://swapi.dev/).

## Technologies utilisées
- **Flutter** (Dart)
- **Provider** (gestion d'état)
- **SWAPI** (API Star Wars)
- **Animations** : flutter_animate
- **UI/UX** : Design responsive, thème sombre, effets visuels Star Wars

## Structure du projet
- `lib/screens/` : Écrans principaux (home, etc.)
- `lib/widgets/` : Composants réutilisables (search bar, people list, etc.)
- `lib/providers/` : Gestionnaires d'état (PeopleProvider)
- `assets/` : Images, polices, etc.

## Auteur
- [Tomyshh](https://github.com/Tomyshh)

## Licence
Ce projet est open-source sous licence MIT. 