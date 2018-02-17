# Critic

[![CI Status](http://img.shields.io/travis/inventiv-llc/inventiv-critic-ios.svg?style=flat)](https://travis-ci.org/inventiv-llc/inventiv-critic-ios)
[![Version](https://img.shields.io/cocoapods/v/Critic.svg?style=flat)](http://cocoapods.org/pods/Critic)
[![License](https://img.shields.io/cocoapods/l/Critic.svg?style=flat)](http://cocoapods.org/pods/Critic)
[![Platform](https://img.shields.io/cocoapods/p/Critic.svg?style=flat)](http://cocoapods.org/pods/Critic)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

1. Add the Critic pod to your `Podfile`.
```ruby
pod 'Critic'
```
2. Find your Product Access Token in the [Critic Web Portal](https://critic.inventiv.io/products) by viewing your Product's details.
3. Initialize Critic by starting it from your `AppDelegate`.
```swift
Critic.instance().start("YOUR_PRODUCT_ACCESS_TOKEN")
```

By default, devices that are not connected to a debug session will pipe console output (`stderr` and `stdout`) to a log file, which is 
included with submitted Reports. You can disable this behavior prior to starting Critic.
```swift
Critic.instance().shouldLogToFile = false;
Critic.instance().start("YOUR_PRODUCT_ACCESS_TOKEN")
```

## Sending Customer Feedback Reports

You can show the default feedback report screen any time you like by calling the following method from a UIViewController.
```swift
Critic.instance().showDefaultFeedbackScreen(self)
```

## Customizing Feedback Reports


## License

This library is released under the MIT License.
