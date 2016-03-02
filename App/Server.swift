import Nest


typealias Handler = (RequestType throws -> ResponseType)

enum Method: String {
    case Get = "GET"
    case Post = "POST"
    case Put = "PUT"
    case Delete = "DELETE"
}

enum Status: Int {
    case OK = 200
    case Unauthorized = 401
    case NotFound = 404
    case ServerError = 500
    case NotImplemented = 501

    var reasonPhrase: String {
        switch self {
        case OK: return "OK"
        case .Unauthorized: return "Unauthorized"
        case .NotFound: return "Not Found"
        case .ServerError: return "Internal Server Error"
        case .NotImplemented: return "Not Implemented"
        }
    }
}


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

func makeStatusLine(status: Status) -> String {
    return "HTTP/1.1 \(status.rawValue), \(status.reasonPhrase)"
}

enum Error: ResponseType, ErrorType {
    case Unauthorized
    case InternalServerError
    case NotImplemented

    var status: Status {
        switch self {
        case .Unauthorized: return .Unauthorized
        case .InternalServerError: return .ServerError
        case .NotImplemented: return .NotImplemented
        }
    }

    var statusLine: String { return makeStatusLine(status) }

    var headers: [Header] { return [] }

    var body: String? { return nil }
}



class Response: ResponseType {
    var status: Status
    var headers: [Header] = []
    var body: String?

    var statusLine: String { return makeStatusLine(status) }

    init(status: Status) {
        self.status = status
    }

    init(status: Status, body: String) {
        self.status = status
        self.body = body
    }

    init(status: Status, json: Json) throws {
        self.status = status
        self.body = try json.serialize()
    }
}

extension RequestType {

    func getHeader(key: String) -> String? {
        return headers.filter { $0.0 == key }.first?.1
    }

}

typealias Middlware = (Handler -> Handler)

func SecretPasswordAuthMiddleware(handler: Handler) -> Handler {
    return { request in
        let passwordKey = "X-Secret-Password-Sshh"
        let correctPassword = "CorrectHorseBatteryStaple"

        if let password = request.getHeader(passwordKey)
            where password == correctPassword {

                return try handler(request)
        } else {
            return Error.Unauthorized
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





