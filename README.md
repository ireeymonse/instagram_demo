# Social Post Search Demo

iOS app that uses the Instagram API to see Instagram posts around your area.

## Requirements

- iOS 10+
- XCode 9.4.1
- Swift 4

## How to use it

- To launch the app, just clone the repository in your computer and open `SocialPostSearchDemo.xcworkspace`. Pods are already included.
- A login screen is setup, but won't appear: there's an access token hardcoded in the `AppDelegate`. You can comment it for  validation purposes.
- In case the token is lo longer working, please contact me so I can provide you a new one.
- Location access is working, and the app should tell you your nearest Instagram location name. 
- Due to the current sandbox state of the project, only posts from two accounts will appear, so please deny permission to location or turn it off, so it can fallback to a default location where all posts appear.
- Change the distance to see different amounts of posts appear in the list.

### Running the tests

- To run the tests, select an iPhone simulator or device with Internet connection, go to the Test Navigator and hit play on the `SocialPostSearchDemoTests`, 
