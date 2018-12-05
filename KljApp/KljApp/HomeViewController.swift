import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var beschrijvingLabel: UILabel!
    @IBOutlet weak var temperatuurLabel: UILabel!
    @IBOutlet weak var luchtvochtigheidLabel: UILabel!
    @IBOutlet weak var weerImg: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    let weerController = WeerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beschrijvingLabel.isHidden = true
        temperatuurLabel.isHidden = true
        luchtvochtigheidLabel.isHidden = true
        weerImg.isHidden = true
        spinner.isHidden = false
        spinner.startAnimating()
        
        weerController.fetchWeerInfo { (weer) in
            if let weer = weer {
                self.updateUI(with: weer)
            }
        }
    }
    
    func updateUI(with weer: Weer){
        DispatchQueue.main.async {
            let temp = round(weer.temperatuur)
            let luchtVocht = (weer.luchtvochtigheid * 100)
            
            self.beschrijvingLabel.text = weer.beschrijving
            self.temperatuurLabel.text = "Temperatuur: \(temp) °C"
            self.luchtvochtigheidLabel.text = String(luchtVocht) + " %"
            self.weerImg.image = UIImage(named: "\(weer.icon)")
            
            self.beschrijvingLabel.isHidden = false
            self.temperatuurLabel.isHidden = false
            self.luchtvochtigheidLabel.isHidden = false
            self.weerImg.isHidden = false
            self.spinner.isHidden = true
            self.spinner.stopAnimating()
        }
    }
    
}
