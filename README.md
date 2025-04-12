# PragmaUIKit



Una aplicación iOS desarrollada con UIKit que muestra información sobre diferentes razas de gatos utilizando TheCatAPI. Este proyecto implementa una arquitectura MVVM, programación modular y componentes de UI personalizados.


## 📱 Características

- **Exploración de Razas**: Descubre razas de gatos con imágenes de alta calidad
- **Sistema de Favoritos**: Guarda y gestiona tus razas favoritas
- **Búsqueda y Filtrado**: Encuentra rápidamente razas específicas
- **Experiencia de Usuario Optimizada**: Animaciones sutiles, feedback háptico y estados de carga elegantes
- **Arquitectura MVVM**: Separación clara de responsabilidades entre componentes
- **SplashScreen Animada**: Presentación inicial de la app con transiciones fluidas

## 🛠️ Tecnologías

- UIKit con Auto Layout
- URLSession para networking
- Arquitectura MVVM
- Cache de imágenes
- Manejo de errores robusto
- Grand Central Dispatch (GCD)

## 🏗️ Arquitectura

El proyecto sigue una estructura organizada basada en MVVM:

```
📦 TheCatAPIUIKit
├── 📂 App
│   ├── 📄 AppDelegate
│   ├── 📄 SceneDelegate
│   ├── 📂 Resources
│   └── 📂 Assets
│
├── 📂 Sections
│   ├── 📂 BreedDetail
│   │   ├── 📂 Cell
│   │   │   └── 📄 TemperamentChipCell
│   │   ├── 📄 CatBreedDetailViewController
│   │   └── 📄 CatBreedDetailViewModel
│   │
│   ├── 📂 BreedsList
│   │   ├── 📂 Model
│   │   │   ├── 📄 CatBreed
│   │   │   └── 📄 CatImage
│   │   ├── 📂 View
│   │   │   └── 📂 Cell
│   │   │       └── 📄 CatBreedCell
│   │   ├── 📄 CatBreedsViewController
│   │   └── 📄 CatBreedsViewModel
│   │
│   └── 📂 FavoritesList
│       ├── 📂 View
│       │   ├── 📂 Cell
│       │   │   └── 📄 CatFavoriteCell
│       │   ├── 📄 CatFavoritesViewController
│       │   └── 📄 EmptyStateView
│       └── 📄 CatFavoritesViewModel
│
├── 📂 MainTabBar
│   └── 📄 MainTabBarController
│
├── 📂 Splash
│   └── 📄 SplashViewController
│
├── 📂 Services
│   ├── 📄 CatAPIService
│   └── 📄 FavoritesPersistenceService
│
├── 📂 Utils
│   └── 📄 ImageLoader
│
└── 📂 Views
    └── 📄 WebViewController
```


## 📋 Instalación

1. Clona este repositorio:
```bash
git clone https://github.com/Rawstells/PragmaUIKit.git
```

2. Navega al directorio del proyecto:
```bash
cd PragmaUIKit
```

3. Abre PragmaUIKit.xcodeproj en Xcode

4. Compila y ejecuta la aplicación (⌘+R)

## 🔍 Implementaciones Destacadas

### Vista de Detalle Premium

La vista de detalle de raza incorpora múltiples técnicas de UI avanzadas:

- **Efecto Parallax**: La imagen principal responde sutilmente al scroll
- **Tarjetas de Información**: Contenido organizado en secciones claras
- **Chips de Temperamento**: Visualización de características con códigos de color
- **Indicadores de Rating**: Representación visual de atributos del gato
- **Animaciones**: Feedback táctil y transiciones fluidas

### Manejo de Estado y Networking

- **Estados de Carga**: Visualización elegante durante la obtención de datos
- **Timeout Automático**: Evita bloqueos de UI por problemas de red
- **Caché de Imágenes**: Optimización del rendimiento y uso de datos
- **Manejo de Errores**: Feedback amigable al usuario ante problemas

## 📱 Capturas de Pantalla



## 🔄 Flujo de la Aplicación

1. **SplashScreen**: Animación inicial con el logo
2. **Lista de Razas**: Exploración del catálogo completo con opciones de filtrado
3. **Detalle de Razas**: Información completa con diseño premium
4. **Favoritos**: Gestión de razas preferidas
5. **Búsqueda**: Filtrado rápido por nombre o características



## 📝 Licencia

Este proyecto está licenciado bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## 👨‍💻 Autor

**Rawstells** - [GitHub](https://github.com/Rawstells)

---
