//
//  MeasurementTimer.swift
//  PhotoRoll
//
//  Created by Cantero Gonzalez Francisco Jose on 29/03/2017.
//  Copyright © 2017 Francisco Jose . All rights reserved.
//

import UIKit

class BenchmarkTimer: CustomStringConvertible {
    
    private(set) var startTime:CFTimeInterval
    private(set) var endTime:CFTimeInterval?
    
    init() {
        startTime = CACurrentMediaTime()
//        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
//        let timeInterval = Double(nanoTime) / 1_000_000_000
    }
    
    func nanoSecondsToSeconds(for nanoTime: UInt64) -> Double {
        return Double(nanoTime) / 1_000_000_000
    }
    
    func start() {
        startTime = CACurrentMediaTime()
        endTime = .none
    }
    
    /// Stops the timer and returns the time in seconds
    ///
    /// - Returns: Time elapsed in seconds.
    func stop() -> Double {
        endTime = CACurrentMediaTime()
        return duration!
    }
    
    /// Returns the time in seconds
    ///
    /// - Returns: Time elapsed in seconds.
    var duration: Double? {
        if let endTime = endTime {
            return endTime - startTime
        } else {
            return CACurrentMediaTime() - startTime
        }
    }
    
    var description:String {
        let time = duration!
        if (time > 100) {return " \(time/60) min"}
        else if (time < 1e-6) {return " \(time*1e9) ns"}
        else if (time < 1e-3) {return " \(time*1e6) µs"}
        else if (time < 1) {return " \(time*1000) ms"}
        else {return " \(time) s"}
    }
}
