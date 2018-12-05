import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var weerLabel: UILabel!
    @IBOutlet weak var temperatuurLabel: UILabel!
    @IBOutlet weak var luchtvochtigheidLabel: UILabel!
    
    
    let weerController = WeerController()
    var weerObj:Weer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weerController.fetchWeerInfo { (weer) in
            if let weer = weer {
                self.updateUI(with: weer)
            }
        }
    }
    
    func updateUI(with weer: Weer){
        DispatchQueue.main.async {
            var temp = round(weer.temperatuur)
            var luchtVocht = round(weer.luchtvochtigheid)
            
            self.weerLabel.text = weer.beschrijving
            self.temperatuurLabel.text = "\(temp)°C"
            self.luchtvochtigheidLabel.text = "\(luchtVocht)%"
        }
    }
    
}
