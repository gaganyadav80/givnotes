# givnotes

Where your notes meet beautiful UI

## Getting Started

Fork or clone the repository. You can also download it as zip file.

### **Now here are the points to note**
- 1 edited package (redesigned UI for lock screen) is included in the lib folder itself.
- 2 packages (Zefyr Editor and AppLock) are edited by me and they are very minor changes so not included in this repository. 
- You also have to replace them in your $FLUTTER_HOME/.pub-cache/hosted/pub.dartlang.org/
- $FLUTTER_HOME is the directory where you have extracted your flutter bin files.
- Download the zip from origin/edited-packages/flutter-packages.zip
- Extract and replace at the location mention in point 2

### Google Sign-in
- This app uses google sign-in. 
- You'll have to add your `google-services.json` file from your firebase console.
- You can google on how to add google signin to your firebase flutter app.

### Gradle Version
I am using the gradle-6.4-rc-4-all version which I defined manually. If you want to avoid downloading gradle dist again and save some pitty 250MB of your data then edit your `gradle-wrapper.properties` file under `android\gradle\wrapper\`

Replace (under `gradle-wrapper.properties`):

```
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-6.4-rc-4-all.zip
```

To this:

```
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/(your-gradle-dist-version).zip
```

You can find your gradle dist version in `$HOME/.gradle/wrapper/dist/`. The folder names inside this directory will be your-gradle-dist-version.
