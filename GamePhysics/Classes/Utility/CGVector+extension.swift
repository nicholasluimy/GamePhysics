//
//  CGVector+extension.swift
//  BuzzlePobble
//
//  Created by Nicholas Lui Ming Yang on 2/26/18.
//  Copyright © 2018 nus.cs3217.a0101010. All rights reserved.
//

import Foundation
import UIKit

public extension CGVector {

    /// Reflects across the y axis
    public mutating func reflectY() {
        self.dx *= -1
    }

    /// Reflects across the x axis
    public mutating func reflectX() {
        self.dy *= -1
    }

    /// Reverses vector
    public mutating func reverse() {
        reflectX()
        reflectY()
    }

    /// Gets vector magnitude
    public func magnitude() -> CGFloat {
        return sqrt(abs(dx * dx) + abs(dy * dy))
    }

    /// Gets velocity vector from angle (0 is pointing along +x axis)
    public static func getVelocityVector(of theta: CGFloat) -> CGVector {
        let velocityX = cos(theta) * 20
        let velocityY = sin(theta) * 20

        return CGVector(dx: velocityX, dy: velocityY)
    }

    public static func getMagneticVector(of theta: CGFloat, distance: CGFloat) -> CGVector {
        let strength = 30000 / (distance * distance)
        let magneticX = cos(theta) * strength
        let magneticY = sin(theta) * strength

        return CGVector(dx: magneticX, dy: magneticY)
    }

    /// Gets angle from CGVector (0 is pointing along +x axis)
    public func getAngle() -> CGFloat {
        return atan(dy / dx)
    }

    /// Sets a vector to a specified magnitude
    public mutating func setMagnitude(to magnitude: CGFloat) {
        let angle = getAngle()
        dx = magnitude * cos(angle)
        dy = magnitude * sin(angle)
    }

    // adds otherVector to self
    public mutating func additionWith(otherVector: CGVector) {
        self.dx += otherVector.dx
        self.dy += otherVector.dy
    }
}
