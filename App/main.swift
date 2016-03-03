import Nest
import Curassow

let router = Router()
let app = router.handle

router.resource(ResourceController<User>)

serve(app)
