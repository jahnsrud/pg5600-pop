![pop](https://user-images.githubusercontent.com/4276097/70216662-4a4b0e00-1740-11ea-8382-543dcd9b3ee6.png)

# Pop for iOS
My exam in PG5600: iOS Programming at Høyskolen Kristiania.

Candidate #5028

[📽 See video](https://youtu.be/N65Q7FBs5nw)

## What is Pop?

A place to discover music. The app shows you the top 50 albums of all time. You can browse music, along with saving your favorites. The data is provided by TheAudioDB. Suggestions are provided by Tastedive. 

## Solution

For this exam, I wanted to go all in iOS 13 and leaving old APIs behind. Just because I had the possibility to try that. I tried to make Pop into a concept.  

The app covers all requirements from the task. I have used Core Data to persist the user's favorited tracks. 


### Extra functionality
* Optimised for iOS 13
* Dark Mode
* Empty State
* First Launch experience
* YouTube integration
* Haptic Feedback using UINotificationFeedbackGenerator
* Keyboard handling
* URL Scheme pop://
* Animated switching of layouts
* Improvements to UITableView editing: hiding duration label when rearranging, using an icon instead of the default "Delete" text when using swipe to delete
* Support for browsing suggested artists (not only displaying)
* Color asset catalogs
* Pull to refresh
* Highlight UICollectionView cells on tap
* User Defaults Defaults


## Libraries

I have used two libraries in the exam. All installed with SPM (Swift Package Manager).

| Library        | Version      | Description  |
| :------------- |:-------------|:-----|
| Kingfisher   | 5.9.0 | Image Caching |
| XCDYouTubeKit  | 2.8.2     |   Embedded YouTube videos |

I've used Kingfisher for remote image handling. It's of course possible to implement image handling manually, but the library is incredibly good and quite lightweight.

Good performance. Don't need to reinvent the wheel. Good for caching and placeholder. 

Strange that there isn't a native API for this yet. 

XCDYouTubeKit was a great way to get a YouTube video's URL. It would probably be rejected by Apple because it is [against YouTube's Terms of Service.](https://github.com/0xced/XCDYouTubeKit#warning)


## Screenshots


