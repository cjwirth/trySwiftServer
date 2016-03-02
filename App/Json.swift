// import Foundation

protocol Jsonable {
    func serialized() -> [String: Any]
}

class Json {

    private let obj: Jsonable

    init(_ obj: Jsonable) {
        self.obj = obj
    }

    func serialize() throws -> String {
        return "{\"name\":\"caesar\", \"email\": \"cjwirth@gmail.com\"}"
        // let serialized = obj.serialized()
        // let data = try NSJSONSerialization.dataWithJSONObject(serialized, options: .PrettyPrinted)

        // if let json = String(data: data, encoding: NSUTF8StringEncoding) {
        //     return json
        // } else {
        //     throw NSError(domain: "com.server.json", code: 1, userInfo: ["message": "json data was not a string"])
        // }
    }
}