# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A minimal SwiftUI demo app showing how to integrate the **Bridgee iOS SDK** (user attribution / UTM tracking) together with **Firebase Analytics** as the analytics provider. The whole app is two Swift files — `BridgeeIOSExampleApp.swift` (SDK setup) and `ContentView.swift` (form UI + `firstOpen` call). Its purpose is to be reference material for SDK consumers, not a production product.

## Build & run

- Open `BridgeeIOSExample.xcodeproj` in Xcode 15+ and run (`Cmd+R`). There is no test target.
- CLI build: `xcodebuild -project BridgeeIOSExample.xcodeproj -scheme BridgeeIOSExample -destination 'platform=iOS Simulator,name=iPhone 15' build`
- SPM dependencies are resolved by Xcode; the first open will fetch `firebase-ios-sdk` and `bridgee-ios-sdk`.
- Deployment target: iOS 14. Bundle id: `com.example.BridgeeIOSExample`.

## Dependency management — important gotcha

Dependencies are declared **in `BridgeeIOSExample.xcodeproj/project.pbxproj`** as Xcode SPM package references (`firebase-ios-sdk` ≥ 12.4.0 and `bridgee-ios-sdk` ≥ 1.1.1). The `Package.swift` at the repo root is **not** what builds the app — it's a stub that references only Firebase and no Bridgee SDK. When bumping SDK versions or adding dependencies, edit the Xcode project (or the `XCRemoteSwiftPackageReference` entries in `project.pbxproj`), not `Package.swift`.

## Runtime configuration

Two placeholder values must be replaced before the app does anything meaningful:

1. `BridgeeIOSExample/GoogleService-Info.plist` — a 95-byte placeholder; replace with a real Firebase config file. This file is committed but gitignore should prevent real creds from being committed.
2. `tenantId` / `tenantKey` strings in `BridgeeIOSExampleApp.swift` — supplied by Bridgee.

`dryRun: false` in `configure(...)` hits production Bridgee infra; flip to `true` for local testing.

## Architecture (the one thing that spans files)

`BridgeeSDK.shared.configure(provider:...)` takes an `AnalyticsProvider` conforming type. This repo implements `FirebaseAnalyticsProvider` (in `BridgeeIOSExampleApp.swift`) which bridges Bridgee's analytics calls to `Firebase Analytics.*`. To swap analytics backends (Mixpanel, Amplitude, etc.), write a new `AnalyticsProvider` class — do **not** modify Bridgee SDK internals.

The user-visible flow: `ContentView` collects name/email/phone → builds a `MatchBundle` → calls `BridgeeSDK.shared.firstOpen(with:)` → the completion receives either a `UTMData` or an error string. This is the only SDK entry point the example exercises.
