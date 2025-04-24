# FinGrip - Personal Finance Management App

## Overview
FinGrip is a comprehensive personal finance management application built with SwiftUI. It helps users track their expenses, set financial goals, analyze spending patterns, and improve their financial health through personalized insights and recommendations.

## Features

### 1. Financial Dashboard
- Real-time overview of total balance
- Income and expense tracking
- Quick access to financial score
- Active challenges and goals

### 2. Analytics
- Spending pattern analysis
- Category-wise expense breakdown
- Financial trends visualization
- Custom period analysis (weekly/monthly/yearly)

### 3. Goal Management
- Create and track financial goals
- Progress monitoring
- Smart recommendations
- Achievement celebrations

### 4. Transaction Management
- Easy transaction recording
- Category classification
- Transaction history
- Search and filtering capabilities

### 5. Subscription Management
- Track recurring subscriptions
- Payment cycle monitoring
- Category-based organization
- Cost optimization suggestions

### 6. Localization
- Multi-language support (English, Polish)
- Currency customization
- Regional format adaptation

### 7. Financial Health Score
- Comprehensive financial health assessment
- Score breakdown and insights
- Improvement recommendations
- Progress tracking

## Technical Architecture

### Core Components
- SwiftUI-based UI layer
- MVVM architecture
- Modular component design
- Robust data management

### Key Technologies
- SwiftUI
- Combine framework
- Charts framework
- XcodeGen for project management

## Setup Instructions

### Prerequisites
- Xcode 15.0 or later
- iOS 17.0+ deployment target
- XcodeGen installed

### Installation Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/YourUsername/FinGrip.git
   ```

2. Install XcodeGen if not already installed:
   ```bash
   brew install xcodegen
   ```

3. Generate Xcode project:
   ```bash
   cd FinGrip
   xcodegen generate
   ```

4. Open the generated Xcode project:
   ```bash
   open FinGrip.xcodeproj
   ```

5. Build and run the project in Xcode

## Project Structure

```
FinGrip/
├── Views/
│   ├── Components/         # Reusable UI components
│   ├── MainView.swift      # Root view
│   └── Feature views      # Feature-specific views
├── ViewModels/            # MVVM view models
├── Models/                # Data models
├── Managers/              # Service managers
├── Extensions/           # Swift extensions
├── Resources/            # Localization and assets
│   ├── en.lproj/        # English localization
│   └── pl.lproj/        # Polish localization
└── Utilities/           # Helper utilities
```

## Localization

The app supports multiple languages with a robust localization system:
- Base language: English
- Additional languages: Polish
- Localization keys are managed through `LocalizationKey.swift`
- String resources are organized in `.lproj` directories

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Version History

- v1.0: Initial release
  - Core financial management features
  - Multi-language support
  - Basic analytics

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- SwiftUI framework
- Apple Charts framework
- XcodeGen team
- Contributors and testers

## Contact

Your Name - [@YourTwitter](https://twitter.com/YourTwitter)
Project Link: [https://github.com/YourUsername/FinGrip](https://github.com/YourUsername/FinGrip) 