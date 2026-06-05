FROM ghcr.io/cirruslabs/flutter:stable

# Base image already includes: Flutter, Dart, Java 21, Android SDK (API 36,
# build-tools 36, emulator, platform-tools) at /opt/android-sdk-linux.
# Nothing extra to install — just fix ENV vars and set the working directory.

ENV ANDROID_SDK_ROOT=/opt/android-sdk-linux
ENV ANDROID_HOME=/opt/android-sdk-linux
ENV PATH="${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${PATH}"

# Accept SDK licenses non-interactively so flutter doctor is clean
RUN yes | sdkmanager --licenses > /dev/null 2>&1 || true

# Expose ADB port
EXPOSE 5037

WORKDIR /workspace
