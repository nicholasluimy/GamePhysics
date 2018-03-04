//
//  Renderer.swift
//  LevelDesigner
//
//  Created by Nicholas Lui Ming Yang on 2/22/18.
//  Copyright © 2018 nus.cs3217.a0101010. All rights reserved.
//

import Foundation
import UIKit

public enum UnrenderType {
    case pop
    case drop
    case bomb
    case star
    case lightning
    case remove
}

public class Renderer {
    public var displayArea: UIView

    public init(displayArea: UIView) {
        self.displayArea = displayArea
    }

    /// Renders game object on the displayArea
    public func render(_ gameObject: GameObject) {
        guard let objectView = gameObject.view else {
            return
        }
        displayArea.addSubview(objectView)
    }

    /// Unrenders game object from the displayArea
    public func unrender(_ gameObject: GameObject, animation: (UIImageView) -> Void) {
        guard let objectView = gameObject.view else {
            return
        }

        animation(objectView)

        objectView.removeFromSuperview()
    }

    /// Updates game object in the displayArea
    /// - Assumes game object is already on displayArea
    public func update(_ gameObject: GameObject) {
        gameObject.view?.frame.origin = gameObject.origin
    }

}
