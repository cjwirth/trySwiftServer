import Nest
import Curassow

var pokedex: [Pokemon] = [
    Pokemon(name: "Bulbasaur", description: "Bulbasaur can be seen napping in bright sunlight."),
    Pokemon(name: "Charmander", description: "The flame that burns at the tip of its tail is an indication of its emotions."),
    Pokemon(name: "Squirtle", description: "Squirtle's shell is not merely used for protection.")
]

var trainers: [Trainer] = [
    Trainer(name: "Tom Oliver", memo: "日本語、お上手ですね")
]

let router = Router()
router.get("/pokemon") { request in
    let usersJson = try pokedex.jsonString()
    return Response(status: .OK, body: usersJson)
}

router.post("/pokemon") { request in
    guard let json = request.body,
        let user = try Pokemon.deserialize(json).first else {
        return Error.BadRequest
    }

    pokedex.append(user)
    return Response(status: .OK, body: try user.jsonString())
}

serve(router.handle)
