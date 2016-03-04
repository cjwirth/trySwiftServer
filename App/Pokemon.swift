import Jay

struct Pokemon: Jsonable {
    let name: String
    let description: String

    init(name: String, description: String) {
        self.name = name
        self.description = description
    }

    func serialized() -> [String: Any] {
        return [
            "name": name,
            "description": description
        ]
    }

    static func deserialized(json: JsonObject) throws -> Pokemon {
        guard
            let nameJson = json["name"],
            let descJson = json["description"],
            case let .String(name) = nameJson,
            case let .String(desc) = descJson else {
                throw JsonError.CouldNotDeserialize
        }

        return self.init(name: name, description: desc)
    }
}

struct Trainer {
    var name: String
    var memo: String
}




