import Nest

typealias Handler = (RequestType throws -> ResponseType)

class Router {
    var routes: [String: [Method: Handler]] = [:]

    func route(method: Method, path: String, handler: Handler) {
        routes[path] = [method: handler]
    }

    func handle(request: RequestType) -> ResponseType {
        guard let method = Method(rawValue: request.method),
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
