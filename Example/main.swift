//
// main.swift
// SystemKit
//
// The MIT License
//
// Copyright (C) 2014-2017  beltex <https://github.com/beltex>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import SystemKit

print("// MACHINE STATUS")

print("\n-- CPU --")
print("\tPHYSICAL CORES:  \(System.physicalCores())")
print("\tLOGICAL CORES:   \(System.logicalCores())")

var sys = System()
let cpuUsage = sys.usageCPU()
print("\tSYSTEM:          \(Int(cpuUsage.system))%")
print("\tUSER:            \(Int(cpuUsage.user))%")
print("\tIDLE:            \(Int(cpuUsage.idle))%")
print("\tNICE:            \(Int(cpuUsage.nice))%")


print("\n-- MEMORY --")
print("\tPHYSICAL SIZE:   \(System.physicalMemory())GB")

let memoryUsage = System.memoryUsage()
func memoryUnit(_ value: Double) -> String {
    if value < 1.0 { return String(Int(value * 1000.0)) + "MB" }
    else           { return String(format:"%.2f", value) + "GB" }
}

print("\tFREE:            \(memoryUnit(memoryUsage.free))")
print("\tWIRED:           \(memoryUnit(memoryUsage.wired))")
print("\tACTIVE:          \(memoryUnit(memoryUsage.active))")
print("\tINACTIVE:        \(memoryUnit(memoryUsage.inactive))")
print("\tCOMPRESSED:      \(memoryUnit(memoryUsage.compressed))")


print("\n-- SYSTEM --")
print("\tMODEL:           \(System.modelName())")

//let names = System.uname()
//print("\tSYSNAME:         \(names.sysname)")
//print("\tNODENAME:        \(names.nodename)")
//print("\tRELEASE:         \(names.release)")
//print("\tVERSION:         \(names.version)")
//print("\tMACHINE:         \(names.machine)")

let uptime = System.uptime()
print("\tUPTIME:          \(uptime.days)d \(uptime.hrs)h \(uptime.mins)m " +
                            "\(uptime.secs)s")

let counts = System.processCounts()
print("\tPROCESSES:       \(counts.processCount)")
print("\tTHREADS:         \(counts.threadCount)")

let loadAverage = System.loadAverage().map { String(format:"%.2f", $0) }
print("\tLOAD AVERAGE:    \(loadAverage)")
print("\tMACH FACTOR:     \(System.machFactor())")


print("\n-- POWER --")
let cpuThermalStatus = System.CPUPowerLimit()

print("\tCPU SPEED LIMIT: \(cpuThermalStatus.processorSpeed)%")
print("\tCPUs AVAILABLE:  \(cpuThermalStatus.processorCount)")
print("\tSCHEDULER LIMIT: \(cpuThermalStatus.schedulerTime)%")

print("\tTHERMAL LEVEL:   \(System.thermalLevel().rawValue)")

var battery = Battery()
if battery.open() != kIOReturnSuccess { exit(0) }

print("\n-- BATTERY --")
print("\tAC POWERED:      \(battery.isACPowered())")
print("\tCHARGED:         \(battery.isCharged())")
print("\tCHARGING:        \(battery.isCharging())")
print("\tCHARGE:          \(battery.charge())%")
print("\tCAPACITY:        \(battery.currentCapacity()) mAh")
print("\tMAX CAPACITY:    \(battery.maxCapactiy()) mAh")
print("\tDESGIN CAPACITY: \(battery.designCapacity()) mAh")
print("\tCYCLES:          \(battery.cycleCount())")
print("\tMAX CYCLES:      \(battery.designCycleCount())")
print("\tTEMPERATURE:     \(battery.temperature())°C")
print("\tTIME REMAINING:  \(battery.timeRemainingFormatted())")

_ = battery.close()

print("\n// SMC")

let maxTemperatureCelsius = 128.0

enum ANSIColor: String {
    case Off    = "\u{001B}[0;0m"
    case Red    = "\u{001B}[0;31m"
    case Green  = "\u{001B}[0;32m"
    case Yellow = "\u{001B}[0;33m"
    case Blue   = "\u{001B}[0;34m"
}

func warningLevel(value: Double, maxValue: Double) -> (name: String,
                                                       color: ANSIColor) {
    let percentage = value / maxValue

    switch percentage {
    // TODO: Is this safe? Rather, is this the best way to go about this?
    case -Double.infinity...0: return ("Cool", ANSIColor.Blue)
    case 0...0.45:             return ("Nominal", ANSIColor.Green)
    case 0.45...0.75:          return ("Danger", ANSIColor.Yellow)
    default:                   return ("Crisis", ANSIColor.Red)
    }
}

