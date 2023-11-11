# gotham_city_interface_mobile

(ref. https://capacitorjs.com/docs/getting-started#add-capacitor-to-your-web-app)
(this documentation is only referred to the build of Android application, for iOS application, should not have too much diff -> check official documentation)

## How to add Capacitor to the webapp ?

1. Install Capacitor
```shell
npm install @capacitor/core @capacitor/cli
```
2. Initialize Capacitor configuration
```shell
npx cap init
```
3. Create Android application
```shell
npm i @capacitor/android
```
Verify that the platform is added to ```package.json```

Then do ```npx cap add android``` to create native app

4. Sync web code to native project
```shell
npx cap sync
```

5. Run the application
```shell
npx cap run android
```
This commands will navigate you to Android Studio and build the application based on the ```/android``` folder
After every indexing steps, all you have to do is to build the project on an Android emulator (see more below)

# Problems that can be encoutered during installation
- Android SDK / API / Emulator:
  - We suggest to install Android Studio instead of install the SDK separately to avoid all issues 
  - Create an emulator based on the API that's available after installing Android Studio (API 34)

- Gradle:
  - Make sure that you have a recent version of Java and also a Gradle that supports this Java version.
  