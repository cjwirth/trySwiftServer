<!-- # [fit] Soaring Swiftly
## Server Side Swift

![inline 10%](trypokemon.png) #trySwiftConf 2016

--- -->
![](title.png)

---
# Caesar Wirth

- iOS Developer for 5 Years
- Works at CyberAgent, Inc.
  - Most recent app released 3 days ago
- Organizes Conferences
  - Example: try! Swift
  - Maybe you've heard of it?


![inline 30%](twitter.png) [@cjwirth](https://twitter.com/cjwirth) ![inline 17%](github.png) [cjwirth](https://github.com/cjwirth) ![inline 3%](web.png) [cjwirth.com](http://cjwirth.com)

![left](caesar-snowboard.png)

---

# Goals

1. Write Web Server in Swift
  - MVP - Minimum Viable Pokédex
1. Deploy Server
1. ???
1. Profit

---
## HTTP Requests from the Client Side

```swift
func fetchPokedex(completion: ([Pokemon]? -> Void)) {
    let url = NSURL(string: "https://api.server.com/pokemon")!
    let request = NSURLRequest(URL: url)
    let session = NSURLSession.sharedSession()

    let task = session.dataTaskWithRequest(request) { data, _, _ in
        let maybePokemon = Pokemon.pokemonFromData(data)
        completion(maybePokemon)
    }
    
    task.resume()
}
```

---
![](darth-vader.jpg)
# What about the **_other_** side?

^ - Servers aren't usually written in Swift

^ - JS people have node.js and browser code

^ - What inspiration can we get?

---
# Ruby: Sinatra
```ruby
# Route to show all Posts, ordered like a blog
get '/posts' do
  content_type :json
  @things = Post.all(:order => :created_at.desc)

  @things.to_json
end

```

---
# node.js: Express
```javascript
var express = require('express');
var app = express();

app.get('/', function (req, res) {
  res.send('Hello World!');
});

app.listen(3000, function () {
  console.log('Example app listening on port 3000!');
});
```
---

> OH @ #tryswiftconf:
> I am Ruby and JavaScript developer. I don’t like type.
-- @ayanonagon, Ayaka Nonaka (March 2, 2016)

---
> I am a Swift developer. 
> I 😍 types.
-- Caesar Wirth (literally 2 seconds ago)

^ 

---
# What makes an HTTP Request?

```swift
protocol RequestType {
    var method: Method { get }
    var path: String { get }
    var headers: [Header] { get }
    var body: String? { get }
}

protocol ResponseType {
    var status: Status { get }
    var headers: [Header] { get }
    var body: String? { get }
}
```

^ - Intuitive

^ - Essentially the same as what we us on the native side

^ - Actually uses types

---
## Concrete Type to Instantiate 
``` swift
struct Response: ResponseType {
    var status: Status
    var headers: [Header] = []
    var body: String?

    init(status: Status, body: String) {
        self.status = status
        self.body = body
    }
}
```

^ - We need some sort of concrete type in order to instantiate a request

---
``` swift
typealias Header = (String, String)

enum Method: String {
    case Get = "GET"
    case Post = "POST"
    case Put = "PUT"
    case Delete = "DELETE"
    ...
}

enum Status: Int {
    case OK = 200
    case NotFound = 404
    case ServerError = 500
    ...
}
```
^ - No surprises here

^ - Exactly what we would expect

---
```swift
typealias ServerType = (RequestType -> ResponseType)
```

---
```swift
typealias ServerType = (RequestType -> ResponseType)
```
- Server takes requests and returns responses
- Protocols allow multiple types of responses
  - JSON
  - HTML
  - Errors
- Can run concurrently ...right?

---
![](confession-bear.jpg)

# Confession

^ - There is a lot of low-level work done

^ - Dealing with Sockets

^ - Threading

^ - HTTP Request Parsing

^ - Response Formatting

^ - I'm skipping over this and using libraries

---
# Hand-Wavy Magic ✨👐✨

```swift
// Defines RequestType, ResponseType Protocols
// With this, we can abstract away low-level details and app code
import Nest

// Takes care of socket IO, threading, request parsing, etc
import Curassow

// Parsing and Formatting JSON
import Jay
```

^ - There is a lot of low-level work done

^ - Dealing with Sockets

^ - Threading

^ - HTTP Request Parsing

^ - Response Formatting

^ - I'm skipping over this and using libraries

---
- Write

``` swift
import Curassow
// func serve(closure: RequestType -> ResponseType)

serve { _ in
    return Response(status: .OK, body: "Hello World!")
}
```

---
- Compile
```
$ swift build
```

- Run

```
$ .build/debug/App
[INFO] Listening at http://0.0.0.0:8000 (35238)
[INFO] Booting worker process with pid: 35239

$ curl http://localhost:8000
Hello World!

```

---
![](air-traffic-control.jpg)
# Routing

---

A single *`ServerType`* won't cover it

We need some way to handle different requests in different places

*`GET /users` and `POST /posts`* should not be handled in the same place


``` swift
router.get("/pokemon") { reqest in
	// Do Stuff!
}
```

---
``` swift
typealias Handler = (RequestType throws -> ResponseType)

class Router {
    private var routes: [String: [Method: Handler]] = [:]

    func route(method: Method, path: String, handler: Handler) { }

    func handle(request: RequestType) -> ResponseType { }
}
```

---
``` swift
typealias Handler = (RequestType throws -> ResponseType)

class Router {
    private var routes: [String: [Method: Handler]] = [:]

    func route(method: Method, path: String, handler: Handler) {
        if let existing = routes[path] {
            var editing = existing
            editing[method] = handler
            routes[path] = editing
        } else {
            routes[path] = [method: handler]
        }
    }
    ...
}
```

---
``` swift
class Router {
	...
	func handle(request: RequestType) -> ResponseType {
        // TODO: Get URL Parameter Parsing
        // eg. /users/:id --> will have a String parameter called "id"
        guard let method = request.HTTPMethod,
            let route = routes[request.path]?[method] else {
                return Error.NotImplemented
        }

        do {
            return try route(request)
        } catch {
            return Error.InternalServerError
        }
	}
}
```
---
#Did you notice?

``` swift
typealias ServerType = (RequestType -> ResponseType) 

class Router {
	func handle(request: RequestType) -> ResponseType { }
}
```
*`Router().handle` is a `ServerType`*

---
# Now we can do this

``` swift
let router = Router()
let server = router.handle

router.route(.Get, "/pokemon") { _ in
	return Response(.OK, body: "Pikachu")
}

serve(server)
```

---

# Demo

---
![left](zucks.jpg)

> 多分動くと思うから、リリースしようぜ！
- Mark Zuckerberg

---
# Deploying to Heroku

## What's Needed

1. swiftenv
1. .swift-version file
1. Procfile
1. heroku-buildpack-swift

---
**.swift-version**
`DEVELOPMENT-SNAPSHOT-2016-02-25-a`

**Procfile**
`web: App --workers 1 --bind 0.0.0.0:$PORT`

**Create Heroku Application**
`$ heroku create --buildpack https://github.com/kylef/heroku-buildpack-swift.git`
`$ heroku ps:scale web=1`

**Deploy!**
`$ git push heroku master`

^ Backup video: https://asciinema.org/a/doaq7247yty9pixb1sjeb2tjs?speed=2

---
Don't Reinvent the Wheel

- [Perfect](http://perfect.org/) by PerfectlySoft
	- 🎖 Most Mature Award 
	- 🏅 Easiest Setup Award
- [Kitura](https://github.com/IBM-Swift/Kitura) by IBM
	- ⚙ Modular Modules Award
	- 🍼 Baby Award (first commit 25 days ago)
- [Vapor](https://github.com/qutheory/vapor)
	- 😜 Most-Like-This-Talk Award

^ - Others exist, I just researched these ones
- Others:
- Zewo - cool, lots and lots of modules
- Blackfish - like the talk API
- express (in Swift) - based on the node.js one?

---
![inline](perfect-en.png)

![inline](perfect-jp.png)

---
# References

- [Hello Server Side Swift](https://medium.com/@LogMaestro/server-side-swift-c965b7ebe6e7#.ssuq3wg9w) - Logan Wright

- [Kyle Fuller](https://github.com/kylef)
  - Wrote both `swiftenv` and `heroku-buildpack-swift`

- [@zoonref](https://twitter.com/zoonref) - Made #tryPokemonConf logo

---

# [fit] Thanks!
# [fit] ご清聴ありがとうございました


