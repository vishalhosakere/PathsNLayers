//
//  processModel.swift
//  PathsNLayers
//
//  Created by Vishal Hosakere on 19/03/19.
//  Copyright © 2019 Vishal Hosakere. All rights reserved.
//

import Foundation
//import UIKit

enum sides:Int, Codable {
    //Changed the left from 4 to 0. while building new working arrow points
    case left = 0
    case top = 1
    case right = 2
    case bottom = 3
}

class entireData: Codable {
    var allViews = [uiViewData]()
}

struct uiViewData: Codable {
    var x: Double
    var y: Double
    var width: Double
    var height: Double
    var shape: String
    var leftLine: lineData
    var rightLine: lineData
    var topLine: lineData
    var bottomLine: lineData
    var text: String
    var id: Int
}

struct lineData: Codable{
//    var side: sides.RawValue
    var id: Int
    var isSrc: Bool
}
