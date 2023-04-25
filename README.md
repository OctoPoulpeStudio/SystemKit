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

#### SPM

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
	SYSTEM:          4%
	USER:            9%
	IDLE:            85%
	NICE:            0%

-- MEMORY --
	PHYSICAL SIZE:   16.0GB
	FREE:            552MB
	WIRED:           2.97GB
	ACTIVE:          5.13GB
	INACTIVE:        5.01GB
	COMPRESSED:      2.33GB

-- SYSTEM --
	MODEL:           MacBookPro11,4
	UPTIME:          4d 0h 40m 14s
	PROCESSES:       890
	THREADS:         3523
	LOAD AVERAGE:    [2.78, 2.70, 2.62]
	MACH FACTOR:     [4.387, 4.859, 4.876]

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
Program ended with exit code: 0
```


### References

- [top](http://www.opensource.apple.com/source/top/)
- [hostinfo](http://www.opensource.apple.com/source/system_cmds/)
- [vm_stat](http://www.opensource.apple.com/source/system_cmds/)
- [PowerManagement](http://www.opensource.apple.com/source/PowerManagement/)
- iStat Pro


### License

This project is under the **MIT License**.
