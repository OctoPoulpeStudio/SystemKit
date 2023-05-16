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
print("\tPHYSICAL CORES: \(System.physicalCores())")
print("\tLOGICAL CORES: \(System.logicalCores())")

var sys = System()
let cpuUsage = sys.usageCPU()
print("\tSYSTEM: \(Int(cpuUsage.system))%")
print("\tUSER: \(Int(cpuUsage.user))%")
print("\tIDLE: \(Int(cpuUsage.idle))%")
print("\tNICE: \(Int(cpuUsage.nice))%")


print("\n-- MEMORY --")
print("\tPHYSICAL SIZE: \(System.physicalMemory())GB")

print("\n-- SYSTEM --")
print("\tMODEL: \(System.modelName())")

//let names = System.uname()
//print("\tSYSNAME:         \(names.sysname)")
//print("\tNODENAME:        \(names.nodename)")
//print("\tRELEASE:         \(names.release)")
//print("\tVERSION:         \(names.version)")
//print("\tMACHINE:         \(names.machine)")

let uptime = System.uptime()
print("\tUPTIME: \(uptime.days)d \(uptime.hrs)h \(uptime.mins)m " + "\(uptime.secs)s")

let loadAverage = System.loadAverage().map { String(format:"%.2f", $0) }
print("\tLOAD AVERAGE: \(loadAverage)")
print("\tMACH FACTOR: \(System.machFactor())")


print("\n// SMC")

let maxTemperatureCelsius = 128.0

enum ANSIColor: String {
    case Off = "\u{001B}[0;0m"
    case Red = "\u{001B}[0;31m"
    case Green = "\u{001B}[0;32m"
    case Yellow = "\u{001B}[0;33m"
    case Blue = "\u{001B}[0;34m"
}

func warningLevel(value: Double, maxValue: Double) -> (name: String, color: ANSIColor) {
    let percentage = value / maxValue

    switch percentage {
    // TODO: Is this safe? Rather, is this the best way to go about this?
    case -Double.infinity...0: return ("Cool", ANSIColor.Blue)
    case 0...0.45:             return ("Nominal", ANSIColor.Green)
    case 0.45...0.75:          return ("Danger", ANSIColor.Yellow)
    default:                   return ("Crisis", ANSIColor.Red)
    }
}
