import Curassow
import Inquiline
import Nest


let router = Router()

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

router.get("/users") { request in
    let user = User(name: "caesar", email: "cjwirth@gmail.com")
    return try Response(status: .OK, json: Json(user))
}

router.get("/secret", handler: SecretPasswordAuthMiddleware({ request in
    return Response(status: .OK, body: "Glad to see you know the password!")
}))


serve(router.handle)
