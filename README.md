# RxTheme

[![Build Status](https://travis-ci.org/RxSwiftCommunity/RxTheme.svg?branch=master)](https://travis-ci.org/RxSwiftCommunity/RxTheme)
[![Version](https://img.shields.io/cocoapods/v/RxTheme.svg?style=flat)](http://cocoapods.org/pods/RxTheme)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/RxTheme.svg?style=flat)](http://cocoapods.org/pods/RxTheme)
[![Platform](https://img.shields.io/cocoapods/p/RxTheme.svg?style=flat)](http://cocoapods.org/pods/RxTheme)

## Manual

### Define theme service

```swift
import RxTheme

protocol Theme {
    var backgroundColor: UIColor { get }
    var textColor: UIColor { get }
}

struct LightTheme: Theme {
    let backgroundColor = .white
    let textColor = .black
}

struct DarkTheme: Theme {
    let backgroundColor = .black
    let textColor = .white
}

enum ThemeType: ThemeProvider {
    case light, dark
    var associatedObject: Theme {
        switch self {
        case .light:
            return LightTheme()
        case .dark:
            return DarkTheme()
        }
    }
}

let themeService = ThemeType.service(initial: .light)
```

### Apply theme to UI

```swift

// Bind stream to a single attribute
// In the way, RxTheme would automatically manage the lifecycle of the binded stream
view.theme.backgroundColor = themeService.attribute { $0.backgroundColor }

// Or bind a bunch of attributes, add them to a disposeBag
themeService.rx
    .bind({ $0.textColor }, to: label1.rx.textColor, label2.rx.textColor)
    .bind({ $0.backgroundColor }, to: view.rx.backgroundColor)
    .disposed(by: disposeBag)
```

All streams generated by `ThemeService` has `share(1)`

### Switch themes

```swift
themeService.switch(.dark)
// When this is triggered by some signal, you can use:
someSignal.bind(to: themeService.switcher)
```

### Other APIs

```swift
// Current theme type
themeService.type
// Current theme attributes
themeService.attrs
// Theme type stream
themeService.typeStream
// Theme attributes stream
themeService.attrsStream
```

### Extend binders in your codebase

Because RxTheme uses `Binder<T>` from RxCocoa, any `Binder` defined in RxCocoa could be used here.

This also makes the lib super easy to extend in your codebase, here is an example

```swift
extension Reactive where Base: UIView {
    var borderColor: Binder<UIColor?> {
        return Binder(self.base) { view, color in
            view.layer.borderColor = color?.cgColor
        }
    }
}
```

> NOTICE: Since RxSwift 6, most variable based rx extensions should already been derived by @dynamicMemberLookup.

if you also want to use the sugar `view.theme.borderColor`, you have to write another extension:

```swift
extension ThemeProxy where Base: UIView {
    var borderColor: Observable<UIColor?> {
        get { return .empty() }
        set {
            let disposable = newValue
                .take(until: base.rx.deallocating)
                .observe(on: MainScheduler.instance)
                .bind(to: base.rx.borderColor)
            hold(disposable, for: "borderColor")
        }
    }
}
```

If you think your extension is commonly used, please send us a PR.

## Examples

You can run the example project, clone the repo, run `pod install` from the Example directory first, and open up the workspace file.

If you prefer, there is also a nice [video tutorial](https://www.youtube.com/watch?v=aV9qEcmJ7nY) by [@rebeloper](https://github.com/rebeloper).

<img width="300" src="https://user-images.githubusercontent.com/2488011/55673846-23d58a00-58b6-11e9-9621-a799b6efb561.png" />

## Installation

> 5.x requires RxSwift 6, If you are using RxSwift 5, please use 4.x.

### SPM

1. File > Swift Packages > Add Package Dependency
2. Add https://github.com/RxSwiftCommunity/RxTheme

### Cocoapods

```ruby
pod 'RxTheme', '~> 5.0'
```

### Carthage

```
github "RxSwiftCommunity/RxTheme" ~> 5.0.0
```

## Author

duan, wddwyss@gmail.com

## License

RxTheme is available under the MIT license. See the LICENSE file for more info.
