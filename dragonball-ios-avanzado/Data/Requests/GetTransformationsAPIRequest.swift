import Foundation

struct GetTransformationsAPIRequest: APIRequest {
    typealias Response = [Transformation]
    
    let path: String = "/api/heros/tranformations"
    let method: HTTPMethod = .POST
    let body: (any Encodable)?
    
    init(id: String) {
        body = RequestEntity(id: id)
    }
}

private extension GetTransformationsAPIRequest {
    struct RequestEntity: Encodable {
        let id: String
    }
}
