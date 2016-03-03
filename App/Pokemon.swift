import Jay

struct Pokemon: Model {
    static let modelName = "pokemon"

    var englishName: String
    var japaneseName: String

    init(englishName: String, japaneseName: String) {
        self.englishName = englishName
        self.japaneseName = japaneseName
    }

    func serialized() -> [String: Any] {
        return [
            "englishName": englishName,
            "japaneseName": japaneseName
        ]
    }

    static func deserialized(json: JsonObject) throws -> Pokemon {
        guard
            let enJson = json["englishName"],
            let jpJson = json["japaneseName"],
            case let .String(englishName) = enJson,
            case let .String(japaneseName) = jpJson else {
                throw JsonError.CouldNotDeserialize
        }

        return self.init(englishName: englishName, japaneseName: japaneseName)
    }
}