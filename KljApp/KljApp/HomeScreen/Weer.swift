import Foundation

struct Weer:Codable{
    var beschrijving:String
    var icon:String
    var temperatuur:Double
    var luchtvochtigheid:Double
    
    enum CodingKeys: String, CodingKey {
        case beschrijving = "summary"
        case icon
        case temperatuur = "temperature"
        case luchtvochtigheid = "humidity"
    }
    
    enum ParentKeys: CodingKey{
        case currently
    }
    
    
    init(from decoder:Decoder) throws {
        let parent = try decoder.container(keyedBy: ParentKeys.self)
        let valueContainer = try parent.nestedContainer(keyedBy: CodingKeys.self, forKey: .currently)
        
        self.beschrijving = try valueContainer.decode(String.self, forKey: .beschrijving)
        self.icon = try valueContainer.decode(String.self, forKey: .icon)
        self.temperatuur = try valueContainer.decode(Double.self, forKey: .temperatuur)
        self.luchtvochtigheid = try valueContainer.decode(Double.self, forKey:.luchtvochtigheid)
    }
 
}

