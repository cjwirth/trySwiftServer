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
let server = router.handle

router.get("/pokemon") { request in
    let pokemonJson = try pokedex.jsonString()
    return Response(status: .OK, body: pokemonJson)
}

router.post("/pokemon") { request in
    guard let json = request.body else {
        return Error.BadRequest
    }

    let pokemon: Pokemon
    do {
        if let deserialized = try Pokemon.deserialize(json).first {
            pokemon = deserialized
        } else {
            return Error.BadRequest
        }
    } catch {
        return Error.BadRequest
    }

    pokedex.append(pokemon)
    return Response(status: .OK, body: try pokemon.jsonString())
}

serve(server)
