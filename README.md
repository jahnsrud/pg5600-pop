![pop](https://user-images.githubusercontent.com/4276097/70216662-4a4b0e00-1740-11ea-8382-543dcd9b3ee6.png)

# Pop for iOS
My exam in PG5600: iOS Programming at Høyskolen Kristiania.

Candidate #5028

[📽 See video](https://youtu.be/N65Q7FBs5nw)

## What is Pop?

A place to discover music. The app shows you the top 50 albums of all time. You can browse music, along with saving your favorites. The data is provided by TheAudioDB. Suggestions are from Tastedive. 

## Solution

For this exam, I wanted to go all in iOS 13 and leaving old APIs behind. Just because I had the possibility to try that. The app covers all requirements from the task, and I'm quite happy with the result.

The project had no warnings when built with Xcode 11.2.1 (11B500). I have used Core Data to persist the user's favorited tracks. 

### Extra functionality
* Optimised for iOS 13
* Dark Mode
* First Launch experience
* Full screen embedded video when opening a track. Available on tracks where TheAudioDB has provided a YouTube URL. I'm using XCDYouTubeKit to get the correct URL.
* A link for searching tracks in Spotify. If Spotify is installed (spotifty://) then a button will be displayed to the user
* Empty State
* Search for albums and artists
* Haptic Feedback using UINotificationFeedbackGenerator
* Keyboard handling
* URL Scheme pop://
* Animated switching of layouts
* Improvements to UITableView editing: hiding duration label when rearranging, using an icon instead of the default "Delete" text when using swipe to delete
* Support for browsing suggested artists. The Tastedive API only gets suggested artists by their name, not any identifier. Therefore the ArtistViewController accepts both artistId or artist name. If provided with an artist's name, the appropriate call will be made to TheAudioDB. 
* Asset catalogs with grouped contents. Colors are in one folder, icons in another. Assets also have appropriate resources for the "Any" and "Dark" appearances.
* Pull to refresh
* Highlight UICollectionView cells on tap
* Registering standard User Defaults in didFinishLaunchingWithOptions

### What could've been better

* Search should have included tracks
* Searching uses too many network resources 
* The NetworkClient has room for improvements
* Improved handling of non-optimal Internet connections
* Using the UITabBar for navigation. For example double tapping "Search" should open the keyboard focused on the search field in SearchViewController. 
* Improved code and moved more heavy lifting out of the UIViewController

## Libraries

I used two libraries in the exam. All installed with SPM (Swift Package Manager).

| Library        | Version      | Description  |
| :------------- |:-------------|:-----|
| Kingfisher   | 5.9.0 | Image Caching |
| XCDYouTubeKit  | 2.8.2     |   Embedded YouTube videos |

I used Kingfisher for remote image handling. It's of course possible to implement image handling manually, but the library has a good API and is quite lightweight. 

Kingfisher is one of many 3rd party image frameworks. I decided to use Kingfisher because there was no need to reinvent the wheel. The most important features are caching and placeholder support. A bit strange that there isn't a simply, native API for this yet. 

XCDYouTubeKit is a great way to get a YouTube video's URL. I used this URL to have a  AVPlayerViewController that fills the Track View Controller. My app would probably be rejected by Apple because it is [against YouTube's Terms of Service.](https://github.com/0xced/XCDYouTubeKit#warning)


## Screenshots

![pop-screenshot](https://user-images.githubusercontent.com/4276097/70221952-8171ed00-1749-11ea-80a7-505d2e67704a.png)
