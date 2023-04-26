SystemKit
=========

A macOS system library in Swift based off of
[libtop](http://www.opensource.apple.com/source/top/top-100.1.2/libtop.c), from
Apple's top implementation.

- For an example usage of this library, see
  [dshb](https://github.com/beltex/dshb), a macOS system monitor in Swift
- For other system related statistics in Swift for macOS, see
  [SMCKit](https://github.com/beltex/SMCKit)


### Build

- [Xcode 14.2](https://developer.apple.com/xcode/downloads/)
- Swift 5
- macOS Monterey 12.6.5

### Installation


#### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 

Once you have your Swift package set up, adding Alamofire as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/awkx/SystemKit.git", .upToNextMajor(from: "0.0.6"))
]
```


#### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh) using the following command:

    $ brew update
    $ brew install carthage

To integrate SystemKit into your Xcode project using Carhage, specify it in your Cartfile:

    github "awkx/SystemKit"

Run `carthage update` to build the framework and drag the built SystemKit.framework into your Xcode project.
Don't forget to alter your Carthage [building phase for macOS](https://github.com/Carthage/Carthage#if-youre-building-for-os-x).

### Example

Build on `MacBook Pro (Retina, 15-inch, Mid 2015)` 

Sample ouput from
[example](https://github.com/awkx/SystemKit/blob/master/Example/main.swift).

```
// MACHINE STATUS

-- CPU --
    PHYSICAL CORES:  4
    LOGICAL CORES:   8
    SYSTEM:          5%
    USER:            10%
    IDLE:            84%
    NICE:            0%

-- MEMORY --
    PHYSICAL SIZE:   16.0GB
    FREE:            67MB
    WIRED:           3.15GB
    ACTIVE:          5.11GB
    INACTIVE:        5.08GB
    COMPRESSED:      2.58GB

-- SYSTEM --
    MODEL:           MacBookPro11,4
    UPTIME:          5d 3h 39m 9s
    PROCESSES:       878
    THREADS:         2845
    LOAD AVERAGE:    ["2.62", "2.71", "3.17"]
    MACH FACTOR:     [5.628, 5.411, 5.339]

-- POWER --
    CPU SPEED LIMIT: 100.0%
    CPUs AVAILABLE:  8
    SCHEDULER LIMIT: 100.0%
    THERMAL LEVEL:   Not Published

-- BATTERY --
    AC POWERED:      true
    CHARGED:         true
    CHARGING:        false
    CHARGE:          100.0%
    CAPACITY:        9637 mAh
    MAX CAPACITY:    9637 mAh
    DESGIN CAPACITY: 8880 mAh
    CYCLES:          107
    MAX CYCLES:      1000
    TEMPERATURE:     31.0°C
    TIME REMAINING:  0:00

// SMC

-- Temperature --
    CPU_0_DIE             (TC0F)  59.0°C (Danger)
    CPU_0_PROXIMITY       (TC0P)  46.0°C (Nominal)
    ENCLOSURE_BASE_0      (TB0T)  33.0°C (Nominal)
    ENCLOSURE_BASE_1      (TB1T)  29.0°C (Nominal)
    ENCLOSURE_BASE_2      (TB2T)  33.0°C (Nominal)
    HEATSINK_1            (Th1H)  43.0°C (Nominal)
    HEATSINK_2            (Th2H)  41.0°C (Nominal)
    MEM_SLOTS_PROXIMITY   (TM0P)  45.0°C (Nominal)
    MEM_SLOT_0            (TM0S)  44.0°C (Nominal)
    PALM_REST             (Ts0P)  32.0°C (Nominal)

-- Fan --
[id 0] Left side  
    Min:      2160 RPM
    Max:      6156 RPM
    Current:  2164 RPM (Nominal)
[id 1] Right side 
    Min:      2000 RPM
    Max:      5700 RPM
    Current:  1997 RPM (Nominal)

-- Power --
    AC Present:       true
    Battery Powered:  false
    Charging:         false
    Battery Ok:       true
    Battery Count:    1

-- Misc --
    Disc in ODD:      false
```


### References

- [top](http://www.opensource.apple.com/source/top/)
- [hostinfo](http://www.opensource.apple.com/source/system_cmds/)
- [vm_stat](http://www.opensource.apple.com/source/system_cmds/)
- [PowerManagement](http://www.opensource.apple.com/source/PowerManagement/)
- iStat Pro


### License

This project is under the **MIT License**.
