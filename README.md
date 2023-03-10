[![badge_flutter]][link_flutter_release]

# magic_record
**Goal**: A Flutter project to manage voice recorder.

## Requirements
* Computer (Windows, Mac or Linux)
* Android Studio

## Setup the project in Android studio
1. Download the project code, preferably using `git clone git@github.com:YannMancel/magic_record.git`.
2. In Android Studio, select *File* | *Open...*
3. Select the project

## Dependencies
* Flutter Version Management
  * [fvm][dependencies_fvm]
* Linter
  * [flutter_lints][dependencies_flutter_lints]
* Audio
  * [record][dependencies_record]
  * [just_audio][dependencies_just_audio]
* Permissions
  * [permission_handler][dependencies_permission_handler]
* State Manager
  * [provider][dependencies_provider]
* Data Class Generator
  * [build_runner][dependencies_build_runner]
  * [freezed][dependencies_freezed]
  * [freezed_annotation][dependencies_freezed_annotation]
* Local Storage
  * [hive][dependencies_hive]
  * [hive_flutter][dependencies_hive_flutter]
* Date
  * [intl][dependencies_intl]

## Troubleshooting

### No device available during the compilation and execution steps
* If none of device is present (*Available Virtual Devices* or *Connected Devices*),
    * Either select `Create a new virtual device`
    * or connect and select your phone or tablet

## Useful
* [Download Android Studio][useful_android_studio]
* [Create a new virtual device][useful_virtual_device]
* [Enable developer options and debugging][useful_developer_options]

[badge_flutter]: https://img.shields.io/badge/flutter-v3.7.0-blue?logo=flutter
[link_flutter_release]: https://docs.flutter.dev/development/tools/sdk/releases
[app_hosting]: https://l-atelier-des-souvenirs.web.app
[dependencies_fvm]: https://fvm.app/
[dependencies_flutter_lints]: https://pub.dev/packages/flutter_lints
[dependencies_record]: https://pub.dev/packages/record
[dependencies_just_audio]: https://pub.dev/packages/just_audio
[dependencies_permission_handler]: https://pub.dev/packages/permission_handler
[dependencies_provider]: https://pub.dev/packages/provider
[dependencies_build_runner]: https://pub.dev/packages/build_runner
[dependencies_freezed]: https://pub.dev/packages/freezed
[dependencies_freezed_annotation]: https://pub.dev/packages/freezed_annotation
[dependencies_hive]: https://pub.dev/packages/hive
[dependencies_hive_flutter]: https://pub.dev/packages/hive_flutter
[dependencies_intl]: https://pub.dev/packages/intl
[useful_android_studio]: https://developer.android.com/studio
[useful_virtual_device]: https://developer.android.com/studio/run/managing-avds.html
[useful_developer_options]: https://developer.android.com/studio/debug/dev-options.html#enable
