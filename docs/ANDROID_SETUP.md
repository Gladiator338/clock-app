# Android command-line tools setup (macOS)

## 0. Install Java (required for sdkmanager)

The Android command-line tools need a Java runtime. Install one of:

```bash
brew install openjdk@17
```

**Make sure your shell can find Java.** Add this to `~/.zshrc` (if not already there):

```bash
# Java (for Android sdkmanager)
export JAVA_HOME=/usr/local/opt/openjdk@17   # Apple Silicon: use /opt/homebrew/opt/openjdk@17
export PATH="$JAVA_HOME/bin:$PATH"
```

Then run `source ~/.zshrc` or open a **new terminal**. Verify with `java -version` and `sdkmanager --version`.

---

## 1. Create SDK directory and move tools

**Already done** if you ran the project setup: the tools were moved from `~/Downloads/cmdline-tools` to `~/Library/Android/sdk/cmdline-tools/latest`.

If starting from scratch (tools still in Downloads):

```bash
mkdir -p ~/Library/Android/sdk/cmdline-tools
mv ~/Downloads/cmdline-tools ~/Library/Android/sdk/cmdline-tools/latest
```

(Android expects `cmdline-tools/latest/` under the SDK root.)

## 2. Set ANDROID_HOME, JAVA_HOME, and PATH

**Already done** if you ran the project setup: the following was added to `~/.zshrc`.

```bash
# Android SDK (command-line tools)
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools
```

Then reload your shell:

```bash
source ~/.zshrc
```

## 3. Accept licenses and install components

```bash
yes | sdkmanager --licenses
sdkmanager --install "platform-tools" "build-tools;34.0.0" "platforms;android-34"
```

(Use `android-34` or the API level your Flutter project targets.)

## 4. Verify

```bash
echo $ANDROID_HOME
sdkmanager --list
flutter doctor
```

You should see the Android toolchain marked as OK in `flutter doctor`.

## If you prefer to keep tools in Downloads

You can point ANDROID_HOME at a folder that contains `cmdline-tools/latest`:

```bash
mkdir -p ~/Downloads/android-sdk/cmdline-tools
mv ~/Downloads/cmdline-tools ~/Downloads/android-sdk/cmdline-tools/latest
export ANDROID_HOME=$HOME/Downloads/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools
```

Then run step 3 from the same shell (and add the `export` lines to `~/.zshrc` if you want them permanent).
