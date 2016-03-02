import Nest


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

    var statusLine: String {
        return "HTTP/1.1 \(rawValue), \(reasonPhrase)"
    }
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

    var statusLine: String { return status.statusLine }
    var headers: [Header] { return [] }
    var body: String? { return nil }
}



struct Response: ResponseType {
    var status: Status
    var headers: [Header] = []
    var body: String?

    var statusLine: String { return status.statusLine }

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
