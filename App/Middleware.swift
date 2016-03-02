
typealias Middleware = (Handler -> Handler)

func SecretPasswordAuthMiddleware(handler: Handler) -> Handler {
    return { request in
        let passwordKey = "X-Secret-Password-Sshh"
        let correctPassword = "CorrectHorseBatteryStaple"

        if let password = request.getHeader(passwordKey)
            where password == correctPassword {

            return try handler(request)
        } else {
            return Error.Unauthorized
        }
    }
}
