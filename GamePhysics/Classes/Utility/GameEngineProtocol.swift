
public protocol GameEngineProtocol {
    var renderer: Renderer { get set }
    var physicsEngine: PhysicsEngine { get set }

    func notifyRendererToUpdate(_ gameObject: GameObject)

    func handleCollision(_ lhs: GameObject, _ rhs: GameObject, type: Set<GameObjectCollisionType>)

}
