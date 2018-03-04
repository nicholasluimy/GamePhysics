public enum BubbleType: String, Codable {
    public var image: UIImage? {
        return UIImage(named: self.rawValue)
    }

    case empty = "bubble-blank"
    case basicBlue = "bubble-blue"
    case basicRed = "bubble-red"
    case basicOrange = "bubble-orange"
    case basicGreen = "bubble-green"
    case specialIndestructible = "bubble-indestructible"
    case specialStar = "bubble-star"
    case specialBomb = "bubble-bomb"
    case specialLightning = "bubble-lightning"
    case specialMagnetic = "bubble-magnetic"
    case specialIndestructible = "bubble-indestructible"

    public var nextBubbleType: BubbleType {
        if self == .empty {
            return self
        }

        let allValidTypes: [BubbleType] = [.basicBlue, .basicRed, .basicOrange, .basicGreen]

        guard let index = allValidTypes.index(of: self) else {
            return .empty
        }

        return allValidTypes[(index + 1) % allValidTypes.count]
    }

    public static var randomProjectileBubbleType: BubbleType {
        let projectileBubbleTypes: [BubbleType] = [.basicBlue, .basicRed, .basicOrange, .basicGreen]
        return projectileBubbleTypes[Int(arc4random()) % projectileBubbleTypes.count]
    }
}
