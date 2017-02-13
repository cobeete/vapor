import Vapor
import VaporPostgreSQL
import HTTP

let drop = Droplet(
    providers: [VaporPostgreSQL.Provider.self]
)

drop.get("version") { request in
    if let db = drop.database?.driver as? PostgreSQLDriver {
        let version = try db.raw("SELECT version()")
        return try JSON(node: version)
    } else {
        return "No db connection"
    }
}

drop.get("hello") { request in
    guard let name = request.data["name"]?.string else {
        throw Abort.badRequest
    }
    return "Hello, \(name)!"
}	

drop.get("vapor") { request in
    return Response(redirect: "http://vapor.codes")
}

drop.get("error") { request in
    throw Abort.custom(status: .badRequest, message: "Sorry 😱")
}

drop.post("user") { request in
	guard let name = request.data["name"]?.string else {
		throw Abort.custom(status: .badRequest, message: "request error")
	}
	print(name)
	var user = User(name: name)
	try user.save()
	return "ok"
}

drop.preparations.append(User.self)

drop.run()
