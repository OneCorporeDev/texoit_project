---
runme:
  id: 01HVYF2BWX0FG9F5EQ1EMTR6HN
  version: v3
---

# TEXOIT

TEXOIT is a Flutter project designed for a job position test. It utilizes Flutter and Melos to manage multi-package repositories efficiently. This README provides an overview of how to set up your development environment and execute common commands using Melos.

## Getting Started

### Prerequisites

Before you start, you need to have Flutter installed on your system. If you haven't already installed Flutter, follow these steps:

1. Download the Flutter SDK from the [Flutter official website](https://flutter.dev/docs/get-started/install).
2. Extract the file in a desired location.
3. Add Flutter to your path:
   - On Windows, update your user environment variable `Path` to include the `flutter\bin` directory.
   - On macOS and Linux, perform the equivalent operation in your shell's configuration file.

### Installing Melos

> Melos is a tool that helps manage Dart & Flutter projects with multiple packages.

To install Melos, run the following command:

```sh {"id":"01HVYFBND23F6R1TJWNG7GC3ZD"}
flutter pub global activate melos
```

### Setting Up the Project

Once you have Flutter and Melos installed, you can set up the TEXOIT project:

```sh {"id":"01HVYFAVFESM8Q9CG35W4ZWBVK"}
git clone <repository-url>
cd texoit
# Run melos bootstrap to install dependencies
melos bootstrap
```

## Project Commands

Here is a list of available Melos scripts that help manage the project:

### Run

> To run this project in debug mode, you can simply open this project root folder in vscode and press F5.

Or use the following command:

```sh {"id":"01HVYFDYQZQZQZQZQZQZQZQZQZ"}
melos run start
```

### Analyze

> Runs flutter analyze in all packages to identify any static analyses issues.

```sh {"id":"01HVYFQRQ4C3Q47V5WBX3M9EMF"}
 melos run analyze
```

### Clean

> Cleans up the build by deleting temporary files, ensuring a fresh state for new builds.

```sh {"id":"01HVYFTWHZMP26QBZ3GP0F7ZH4"}
melos clean
```

### Test

> Runs unit tests available in the project. It only runs tests if a test directory exists.

```sh {"id":"01HVYFY3EH9Y13EYBE9GS40PSZ"}
melos test
```

### Test with Fail Fast

> Runs unit tests available in the project. It stops the execution on the first failed test.

```sh {"id":"01HVYFZ9WHGTY1A320ZWVWMBB2"}
melos test-fail_fast
```

### Code Test Coverage

> Generates a code coverage report for the tests. It may include a custom script to combine coverage data.

```sh {"id":"01HVYG1JEJHZ1SPZJJYJQX0H45"}
melos run coverage
```

### Web Deployment

> Builds the project for web release, optimized with the HTML renderer.

```sh {"id":"01HVYG62W1QEQRN9W345F71S4K"}
melos web_deploy
```

### Android Deployment

> Compiles the project into an APK for Android devices.

```sh {"id":"01HVYG6YT2W5CK93WCWFC6P03E"}
melos android_deploy
```

### Cache Repair

> Repairs Flutter pub caches to fix potential issues with package dependencies.

```sh {"id":"01HVYG82S1P5F752FJTKDCWDCB"}
melos cache_repair
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.