import Curassow
import Inquiline
import Nest

var users: [User] = [
    User(name: "Caesar", email: "cjwirth@gmail.com"),
    User(name: "Carlos", email: "carlos@deathstar.com")
]

let router = Router()
router.get("/users") { request in
    let usersJson = try users.jsonString()
    return Response(status: .OK, body: usersJson)
}

router.post("/users") { request in
    guard let json = request.body,
        let user = try User.deserialize(json).first else {
        return Error.BadRequest
    }

    users.append(user)
    return Response(status: .OK, body: json)
}

router.get("/secret", handler: SecretPasswordAuthMiddleware({ request in
    return Response(status: .OK, body: "Glad to see you know the password!")
}))


serve(router.handle)
