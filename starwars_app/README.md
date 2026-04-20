# README biblio Star Wars

## 1. Vue d'ensemble

La **Bibliothèque Star Wars** est une application mobile Flutter qui utilise l'API publique
[SWAPI](https://swapi.tech/) pour afficher 3 catégories de l'univers Star Wars : 

| Onglet | Données affichées |
|---|---|
| Films | Titre, épisode, réalisateur, producteur, ouverture déroulante |
| Planètes | Nom, climat, terrain, population, diamètre, gravité, orbite |
| Personnages | Nom, naissance, genre, taille, masse, couleur des yeux/cheveux |

---

## 2. Configuration de l'environnement

### Prérequis

| Outil | Version recommandée |
|---|---|
| Flutter SDK | ≥ 3.22 (stable) |
| Dart SDK | ≥ 3.0 (inclus dans Flutter) |
| Android Studio / VS Code | Dernière version |
| Connexion Internet | Requise (API + google_fonts) |

### Installation rapide

```bash
# 1. Vérifier l'installation de Flutter
flutter doctor

# 2. Cloner / copier le projet
cd starwars_library

# 3. Installer les dépendances
flutter pub get

# 4. Lancer sur un émulateur ou appareil connecté
flutter run
```

### Dépendances (`pubspec.yaml`)

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.1          # Appels HTTP vers SWAPI
  google_fonts: ^6.2.1  # Police Orbitron + Exo 2
```

---

## 3. Structure des fichiers

```
lib/
├── main.dart                   # Entrée de l'app, thème global, TabBar
├── models/
│   ├── film.dart               # Modèle Film
│   ├── planet.dart             # Modèle Planet
│   └── character.dart          # Modèle Character
├── services/
│   └── swapi_service.dart      # Appels HTTP à l'API SWAPI
├── screens/
│   ├── films_screen.dart       # Onglet Films
│   ├── planets_screen.dart     # Onglet Planètes
│   └── characters_screen.dart  # Onglet Personnages
└── widgets/
    ├── loading_widget.dart     # Indicateur de chargement
    └── error_widget.dart       # Widget d'erreur avec retry
```

## 4. Problèmes rencontrés 



## 5. Améliorations possibles

Pour améliorer le site, j'ai pensé à plusieurs fonctionnalités supplémentaires : 

1. J'aimerais pouvoir mettre des images pour représenter les trois catégories (posters de films, photos des planètes et des personnages)
2. J'ai vu que dans l'API plusieurs autres catégories existaient (Espèces, véhicules, vaisseaux) qui pourraient être intégrés au site.
3. Une option pour chercher des informations spécifiques (barre de recherche, option à cocher)
4. Les informations présentées sont en anglais et il faudrait que je puisse les traduire pour améliorer la qualité du site
5. Améliorer la qualité visuelle du site car le rendu est très moche par endroits (surtout sur l'onglet film) 