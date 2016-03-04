import Nest
import Curassow

var pokedex: [Pokemon] = [
                             // フシギダネ
    Pokemon(name: "Bulbasaur", description: "Bulbasaur can be seen napping in bright sunlight."),
    // ヒトカゲ
    Pokemon(name: "Charmander", description: "The flame that burns at the tip of its tail is an indication of its emotions."),
    // ゼニガメ
    Pokemon(name: "Squirtle", description: "Squirtle's shell is not merely used for protection.")
]

let router = Router()

router.get("/") { _ in
    return Response(status: .OK, body: "Hello, World!")
}

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
        if let deserialize = try Pokemon.deserialize(json).first {
            pokemon = deserialize
        } else {
            return Error.BadRequest
        }
    } catch {
        return Error.BadRequest
    }

    pokedex.append(pokemon)
    return Response(status: .OK)
}



let server = router.handle
serve(server)
