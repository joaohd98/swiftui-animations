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

func mapRange(inMin: Double, inMax: Double, outMin: Double, outMax: Double, valueToMap: Double) -> Double {
    if inMin == inMax {
        return outMax
    }

    let clampedValue = min(max(valueToMap, inMin), inMax)
    let mappedValue = fma((clampedValue - inMin) / (inMax - inMin), (outMax - outMin), outMin)

    return mappedValue
}
