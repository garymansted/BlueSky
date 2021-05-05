# BlueSky
Small app for a coding challenge in SWIFT 4  **EDIT:** *Updated to Swift 5*

## Release Notes:
**iForget** is written in `Swift ~> 5.0`.<br>
iOS `Target: ~> 10.3` <br>
Initially Built in `Xcode 10` - Currently will build in `Xcode 12.3`<br> 
Project uses **Storyboards**<br>
Developed for the iPhone (*iPhone 5 ~> current model*)<br>

## Build Details 
*Architecture:* MCV Pattern<br>
*Frontend:* iOS<br>
*Backend:* Nil<br>

<p align="left">
    <img src="/repo/BlueSkyDemo.gif" width="225" height="451" title="BlueSky - Coding Challenge App">
    <img src="/repo/BlueSky_Image_10.png" width="169" height="365" title="BlueSky - Coding Challenge App">
    <img src="/repo/BlueSky_Image_3.png" width="169" height="365" title="BlueSky - Coding Challenge App">
    <img src="/repo/BlueSky_Image_6.png" width="169" height="365" title="BlueSky - Coding Challenge App">
    <img src="/repo/BlueSky_Image_9.png" width="169" height="365" title="BlueSky - Coding Challenge App">
    <img src="/repo/BlueSky_Image_7.png" width="169" height="365" title="BlueSky - Coding Challenge App">
    <img src="/repo/BlueSky_Image_11.png" width="169" height="365" title="BlueSky - Coding Challenge App">
</p>

## Installation 
BlueSky uses `Cocoapods`. Make sure you have `Cocoapods` installed.<br>
`Pods` are included in the repo so you only need to clone the project and open the `.xcworkspace` 
You'll need to get and change a couple of keys in the apps config file. The keys you need are: an IOS Google Maps API key (Google Developers Console) & an Open Weather Maps API key (https://openweathermap.org/api). 

## Requirements 
### Backlog
- Check out the [Coding Assignment](/Coding%20Assignment%20-%20v1.2.pdf) PDF for functionality specifics.
- Use a UITableViewController to display weather information of Sydney, Melbourne and Brisbane as start.
- Provide a way to add more cities using another modal view controller which includes a search functionality to find a city by name or location.
- City IDs - Sydney, Melbourne and Brisbane are: 4163971, 2147714, 2174003 
- Each cell should display at least two pieces of info: Name of city on the left, temperature on the right.
- Weather should be automatically updated periodically.
- Use Storyboard and Autolayouts.
- It is fine to use 3rd party libraries via CocoaPods or by other means.
##### Brownie Points:
- Use an activity indicator to provide some feedback to user while waiting for network response.
- Allow user to tap on a cell to open a new “Detail view”, to show more information about the city such as current weather summary, min and max temperature, humidity, etc.
- Try to use table view or collection view to display details.
- In the “Detail view”, implement animations to enhance the user experience.
- Support all different dimensions of the devices.
- Support landscape and portrait view together<br/>

```
Frameworks and third party librarys include:
UIKit
Alamofire
AlamofireImage
GoogleMaps
```
