<p align="center">
  <img src="./assets/icons/icon.png" width="86" alt="UMMobile app icon" />
</p>

<p align="center">
  Mobile App for Montemorelos University
</p>

# Getting Started

## Before start
**Important:**

> 💡 First of all, you will have to communicate with the project leader to know all the details and to access the credentials to connect to some services like the identity server.

> ⚠️ Probably you will not be able to test all the functions, or at least the push notifications beacuse to send a push notification to sandbox you need access to other resources (a private API).

## Tools
Some tools you need to have installed are:
- Git
- Android SDK
- [Flutter](https://flutter.dev/docs/get-started/install)

## How to run
```sh
# clone the repository
git clone https://github.com/UMMobile/UMMobile.git

cd UMMobile

# Install the dependencies
flutter pub get

# Run the app
# You will need an emulator or a physical device to run
flutter run
```


# UMMobile public resources
- [UMMobile API](https://github.com/UMMobile/ummobile-api): The API that centralize the API calls to the university services.
- [`ummobile_sdk`](https://github.com/UMMobile/ummobile_sdk): The dart package that connects to the UMMobile API.
- [`ummobile_custom_http`](https://github.com/UMMobile/ummobile_custom_http): The custom GetConnect implementation to manage http calls. 
