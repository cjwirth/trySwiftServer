
class User: Jsonable {
    let name: String
    let email: String

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
}