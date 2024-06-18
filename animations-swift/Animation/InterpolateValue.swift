//
//  InterpolateValue.swift
//  animations-swift
//
//  Created by João Damazio on 16/06/24.
//

import CoreGraphics

func interpolateValue(_ isFullScreen: CGFloat, minValue: CGFloat, maxValue: CGFloat) -> CGFloat {
    let interpolatedValue = minValue + (isFullScreen * (maxValue - minValue))
    return max(min(interpolatedValue, maxValue), minValue)
}
