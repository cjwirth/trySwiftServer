import Nest

typealias Handler = (RequestType throws -> ResponseType)

class Router {
    private var routes: [String: [Method: Handler]] = [:]

    func route(method: Method, path: String, handler: Handler) {
        if let existing = routes[path] {
            var editing = existing
            editing[method] = handler
            routes[path] = editing
        } else {
            routes[path] = [method: handler]
        }
    }

    func handle(request: RequestType) -> ResponseType {
        // TODO: Get URL Parameter Parsing
        // eg. /users/:id --> will have a String parameter called "id"
        guard let method = request.HTTPMethod,
            let route = routes[request.path]?[method] else {
                return Error.NotImplemented
        }

        do {
            return try route(request)
        } catch {
            return Error.InternalServerError
        }
    }
}


extension Router {
    func get(path: String, handler: Handler) {
        self.route(.Get, path: path, handler: handler)
    }

    func post(path: String, handler: Handler) {
        self.route(.Post, path: path, handler: handler)
    }

    func delete(path: String, handler: Handler) {
        self.route(.Delete, path: path, handler: handler)
    }
}


extension Router {

    func resource<T: Model>(controllerType: ResourceController<T>.Type) {
        let controller = controllerType.init()
        get("/\(T.modelName)", handler: controller.index)
        post("/\(T.modelName)", handler: controller.create)
    }

}
