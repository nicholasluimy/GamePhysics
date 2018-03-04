//
//  PhysicsEngine.swift
//  LevelDesigner
//
//  Created by Nicholas Lui Ming Yang on 2/22/18.
//  Copyright © 2018 nus.cs3217.a0101010. All rights reserved.
//

import Foundation
import UIKit

public enum ForceTypes {
    case none
    case magneticPull
    case magneticPush
}

public class PhysicsEngine {
    public var gameObjects: [GameObject]
    public var renderDelegate: GameEngineProtocol?
    public var collisionDelegate: GameEngineProtocol?
    public var forceObjectMap: [GameObject: ForceTypes]

    public init() {
        self.gameObjects = [GameObject]()
        self.forceObjectMap = [GameObject: ForceTypes]()
        createDisplayLink()
    }

    // MARK: - 60hz actions
    public func createDisplayLink() {
        let displaylink = CADisplayLink(target: self,
                                        selector: #selector(step))

        displaylink.add(to: .current,
                        forMode: .defaultRunLoopMode)
    }

    @objc func step(displaylink: CADisplayLink) {
        updateGameState()
    }

    // MARK: - public APIs

    /// MUST BE CALLED FIRST THING AFTER INIT
    /// utility as refer to itself until completely instantiated
    public func setDelegates(renderDelegate: GameEngineProtocol, collisionDelegate: GameEngineProtocol) {
        self.renderDelegate = renderDelegate
        self.collisionDelegate = collisionDelegate
    }

    public func materialize(_ gameObject: GameObject, forceType: ForceTypes) -> Bool {
        gameObjects.append(gameObject)
        if forceType != .none {
            forceObjectMap[gameObject] = forceType
        }
        return true
    }

    public func dematerialize(_ gameObject: GameObject) -> Bool {
        guard let objectIndex = gameObjects.index(of: gameObject) else {
            return  false
        }
        gameObjects.remove(at: objectIndex)
        forceObjectMap[gameObject] = nil
        return true
    }

    // MARK: - private methods

    private func updateGameState() {
        // update state of all game objects
        _ = gameObjects.map({ update(gameObject: $0) })
    }

    private func update(gameObject: GameObject) {
        guard gameObject.velocity != .zero else {
            return
        }

        gameObject.origin.x += gameObject.velocity.dx
        gameObject.origin.y += gameObject.velocity.dy

        checkCollision(gameObject)
        updateVelocity(gameObject)
        renderDelegate?.notifyRendererToUpdate(gameObject)
    }

    private func updateVelocity(_ gameObject: GameObject) {
        for (forceObj, forceType) in forceObjectMap {
            switch forceType {
            case .magneticPull:
                let forceOrigin = forceObj.origin
                // force "pulls" inwards, so angle from gameObject to force
                let forceAngle = gameObject.origin.angleTo(forceOrigin)
                let forceDistance = gameObject.origin.distanceTo(forceOrigin)
                let magneticVector = CGVector.getMagneticVector(of: forceAngle, distance: forceDistance)

                gameObject.velocity.additionWith(otherVector: magneticVector)

            case .magneticPush:
                let forceOrigin = forceObj.origin
                // force "pushes" outwards, so angle from force to gameObject
                let forceAngle = forceOrigin.angleTo(gameObject.origin)
                let forceDistance = gameObject.origin.distanceTo(forceOrigin)
                let magneticVector = CGVector.getMagneticVector(of: forceAngle, distance: forceDistance)

                gameObject.velocity.additionWith(otherVector: magneticVector)

            default:
                return
            }
        }
    }

    private func checkCollision(_ gameObject: GameObject) {
        for collidingObject in gameObjects {
            let collisionType = Set([gameObject.collisionType, collidingObject.collisionType])
            guard isColliding(gameObject, collidingObject, type: collisionType) else {
                continue
            }
            collisionDelegate?.handleCollision(gameObject, collidingObject, type: collisionType)
            return
        }

    }

    private func isColliding(_ lhs: GameObject, _ rhs: GameObject, type: Set<GameObjectCollisionType>) -> Bool {
        guard lhs !== rhs else {
            return false
        }

        let distance: CGFloat
        let collisionCriteria: CGFloat

        switch type {
        case Set([.radial, .radial]):
            let lhsCenter = lhs.getRadialCenter()
            let rhsCenter = rhs.getRadialCenter()
            distance = getPointDisplacement(lhsCenter, rhsCenter)

            collisionCriteria = max(lhs.getDiameter(), rhs.getRadius())

        case Set([.radial, .xPlane]):
            let pointCenter: CGPoint
            let planeValue: CGFloat
            let roundObject = lhs.collisionType == .radial ? lhs : rhs
            let wallObject = lhs.collisionType == .radial ? rhs : lhs
            pointCenter = roundObject.getRadialCenter()
            planeValue = wallObject.origin.y
            collisionCriteria = max(roundObject.getRadius(), wallObject.size.height)

            distance = getRadialXPlaneDisplacement(point: pointCenter, plane: planeValue)

        case Set([.radial, .yPlane]):
            let pointCenter: CGPoint
            let planeValue: CGFloat

            let roundObject = lhs.collisionType == .radial ? lhs : rhs
            let wallObject = lhs.collisionType == .radial ? rhs : lhs

            pointCenter = roundObject.getRadialCenter()
            planeValue = wallObject.origin.x
            collisionCriteria = max(roundObject.getRadius(), wallObject.size.width)

            distance = getRadialYPlaneDisplacement(point: pointCenter, plane: planeValue)

        default:
            return false
        }

        return distance <= collisionCriteria
    }

    // MARK: - Utility methods
    private func getPointDisplacement(_ lhs: CGPoint, _ rhs: CGPoint) -> CGFloat {
        let displacementX = lhs.x - rhs.x
        let displacementY = lhs.y - rhs.y
        return sqrt((displacementX * displacementX) + (displacementY * displacementY))
    }

    private func getRadialXPlaneDisplacement(point lhs: CGPoint, plane rhs: CGFloat) -> CGFloat {
        return abs(lhs.y - rhs)
    }
    private func getRadialYPlaneDisplacement(point lhs: CGPoint, plane rhs: CGFloat) -> CGFloat {
        return abs(lhs.x - rhs)
    }

}
