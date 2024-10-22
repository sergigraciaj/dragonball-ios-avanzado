struct Hero: Equatable, Codable {
    let id: String
    let name: String
    let info: String
    let photo: String
    let favorite: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case info = "description"
        case photo
        case favorite
    }
    
    init(id: String, name: String, info: String, photo: String, favorite: Bool) {
        self.id = id
        self.name = name
        self.info = info
        self.photo = photo
        self.favorite = favorite
    }
    
    init(moHero: MOHero) {
        self.id = moHero.id ?? ""
        self.name = moHero.name ?? ""
        self.info = moHero.info ?? ""
        self.photo = moHero.photo ?? ""
        self.favorite = moHero.favorite
    }
}
