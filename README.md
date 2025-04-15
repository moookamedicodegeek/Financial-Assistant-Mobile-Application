💸 FlowFinance
FlowFinance is a cross-platform finance management system built on Firebase, enabling users to seamlessly manage their financial profiles and activities from both a web app (ASP.NET MVC) and a mobile app (Flutter/Dart). Whether you're budgeting, saving, or viewing your virtual card — FlowFinance connects it all.

🧩 Features
🌐 Web Application (ASP.NET Core MVC with Razor)
Built using C#, Razor Views, and MVC architecture.
Firebase Authentication and Realtime Database integration.
User registration and profile management.
Automatic generation of a virtual card account number.
Profile data linked to Firebase Auth UID.
Upload and view profile images.
Download the mobile application (.apk or link) directly from the web app.
Role-based UI rendering with view filters and authentication guards.
📱 Mobile Application (Flutter/Dart)
Firebase-authenticated login (same UID as web).
Retrieve and view synced profile data.
Virtual card viewing.
Finance dashboard with analytics charts.
Light/Dark mode toggle.
Budget tracking and savings visualization.
Chatbot support via DialogFlow integration.
Push notifications using Firebase Cloud Messaging (FCM).
Smooth and intuitive user interface.
🔧 Technologies Used
Platform	Tech Stack
Web App	ASP.NET Core MVC, Razor, C#
Mobile App	Flutter, Dart
Backend	Firebase (Auth, Realtime DB, FCM)
ML/AI	Dialogflow (Chatbot NLP)
🔐 Firebase Architecture Overview
Firebase Authentication
Handles secure user sign-in/sign-up across web and mobile. A unique UID is generated for each user.

Realtime Database
Stores user profile data using the Firebase UID as the key. Ensures consistency between platforms.

Cloud Messaging (FCM)
Used to send real-time push notifications to mobile devices.

Dialogflow
Powers the AI chatbot integrated into the mobile app.

📝 How It Works
User Registers on Web

Signs up using Firebase Authentication.
Profile is created and stored in Firebase Realtime DB using the UID.
A unique 10-digit virtual card number is generated and stored.
The user can download the mobile app from the web portal.
User Logs in via Mobile App

Uses the same Firebase Auth account.
Retrieves the profile using the UID.
All linked data is displayed — profile, card, analytics, etc.
In-App Features

Toggle dark/light mode.
Create Budgets , Add Transactions
View savings, transaction history.
Use chatbot trained with Dialogflow.
Get notifications via FCM.
🚀 Getting Started
🔧 Setup for Web App
Clone the repository:
git clone https://github.com/your-username/FlowFinance.git
cd FlowFinance/Web
Open in Visual Studio.

Configure Firebase settings:

Set AuthSecret and BasePath in UserController.cs.

Run the project:

bash Copy Edit dotnet run 📲 Setup for Mobile App Navigate to /MobileApp directory.

Run the Flutter project:

bash Copy Edit flutter pub get flutter run Ensure google-services.json (for Android) or GoogleService-Info.plist (for iOS) is added to the respective folders.

📦 APK Download The latest mobile build can be downloaded from the 📥 Web App Portal.

🤝 Contributing Want to improve FlowFinance? Open a pull request or file an issue! We're excited to collaborate with developers who care about fintech and cross-platform development.

🙌 Acknowledgements Mohau Letooane Kgauhelo Lebakeng Relesego Mothibi Tshepo Motebele Mookamedi Casious

Firebase

ASP.NET Core

Flutter

Dialogflow
