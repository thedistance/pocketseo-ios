//
//  MZMetric.swift
//  MozQuito
//
//  Created by Josh Campion on 25/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

enum MZMetricValueType {
    case ValueAbsolute(Int)
    case ValueOutOf(Int, Int)
    case StringMetric(String)
    case DateMetric(NSDate)
}

struct MZMetric {
    
    let title:String
    let helpInfo:String
    let value:MZMetricValueType
    
}