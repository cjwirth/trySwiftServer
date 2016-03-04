import Nest
import Curassow

let router = Router()

router.get("/") { _ in
    return Response(status: .OK, body: "Hello, World!")
}






let server = router.handle
serve(server)

// Data

var pokedex: [Pokemon] = [
    // フシギダネ
    Pokemon(name: "Bulbasaur", description: "Bulbasaur can be seen napping in bright sunlight."),
    // ヒトカゲ
    Pokemon(name: "Charmander", description: "The flame that burns at the tip of its tail is an indication of its emotions."),
    // ゼニガメ
    Pokemon(name: "Squirtle", description: "Squirtle's shell is not merely used for protection.")
]

let trainers: [Trainer] = [
    Trainer(name: "Tom Oliver", memo: "日本語、上手ですね✌️")
]
