struct Transformation: Codable{
    let id: String
    let name: String
    let photo: String
    let info: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case info = "description"
        case photo
    }
    
    init(moTransformation: MOTransformation) {
        self.id = moTransformation.id ?? ""
        self.name = moTransformation.name ?? ""
        self.photo = moTransformation.photo ?? ""
        self.info = moTransformation.info ?? ""
    }
}
