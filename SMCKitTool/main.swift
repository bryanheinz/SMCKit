//
// OS X SMC Tool
//
// SMCKitTool/main.swift
// SMCKit
//
// The MIT License
//
// Copyright (C) 2015  beltex <http://beltex.github.io>
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

import IOKit

// Not using the following as frameworks, but as source files. See README.md for
// more
//import CommandLine
//import SMCKit

//------------------------------------------------------------------------------
// MARK: GLOBALS
//------------------------------------------------------------------------------

let SMCKitToolVersion = "0.0.1"

//------------------------------------------------------------------------------
// MARK: COMMAND LINE INTERFACE
//------------------------------------------------------------------------------

let CLITemperatureFlag = BoolOption(shortFlag: "t", longFlag: "temperature",
                                    helpMessage: "Show temperature sensors.")
let CLIFanFlag         = BoolOption(shortFlag: "f", longFlag: "fan",
                                    helpMessage: "Show fan speeds.")
let CLIPowerFlag       = BoolOption(shortFlag: "p", longFlag: "power",
                                    helpMessage: "Show power information.")
let CLIMiscFlag        = BoolOption(shortFlag: "m", longFlag: "misc",
                                    helpMessage: "Show misc. information.")
let CLIHelpFlag        = BoolOption(shortFlag: "h", longFlag: "help",
               helpMessage: "Show the help message (list of options) and exit.")
let CLIVersionFlag     = BoolOption(shortFlag: "v", longFlag: "version",
                                   helpMessage: "Show smckit version and exit.")


let CLI = CommandLine()
CLI.addOptions(CLITemperatureFlag, CLIFanFlag, CLIPowerFlag, CLIMiscFlag,
                                                             CLIHelpFlag,
                                                             CLIVersionFlag)
let (success, error) = CLI.parse()
if !success {
    println(error!)
    CLI.printUsage()
    exit(EX_USAGE)
}

// Give precedence to help flag
if CLIHelpFlag.value {
    CLI.printUsage()
    exit(EX_USAGE)
}
else if CLIVersionFlag.value {
    println(SMCKitToolVersion)
    exit(EX_USAGE)
}

//------------------------------------------------------------------------------
// MARK: FUNCTIONS
//------------------------------------------------------------------------------

func printTemperatureInformation() {
    println("-- TEMPERATURE --")
    let temperatureSensors = smc.getAllValidTemperatureKeys()

    for key in temperatureSensors {
        let temperatureSensorName = SMC.Temperature.allValues[key]!
        let temperature           = smc.getTemperature(key).tmp

        println("\(temperatureSensorName)")
        println("\t\(temperature)°C")
    }
}

func printFanInformation() {
    println("-- FAN --")
    let fanCount = smc.getNumFans().numFans

    if fanCount == 0 { println("** Fanless **") }
    else {
        for var i: UInt = 0; i < fanCount; ++i {
            let name    = smc.getFanName(i).name
            let current = smc.getFanRPM(i).rpm
            let min     = smc.getFanMinRPM(i).rpm
            let max     = smc.getFanMaxRPM(i).rpm

            println("[\(i)] \(name)")
            println("\tCurrent:  \(current) RPM")
            println("\tMin:      \(min) RPM")
            println("\tMax:      \(max) RPM")
        }
    }
}

func printPowerInformation() {
    println("-- POWER --")
    println("AC Present:          \(smc.isACPresent().flag)")
    println("Battery Powered:     \(smc.isBatteryPowered().flag)")
    println("Charging:            \(smc.isCharging().flag)")
    println("Battery Ok:          \(smc.isBatteryOk().flag)")
    println("Max Batteries:       \(smc.maxNumberBatteries().count)")
}

func printMiscInformation() {
    println("-- MISC --")
    println("Disc in ODD:         \(smc.isOpticalDiskDriveFull().flag)")
}

func printAll() {
    printTemperatureInformation()
    printFanInformation()
    printPowerInformation()
    printMiscInformation()
}

//------------------------------------------------------------------------------
// MARK: MAIN
//------------------------------------------------------------------------------

var smc = SMC()
if smc.open() != kIOReturnSuccess {
    println("ERROR: Failed to open connection to SMC")
    exit(EX_UNAVAILABLE)
}

if Process.arguments.count == 1 { printAll() }

if CLITemperatureFlag.value { printTemperatureInformation() }
if CLIFanFlag.value         { printFanInformation()         }
if CLIPowerFlag.value       { printPowerInformation()       }
if CLIMiscFlag.value        { printMiscInformation()        }

smc.close()
