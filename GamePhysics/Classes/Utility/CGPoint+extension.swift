//
//  CGPoint+extension.swift
//  BuzzlePobble
//
//  Created by Nicholas Lui Ming Yang on 2/26/18.
//  Copyright © 2018 nus.cs3217.a0101010. All rights reserved.
//

import Foundation
import UIKit

extension CGPoint {
    /// Gets distance to another point
    /// - Parameters:
    ///     - nextPoint: another CGPoint
    /// - Returns: CGFloat distance
    public func distanceTo(_ nextPoint: CGPoint) -> CGFloat {
        let xDistance = abs(self.x - nextPoint.x)
        let yDistance = abs(self.y - nextPoint.y)

        return sqrt((xDistance * xDistance) + (yDistance * yDistance))
    }

    /// Gets angle to another point
    /// - Parameters:
    ///     - nextPoint: another CGPoint
    /// - Returns: CGFloat angle
    public func angleTo(_ nextPoint: CGPoint) -> CGFloat {
        return atan2(nextPoint.y - self.y, nextPoint.x - self.x)
    }
}

extension CGPoint: Hashable {
    public var hashValue: Int {
        // iOS Swift Game Development Cookbook
        // https://books.google.com.sg/books?id=QQY_CQAAQBAJ&pg=PA304&dq=swift+CGpoint+hashvalue&hl=en&sa=X&ved=0ahUKEwjonZi83MvZAhXGipQKHY_QCe4Q6AEIKDAA#v=onepage&q=swift%20CGpoint%20hashvalue&f=false
        return x.hashValue << 32 ^ y.hashValue
    }

}
