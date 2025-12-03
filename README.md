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

- #### Shimmering loader for lists and details:
 Initially, we struggled to implement smooth shimmer placeholders for both the coin list and the detail screen. UIKit does not have built-in support for shimmering, so creating custom placeholder views with animations was tricky. We solved this by designing `CoinShimmerCell` for list items and `CoinDetailShimmerView` for the detail screen, providing immediate visual feedback while data loads.

- #### Combining SwiftUI charts with UIKit:
We embedded SwiftUI `Chart` views inside UIKit using `UIHostingController` to display historical price data with selectable ranges.

- #### Pagination & filtering of coins:
Implemented UISegmentedControl for filtering by highest price or best 24-hour change, combined with scroll-based pagination to incrementally fetch the top 100 coins.


### Project Structure

- Views: UIKit & SwiftUI components (`CoinListViewController`, `CoinDetailViewController`, SwiftUI charts)
- ViewModels: Data handling and API requests (`CoinViewModel`, `HistoryViewModel`)
- Models: Data models (`Coin`, `CoinDetail`, `HistoryPoint`)
- Managers: Singletons like `APIClient` and `FavoriteManager` for networking and local storage.