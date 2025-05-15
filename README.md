🍳 AI Recipe Generator
Welcome to the AI Recipe Generator app! This Flutter-based project leverages AI to help food lovers create recipes from images. Simply capture or upload an image of ingredients, and the app will identify them, list them out, and generate a detailed recipe with steps, measurements, and allergy warnings. 🥗✨
🚀 Project Overview
The AI Recipe Generator is designed to make cooking easier and smarter. Using the Gemini API, the app identifies ingredients from images and generates a complete recipe, including:

Recipe name 📝
Ingredient measurements (customizable) 🥄
Step-by-step cooking instructions 🍴
Allergy warnings ⚠️

The app features a sleek UI with a light blue gradient background and a futuristic hexagon logo (created with Leonardo AI) that pulsates on the splash screen using Flutter's ScaleTransition. 🌟
🎯 Features

Ingredient Detection: Upload or capture an image, and the Gemini API identifies the ingredients. 📸
Recipe Generation: Get a detailed recipe with name, measurements, steps, and allergy warnings. 🍲
Stunning UI: Light blue gradient background with a pulsating logo animation on the splash screen. 🎨
Custom Hexagon Logo: Designed with Leonardo AI, used as both the app icon and splash screen logo. 🔳
Smooth Navigation: Transitions seamlessly from the splash screen to the home screen after the animation. 🏠

🛠️ Tech Stack

Frontend: Flutter (Dart) for cross-platform mobile development 📱
Backend API: Gemini API for ingredient detection and recipe generation 🧠
Design Tools: Leonardo AI for generating the hexagon logo 🎨
Animation: Flutter’s ScaleTransition for the pulsating logo effect ✨
Platforms: Android and iOS 🌍

📂 Project Structure
ai_recipe_generator/
├── android/               # Android-specific files
├── ios/                   # iOS-specific files
├── lib/                   # Main Flutter code
│   ├── main.dart          # Entry point with splash screen and logo animation
│   ├── home_screen.dart   # Home screen UI
│   ├── recipe_service.dart # Service to interact with Gemini API for ingredient detection and recipe generation
│   └── ...                # Other Dart files
├── assets/                # Assets folder
│   ├── images/            # Splash screen logo
│   │   └── final_logo.png
│   ├── icons/             # App icon
│   │   └── app_icon.png
└── pubspec.yaml           # Dependencies and assets configuration
![Project_Structure](https://github.com/user-attachments/assets/5fba6b9a-ecb7-4ea3-8443-2fb751388f0c)


⚙️ Setup Instructions
Follow these steps to run the project locally:
Prerequisites

Flutter: Install Flutter (version 3.0.0 or higher). Flutter Setup Guide
Dart: Comes with Flutter.
Gemini API Key: Obtain an API key from Google Cloud for the Gemini API. Get API Key

Steps

Clone the Repository:
git clone https://github.com/ahmedhafas105/ai_recipe_generator.git
cd ai_recipe_generator


Install Dependencies:
flutter pub get


Set Up the Gemini API:

Create a .env file in the root directory.
Add your Gemini API key:GEMINI_API_KEY=your_api_key_here


Use a package like flutter_dotenv to load the API key in your app.


Add the Logo:

Place the hexagon logo (final_logo.png) in assets/images/.
Place the app icon (app_icon.png, 1024x1024) in assets/icons/.
Update pubspec.yaml:flutter:
  assets:
    - assets/images/final_logo.png
    - assets/icons/app_icon.png




Generate App Icon:

Add flutter_launcher_icons to pubspec.yaml:dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/icons/app_icon.png"
  min_sdk_android: 21


Run:flutter pub run flutter_launcher_icons




Run the App:

Connect a device or start an emulator.
Run the app:flutter run





🎥 Usage Example

Launch the App:

See the splash screen with the pulsating hexagon logo (3-second animation). 🌟
Transitions to the home screen. 🏠


Generate a Recipe:

Upload an image of ingredients (e.g., tomatoes, onions, garlic).
The app identifies the ingredients using the Gemini API.
View the list of detected ingredients.
Proceed to generate a recipe:
Recipe Name: Tomato Garlic Soup
Ingredients: 
2 cups tomatoes (diced)
1 onion (chopped)
3 garlic cloves (minced)


Steps:
Sauté onions and garlic in a pot.
Add tomatoes and cook for 10 minutes.
Blend the mixture and serve hot.


Allergy Warning: Contains garlic—may cause reactions in sensitive individuals. ⚠️



📸 Screenshots

![IMG-20250515-WA0004](https://github.com/user-attachments/assets/28778b70-2115-421b-b5ba-d6614a3dee21)
![IMG-20250515-WA0001](https://github.com/user-attachments/assets/b71034fb-9c52-4356-94d3-68c63d3a0c8a)
![IMG-20250515-WA0002](https://github.com/user-attachments/assets/f5bed295-5ba8-44bd-b3f8-c0afa9143a54)
![IMG-20250515-WA0003](https://github.com/user-attachments/assets/831d0ce4-792c-4e11-b16d-70ad2079f69e)




Replace the placeholder links with actual screenshots of your app!
🤝 Contributing
Contributions are welcome! 🌟 Follow these steps:

Fork the repository.
Create a new branch (git checkout -b feature/your-feature).
Commit your changes (git commit -m 'Add your feature').
Push to the branch (git push origin feature/your-feature).
Open a Pull Request.


Email: ahmedhafas105@gmail.com  
LinkedIn: www.linkedin.com/in/ahmed-hafas-27379722a  
GitHub: ahmedhafas105


Happy cooking with AI! 🍳🤖
