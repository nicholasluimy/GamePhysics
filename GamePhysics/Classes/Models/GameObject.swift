//
//  GameObject.swift
//  LevelDesigner
//
//  Created by Nicholas Lui Ming Yang on 2/19/18.
//  Copyright © 2018 nus.cs3217.a0101010. All rights reserved.
//

import Foundation
import UIKit

public enum GameObjectCollisionType {
    case radial
    case xPlane
    case yPlane
}

public class GameObject: Hashable {
    public var hashValue: Int {
        return uuid.hashValue
    }

    public static func ==(lhs: GameObject, rhs: GameObject) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    public var origin: CGPoint
    public var velocity: CGVector
    public var size: CGSize
    public var uuid: UUID
    public var view: UIView?
    public var collisionType: GameObjectCollisionType

    public init(origin: CGPoint, velocity: CGVector, size: CGSize, collisionType: GameObjectCollisionType) {
        self.origin = origin
        self.velocity = velocity
        self.size = size
        self.uuid = UUID()
        self.collisionType = collisionType
    }

    /// Returns radial center
    /// - Assumes object type is .radial
    public func getRadialCenter() -> CGPoint {
        let radius = getRadius()
        var center = origin
        center.x += radius
        center.y += radius
        return center
    }

    /// Returns radius
    /// - Assumes object type is .radial
    public func getRadius() -> CGFloat {
        return size.width / 2
    }

    /// Returns diameter
    /// - Assumes object type is .radial
    public func getDiameter() -> CGFloat {
        return size.width
    }
}
