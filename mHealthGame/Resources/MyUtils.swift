//
//  MyUtils.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 26/1/2564 BE.
//

import Foundation
import CoreGraphics

func + (left: CGPoint, right: CGPoint) -> CGPoint{
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func += ( left: inout CGPoint, right: CGPoint){
    return left = left + right
}

func - (left: CGPoint, right: CGPoint) -> CGPoint{
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func -= ( left: inout CGPoint, right: CGPoint){
    return left = left - right
}


