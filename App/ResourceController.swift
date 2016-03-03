import Nest

protocol Model: Jsonable {
    static var modelName: String { get }
}

protocol Controller {
    init()

    func index(request: RequestType) throws -> ResponseType
    func create(request: RequestType) throws -> ResponseType

    // Will need proper parameter parsing before implementing
//    func show(request: RequestType) throws -> ResponseType
//    func delete(request: RequestType) throws -> ResponseType
}

class ResourceController<T: Model>: Controller {

    private var models: [T] = []

    required init() { }

    func index(request: RequestType) throws -> ResponseType {
        let json = try models.jsonString()
        return Response(status: .OK, body: json)
    }

    func create(request: RequestType) throws -> ResponseType {
        guard let json = request.body else {
            return Error.BadRequest
        }

        let newModels: [T]
        do {
            newModels = try T.deserialize(json)
            models.appendContentsOf(newModels)
        } catch {
            return Response(status: .BadRequest)
        }

        return Response(status: .OK, body: try models.jsonString())
    }

}