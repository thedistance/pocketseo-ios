//
//  MZAlexaData.swift
//  MozQuito
//
//  Created by Josh Campion on 28/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

public struct MZAlexaData {
    
    public let popularityText:String?
    public let reachRank:String?
    public let rankDelta:String?
    
    public init(popularityText:String?, reachRank:String?, rankDelta:String?) {
        self.popularityText = popularityText
        self.reachRank = reachRank
        self.rankDelta = rankDelta
    }
}