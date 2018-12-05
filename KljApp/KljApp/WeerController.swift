import Foundation

class WeerController {
    
    let baseURL = URL(string: "https://api.darksky.net/forecast/15c85cb1f7684eaf136aeda46d68f9bf/50.835470,4.910570?lang=nl&units=si&exclude=minutely,hourly,alerts,flags,daily")!
    
    func fetchWeerInfo(completion: @escaping (Weer?) -> Void){
    
        let task = URLSession.shared.dataTask(with: baseURL) { (data, response, error) in
            
            let decoder = JSONDecoder()
            
            do{
            if let data = data {
                let weer = try decoder.decode(Weer.self, from: data)
                print("KOMT GOED MAN")
                print(weer.icon)
                completion(weer)
            }
            else {
                completion(nil)
                print("JE REQUEST WERD GESKIPT")
            }
            }catch{
                print(error)
            }
        }
        task.resume()
    }
}
