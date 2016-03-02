// import Foundation
import Jay

protocol Jsonable {
    func serialized() -> [String: Any]
}


private let J = Jay()

class Json {
    private let obj: Jsonable

    init(_ obj: Jsonable) {
        self.obj = obj
    }

    func serialize() throws -> String {
        let serialized = obj.serialized()
        return try J.dataFromJson(serialized).string()
    }
}