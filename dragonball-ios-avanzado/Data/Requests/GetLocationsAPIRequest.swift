import Foundation

struct GetLocationsAPIRequest: APIRequest {
    typealias Response = [Location]
    
    let path: String = "/api/heros/locations"
    let method: HTTPMethod = .POST
    let body: (any Encodable)?
    
    init(id: String) {
        body = RequestEntity(id: id)
    }
}

private extension GetLocationsAPIRequest {
    struct RequestEntity: Encodable {
        let id: String
    }
}
