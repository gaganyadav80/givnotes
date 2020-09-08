# givnotes

Where your notes meet beautiful UI

## Getting Started

Fork or clone the repository. You can also download it as zip file.

### *Now here are the points to note*
- 3 packages are edited by me. 
- So, you also have to replace them in your $FLUTTER_HOME/.pub-cache/hosted/pub.dartlang.org/
- $FLUTTER_HOME is the directory where you have extracted your flutter files.
- Download the zip from origin/edited-packages/flutter-packages.zip
- Extract and replace at the location mention in point 2

### Gradle Version
I am using the gradle-6.4-rc-4-all version which I defined manually. If you want to avoid downloading gradle dist again and save some pitty 250MB of your data and edit your `gradle-wrapper.properties` file under `android\gradle\wrapper\`

Replace this
```
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-6.4-rc-4-all.zip
```
To this
```
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/(your-gradle-dist-version).zip
```

You can find your gradle dist version in `$HOME/.gradle/wrapper/dist/`. The folder names inside this directory will be your-gradle-dist-version.
