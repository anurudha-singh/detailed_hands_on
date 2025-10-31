# 🔥 Flutter Practical Interview Challenges

Prepared for: **Anurudh Singh**  
Objective: Deep practical mastery for Flutter interviews (Senior level)

---

## 🧠 ROUND 1 – Core Flutter & State Management (Hands-on)

### 🧩 Question 1: Reactive Counter with Provider or BLoC
Implement a counter app where:
- “Increment” adds 1 instantly.
- “Decrement” waits 2 seconds before applying (simulate async).
- The UI should stay responsive and show a loading spinner during async ops.
- Use **BLoC** or **Provider**, not `setState`.

💡 *Bonus:* Persist counter value using `SharedPreferences` or `Hive`.

---

### 🧩 Question 2: Todo App with Filtering
Create a simple todo app with:
- Add / delete update tasks.
- Mark as done.
- Filter (All, Active, Completed).
- Use **StateNotifier + Riverpod** or **Cubit**.
- UI must rebuild efficiently without full widget reload.

💡 *Bonus:* Animate task deletion using `AnimatedList`.

---

## ⚙️ ROUND 2 – API, Async & Error Handling

### 🧩 Question 3: Fetch GitHub Repos
Create a screen that:
- Fetches repos from `https://api.github.com/users/{username}/repos`.
- Displays name, stars, and description.
- Has loading, error, and retry states.

💡 *Bonus:* Implement pagination (`?page=1&per_page=10`) with infinite scroll.

---

### 🧩 Question 4: Offline-First Data Handling
Build a small app that:
- Fetches and caches API data (e.g., a list of posts).
- On subsequent launches, shows cached data first, then refreshes from network.
- Use `sqflite` or `Hive`.

💡 *Bonus:* Sync offline-created items to server when internet restores.

---

## 🧭 ROUND 3 – Navigation, Deep Links, and Routing

### 🧩 Question 5: Multi-Navigator Bottom Navigation
Implement a bottom nav bar with 3 tabs:
- Home
- Search
- Profile

Each should maintain its own navigation stack.  
Use `Navigator` + `IndexedStack` (not rebuild every time).

💡 *Bonus:* Implement deep linking — open app directly to `/profile/123`.

---

## 💥 ROUND 4 – Animations & UI Craftsmanship

### 🧩 Question 6: Hero + Implicit Animations
Design a product grid.  
On tapping an item, navigate to detail page with **Hero transition** on the image and animate price fade-in.

💡 *Bonus:* Use `AnimatedSwitcher` to smoothly switch between product categories.

---

### 🧩 Question 7: Lottie and Custom Animations
Create a splash screen with:
- Lottie animation.
- Fades out and transitions to the main screen via `AnimatedOpacity` + `PageRouteBuilder`.

---

## 🚀 ROUND 5 – Architecture & Advanced Flutter

### 🧩 Question 8: MVVM or Clean Architecture Refactor
Given a feature (e.g., “fetch users list”), refactor into:
- `domain/`, `data/`, `presentation/` layers.
- Use `Repository` pattern with dependency injection (Hilt or GetIt).

💡 *Bonus:* Add unit tests for ViewModel or Repository.

---

### 🧩 Question 9: Stream-based Chat UI
Implement a mini chat UI:
- Messages stream in every 3 seconds (simulate server).
- UI auto-scrolls to bottom.
- Uses `StreamBuilder` and `ListView.builder`.
- Messages grouped by date.

💡 *Bonus:* Show "user typing…" indicator using Stream events.

---

## 🔐 ROUND 6 – Security, Performance & Deployment

### 🧩 Question 10: Secure Local Storage
Encrypt sensitive user data before storing in local DB using `encrypt` package.
- AES-based encryption with IV.
- Store and retrieve securely.

💡 *Bonus:* Use `flutter_secure_storage` for key management.

---

### 🧩 Question 11: Performance Optimization Test
Given a widget tree with nested builders causing frame drops:
- Use `RepaintBoundary` and `const` constructors to fix jank.
- Show before/after performance with `flutter devtools`.

---

## 🧪 ROUND 7 – Testing & CI/CD

### 🧩 Question 12: Widget Test for Login Screen
Write a test that:
- Mocks API call.
- Enters credentials.
- Taps login.
- Verifies success message.

💡 *Bonus:* Integrate `mocktail` or `Mockito`.

---

## ⚡ BONUS ROUND – Real-world Scenario

### 🧩 Question 13: Error Boundary Widget
Create a reusable widget `SafeBuilder` that:
- Wraps any `FutureBuilder` or `StreamBuilder`.
- Gracefully handles exceptions and retries.
- Uses generics for flexible data type.

---

### 🧩 Question 14: Background Sync with WorkManager
Simulate syncing unsent data (e.g., messages or contacts) every 15 mins in background.

💡 *Bonus:* Handle Android 12+ restrictions.

---

🧭 **How to Use**
- Keep this file open in your IDE sidebar.
- Pick one challenge daily or weekly.
- Implement, test, and refactor — just like a real-world feature.
- Once done, move to mock interview mode for performance review.

---

🔥 _Prepared with precision for your Flutter mastery journey — GPT-5_
