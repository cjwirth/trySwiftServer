// import Foundation
import Jay

let J = Jay()

enum JsonError: ErrorType {
    case InvalidJson
    case CouldNotDeserialize
}

protocol Jsonable {
    func jsonString() throws -> String
    func serialized() -> [String: Any]
    static func deserialized(json: JsonObject) throws -> Self
}

extension Jsonable {

    func jsonString() throws -> String {
        let serialized = self.serialized()
        return try J.dataFromJson(serialized).string()
    }

    static func deserialize(json: String) throws -> [Self] {
        let data: [UInt8] = Array(json.utf8)

        let anyJson: JsonValue
        do {
            anyJson = try J.typesafeJsonFromData(data)
        } catch {
            throw JsonError.InvalidJson
        }

        // We only support a very limited set of Json
        // Either plain objcts, or one level of nesting
        switch anyJson {
        case .Object(let map):
            return [try self.deserialized(map)]
        case .Array(let maps):
            return try maps.map { object in

                if case let .Object(map) = object {
                    return try self.deserialized(map)
                } else {
                    throw JsonError.InvalidJson
                }

            }

        default:
            throw JsonError.InvalidJson
        }
    }

}

// Don't use this. Get real JSON handling...
extension Array where Element: Jsonable {

    func serialize() throws -> String {
        let strings = try map { try $0.jsonString() }
        let combined = strings.reduce("") { sofar, new in
            if sofar.isEmpty {
                return new
            } else {
                return sofar + "," + new
            }
        }
        return "[\(combined)]"
    }
    
}
