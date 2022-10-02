# KitUI

KitUI is a set of extensions to UIKit to enable more functional and declarative style for building UIs. It enables developers to quickly and logically build layouts, but still allows you to reach down into UIKit to do the hard stuff.

# Stack Views
KitUI enables Stack Views to be used to easily layout content. It uses simple functions called `Horizontal` and `Vertical` for initializing stack views

``` swift
Vertical {
    UILabel("Heading")

    UILabel("Body")
}

Horizontal {
    UIImageView(UIImage(named: "Avatar"))

    UILabel("Name")
}
```

# Buttons


# Modifiers
KitUI includes an array of chainable modifiers for building and customizing layouts inline. Currrently there are two types of modifiers, which dependending how you use the library could affect your usage

1. **Wrapping modifiers** - These wrap the current view in another containing view. So any subsequent code needs to understand these return a new separate view rather than the view they were called on

```swift
UILabel("Jon Snow")
    .padding(16) /// This is a wrapping modifier. It returns a new view wrapping the label
```

2. **Mutating modifiers** - These change the state or a property on the view they're called on, and return the same view. Calling the same mutating modifier with multiple reactive values could lead to unexpected behavior.

```swift
UILabel("text")
    .color(UIColor.blue) /// This is a mutating modifier, it just sets a value on the label
```


# Reactivity
Many of `KitUI`s modifiers use `ReactiveSwift` to enable dynamic streams of values to be passed into them

# Animation