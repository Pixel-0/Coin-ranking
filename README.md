# Coin Ranking iOS App

An iOS application that displays cryptocurrency rankings, coin details, and charts. The app uses MVVM architecture and fetches data from a remote API.

---

## Features

- List of top 100 cryptocurrencies with icons, prices, and 24h changes.
- Detail screen for each coin with historical price chart.
- Filter coins by price or 24h performance.
- Favorite coins for quick access.
- SwiftUI charts embedded inside UIKit views.
- Smooth async image loading with placeholder support.

---

## Requirements

- Xcode 15+
- iOS 16+
- Swift 5.9

---

## Getting Started

1. Clone the repository:

```bash
git clone https://github.com/Pixel-0/Coin-ranking.git
cd Crypto
```
2. Open the project in Xcode:
```bash
open Crypto.xcodeproj
```
3. Build and run the app on a simulator or a physical device.

### Assumptions / Decisions

- The app displays only the top 100 coins.
- Coin data is fetched using a custom APIClient.
- Charts use SwiftUI’s Chart embedded inside UIKit via UIHostingController.
- Images are loaded from URLs with placeholder images before downloading.
- Favorites are stored locally using a singleton manager `FavoriteManager`.

### Challenges & Solutions

- Shimmering loader not working: Replaced custom shimmer animation with placeholder images for reliability.
- Combining SwiftUI charts with UIKit: Solved by embedding SwiftUI Chart views inside `UIHostingController`.
- Pagination & filtering of coins: Implemented `UISegmentedControl` for filters and scroll-based pagination.

### Project Structure

- Views: UIKit & SwiftUI components (`CoinListViewController`, `CoinDetailViewController`, SwiftUI charts)
- ViewModels: Data handling and API requests (`CoinViewModel`, `HistoryViewModel`)
- Models: Data models (`Coin`, `CoinDetail`, `HistoryPoint`)
- Managers: Singletons like `APIClient` and `FavoriteManager` for networking and local storage.