import Jay

struct User: Model {
    static let modelName = "users"

    var name: String
    var email: String

    init(name: String, email: String) {
        self.name = name
        self.email = email
    }

    func serialized() -> [String: Any] {
        return [
            "name": name,
            "email": email
        ]
    }

    static func deserialized(json: JsonObject) throws -> User {
        guard
            let nameJson = json["name"],
            let emailJson = json["email"],
            case let .String(name) = nameJson,
            case let .String(email) = emailJson else {
                throw JsonError.CouldNotDeserialize
        }

        return self.init(name: name, email: email)
    }
}