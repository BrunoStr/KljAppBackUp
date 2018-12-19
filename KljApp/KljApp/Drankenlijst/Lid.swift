import Foundation

struct Lid:Codable {
    var naam:String
    var teBetalen:Double
    var omschrijving:String
    
    static let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveUrl = documentsDir.appendingPathComponent("Leden_saved").appendingPathExtension("plist")
    
    static func saveToFile(leden:[Lid]){
        let propertyListEncoder = PropertyListEncoder()
        let encodedLeden = try? propertyListEncoder.encode(leden)
        try? encodedLeden?.write(to: archiveUrl, options: .noFileProtection)
    }
    
    static func loadFromFile() -> [Lid]{
        var leden: [Lid] = []
        let propertyListDecoder = PropertyListDecoder()
        if let retrieveLedenData = try? Data(contentsOf: archiveUrl),
            let decodedLeden = try? propertyListDecoder.decode(Array<Lid>.self, from: retrieveLedenData){
            leden.append(contentsOf: decodedLeden)
        }
        return leden
    }
    
    static func loadSampleLeden() -> [Lid]{
        let leden = [
            Lid(naam: "Bruno", teBetalen: 20.0, omschrijving: "Deze jongen hoeft niet te betalen"),
            Lid(naam: "Maarten", teBetalen: 10.0, omschrijving: "Deze jongen hoeft niet te betalen"),
            Lid(naam: "Jonas", teBetalen: 5.0, omschrijving: "Deze jongen hoeft niet te betalen")
        ]
        
        return leden
    }
    
    

}
