//
//  GameBubble.swift
//  LevelDesigner
//
//  Created by Nicholas Lui Ming Yang on 2/20/18.
//  Copyright © 2018 nus.cs3217.a0101010. All rights reserved.
//

import UIKit

public class GameBubble: GameObject {
    public var type: BubbleType

    public init(type: BubbleType, origin: CGPoint, velocity: CGVector, size: CGSize) {
        self.type = type
        super.init(origin: origin, velocity: velocity, size: size, collisionType: .radial)
    }

    public convenience init(type: BubbleType, origin: CGPoint, size: CGSize) {
        self.init(type: type, origin: origin, velocity: .zero, size: size)
    }

    public func setType(_ newType: BubbleType) {
        type = newType
    }

}

extension GameBubble: Comparable {
    static func <(lhs: GameBubble, rhs: GameBubble) -> Bool {
        if lhs.origin.x != rhs.origin.x {
            return lhs.origin.x < rhs.origin.x
        } else {
            return lhs.origin.y < rhs.origin.y
        }
    }
}
