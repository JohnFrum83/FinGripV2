# FinGrip Development Guide

## Development Environment Setup

### Required Tools
- Xcode 15.0+
- Swift 5.9+
- XcodeGen
- Git
- SwiftLint (recommended)

### Environment Setup Steps
1. Install Xcode from the Mac App Store
2. Install development tools:
   ```bash
   # Install Homebrew if not already installed
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   
   # Install required tools
   brew install xcodegen
   brew install swiftlint
   ```

## Architecture Overview

### MVVM Pattern
The app follows the Model-View-ViewModel (MVVM) architecture pattern:
- **Models**: Data structures and business logic
- **Views**: SwiftUI views for UI representation
- **ViewModels**: Business logic and state management
- **Managers**: Service layer for specific functionalities

### Key Components

#### Views
- `MainView`: Root view managing navigation flow
- `DashboardTabView`: Main tab-based navigation
- Feature-specific views in the Views directory
- Reusable components in Views/Components

#### ViewModels
- `ContentViewModel`: Main app state management
- `ProfileViewModel`: User profile management
- `SpendingCategoryViewModel`: Category management

#### Models
- `Transaction`: Financial transaction model
- `FinancialCategory`: Category classification
- `Challenge`: User challenges and goals
- `Subscription`: Subscription management

#### Managers
- `LocalizationManager`: Handles app localization
- Other service managers for specific features

## Coding Standards

### Swift Style Guide
- Follow Swift API Design Guidelines
- Use SwiftLint for code style enforcement
- Maintain consistent naming conventions

### File Organization
```
// MARK: - Properties
// MARK: - Initialization
// MARK: - View Building
// MARK: - Actions
// MARK: - Helper Methods
```

### Naming Conventions
- Use clear, descriptive names
- Follow Swift naming conventions
- Use consistent prefixes for related components

## Localization

### Adding New Strings
1. Add key to `LocalizationKey.swift`
2. Add translations to:
   - `Resources/Base.lproj/Localizable.strings`
   - `Resources/en.lproj/Localizable.strings`
   - `Resources/pl.lproj/Localizable.strings`

### Usage Example
```swift
Text(LocalizationKey.welcomeTitle.localized)
```

## Testing

### Unit Tests
- Write tests for all ViewModels
- Test business logic in isolation
- Use XCTest framework

### UI Tests
- Test critical user flows
- Verify UI components
- Test localization switching

## Build Process

### XcodeGen
The project uses XcodeGen for project file generation:
```bash
# Generate project files
xcodegen generate

# Clean build folder
rm -rf ~/Library/Developer/Xcode/DerivedData/FinGrip-*
```

### Build Configurations
- Debug: Development builds
- Release: Production builds
- Each with appropriate signing settings

## Dependency Management

### Current Dependencies
- SwiftUI
- Combine
- Charts

### Adding New Dependencies
1. Update `project.yml`
2. Regenerate project file
3. Document in README.md

## Common Tasks

### Adding a New Feature
1. Create feature branch
2. Add new models if needed
3. Create ViewModel
4. Implement Views
5. Add localization
6. Write tests
7. Update documentation

### Updating Localization
1. Add new keys to `LocalizationKey.swift`
2. Add translations to all `.strings` files
3. Test in all supported languages

### Performance Optimization
- Use Instruments for profiling
- Monitor memory usage
- Optimize image assets
- Cache expensive computations

## Troubleshooting

### Common Issues
1. Build Errors
   - Clean build folder
   - Regenerate project file
   - Check signing settings

2. Localization Issues
   - Verify all keys exist
   - Check string file formatting
   - Clear derived data

3. UI Issues
   - Check device compatibility
   - Verify constraints
   - Test different screen sizes

## Release Process

### Pre-release Checklist
1. Update version numbers
2. Run all tests
3. Check localization
4. Verify build settings
5. Test on multiple devices
6. Update documentation

### Release Steps
1. Create release branch
2. Update changelog
3. Tag release
4. Build production version
5. Submit to App Store

## Security

### Best Practices
- Secure user data
- Use keychain for sensitive info
- Implement proper authentication
- Follow Apple privacy guidelines

### Data Protection
- Encrypt sensitive data
- Use secure networking
- Implement proper access control

## Support

### Resources
- Apple Developer Documentation
- SwiftUI Documentation
- Internal Wiki (if available)

### Getting Help
- Check existing documentation
- Review similar issues
- Contact team lead 