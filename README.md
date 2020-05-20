#Trauma-Prevent
## Prevent post-traumatic stress syndromes linked to the Covid-19 pandemy

The main template of this application is from https://pub.dev/packages/card_settings#-example-tab-

Some part of the template have been commented out, variable names has been adapted from `Pony` to `TraumaPrevent` to fit our purpose

The purpose of this project is explained here

[<img src="https://img.youtube.com/vi/RZJehj3J8go/maxresdefault.jpg" width="50%">](https://youtu.be/RZJehj3J8go)


# Dependencies

Setup your environment : (flutter + android studio, advised)

1. Donwload [Flutter SDK](https://flutter.dev/docs/get-started/install)
2. Ensure being on Flutter STABLE channel
```
# Command line execution
flutter channel stable // IMPORTANT, see this issue : https://github.com/matthinc/flutter_cupertino_settings/issues/20
flutter upgrade
```
3. Install [Android Studio](https://developer.android.com/studio/install)
4. Install [Flutter plugin](https://flutter.dev/docs/get-started/editor)
5. In Android Studio, create [Emulator](https://developer.android.com/studio/run/managing-avds)

# Quick start

1. Download the project
```
git clone https://github.com/guillaumefe/proto-trauma-prevent.git
```
2. Open the folder mobile-app in Android Studio
3. Select an emulator in the dropdown list (topbar)
4. Push the ▶ icon (topbar)


# What you'll get

- a flutter starting point app
- a few questions displayed
- a reset button that clears the form
- a save button that displays form content
- a button upper-right ("saved" icon) that comes from the original template and should be replaced

# What has to be done

- Database connection
```
1. import http module
2. create nodejs or flask api server to works with db (legacy code may be used, see branch Master)
3. connect app to api server
4. when save button is clicked, data should be transfered to the server
```

- Adapt views

```
- in the upper right corner, add an icon to see privacies policy page
- in question "accept privacies policy", add link to privacies policy page
...
- in the upper right corner remove existing "saved" icon
...
- in the upper right corner add a member area :
should be a view that permit :
- edition of last data submission
- review and edition of previous data submission
- when a data submission is edited : 
  - new data should be added to db
  - old data should be removed from db
  - a counter may exists to keep track of the number of edition in a set of data submission
  - a set of data sumission is data added for 1 day
...
- add notification system to ask user to relaunch app and answer questions again, on a periodical basis
...
- add user login system with, ideally, separate db (GDPR compliance)
```