func printTemperatureInformation(known: Bool = true) {
    print("\n-- Temperature --")

    let sensors: [TemperatureSensor]
    do {
        if known {
            sensors = try SMCKit.allKnownTemperatureSensors().sorted
                                                           { $0.name < $1.name }
        } else {
            sensors = try SMCKit.allUnknownTemperatureSensors()
        }

    } catch {
        print(error)
        return
    }


    let sensorWithLongestName = sensors.max { $0.name.count <
                                                     $1.name.count }

    guard let longestSensorNameCount = sensorWithLongestName?.name.count else {
        print("No temperature sensors found")
        return
    }


    for sensor in sensors {
        let padding = String(repeating: " ",
                             count: longestSensorNameCount - sensor.name.count)

        let smcKey  = "(\(sensor.code.toString()))"
        print("\t\(sensor.name + padding)   \(smcKey)  ", terminator: "")


        guard let temperature = try? SMCKit.temperature(sensor.code) else {
            print("NA")
            return
        }

        let warning = warningLevel(value: temperature, maxValue: maxTemperatureCelsius)
        let level   = "(\(warning.name))"
        let color   = warning.color

        print("\(color.rawValue)\(temperature)°C \(level)" +
              "\(ANSIColor.Off.rawValue)")
    }
}

func printFanInformation() {
    print("\n-- Fan --")

    let allFans: [Fan]
    do {
        allFans = try SMCKit.allFans()
    } catch {
        print(error)
        return
    }

    if allFans.count == 0 { print("No fans found") }

    for fan in allFans {
        print("[id \(fan.id)] \(fan.name)")
        print("\tMin:      \(fan.minSpeed) RPM")
        print("\tMax:      \(fan.maxSpeed) RPM")

        guard let currentSpeed = try? SMCKit.fanCurrentSpeed(fan.id) else {
            print("\tCurrent:  NA")
            return
        }

        let warning = warningLevel(value: Double(currentSpeed),
                                   maxValue: Double(fan.maxSpeed))
        let level = "(\(warning.name))"
        let color = warning.color
        print("\tCurrent:  \(color.rawValue)\(currentSpeed) RPM \(level)" +
                                                    "\(ANSIColor.Off.rawValue)")
    }
}

func printPowerInformation() {
    let information: BatteryInfo
    do {
        information = try SMCKit.batteryInformation()
    } catch {
        print(error)
        return
    }

    print("\n-- Power --")
    print("\tAC Present:       \(information.isACPresent)")
    print("\tBattery Powered:  \(information.isBatteryPowered)")
    print("\tCharging:         \(information.isCharging)")
    print("\tBattery Ok:       \(information.isBatteryOk)")
    print("\tBattery Count:    \(information.batteryCount)")
}

func printMiscInformation() {
    print("\n-- Misc --")

    let ODDStatus: Bool
    do {
        ODDStatus = try SMCKit.isOpticalDiskDriveFull()
    } catch SMCKit.SMCError.keyNotFound { ODDStatus = false }
      catch {
        print(error)
        return
    }

    print("\tDisc in ODD:      \(ODDStatus)")
}

func printAll() {
    printTemperatureInformation()
    printFanInformation()
    printPowerInformation()
    printMiscInformation()
}

func checkKey(key: String) {
    if key.count != 4 {
        print("Must be a FourCC (four-character code)")
        return
    }

    do {
        let isValid = try SMCKit.isKeyFound(FourCharCode(fromString: key))
        let answer = isValid ? "valid" : "invalid"

        print("\(key) is a \(answer) SMC key on this machine")
    } catch { print(error) }
}

func setMinFanSpeed(fanId: Int, fanSpeed: Int) {
    do {
        let fan = try SMCKit.fan(fanId)
        let currentSpeed = try SMCKit.fanCurrentSpeed(fanId)

        try SMCKit.fanSetMinSpeed(fanId, speed: fanSpeed)

        print("Min fan speed set successfully")
        print("[id \(fan.id)] \(fan.name)")
        print("\tMin (Previous):  \(fan.minSpeed) RPM")
        print("\tMin (Target):    \(fanSpeed) RPM")
        print("\tCurrent:         \(currentSpeed) RPM")
    } catch SMCKit.SMCError.keyNotFound {
        print("This machine has no fan with id \(fanId)")
    } catch SMCKit.SMCError.notPrivileged {
        print("This operation must be invoked as the superuser")
    } catch SMCKit.SMCError.unsafeFanSpeed {
        print("Invalid fan speed. Must be <= max fan speed")
    } catch {
        print(error)
    }
}

do {
    try SMCKit.open()
    printAll()
} catch {
    print("Failed to open a connection to the SMC")
    exit(EX_UNAVAILABLE)
}
SMCKit.close()
