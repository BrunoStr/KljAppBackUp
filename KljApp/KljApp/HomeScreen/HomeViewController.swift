import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var beschrijvingLabel: UILabel!
    @IBOutlet weak var temperatuurLabel: UILabel!
    @IBOutlet weak var luchtvochtigheidLabel: UILabel!
    @IBOutlet weak var weerImg: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var weerView: UIView!
    
    
    let weerController = WeerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Dit stelt de kleur van de LargeTitle in. Werkt niet via de attribute inspector (Bug)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        // Hier zet men de kleur van de notificationbar naar wit, ookal zet men hier .black (Bug)
        navigationController?.navigationBar.barStyle = .black
        
        //Hier zet men de kleur van de back button van de show segue naar wit
        navigationController?.navigationBar.tintColor = .white
        
        beschrijvingLabel.isHidden = true
        temperatuurLabel.isHidden = true
        luchtvochtigheidLabel.isHidden = true
        weerImg.isHidden = true
        spinner.isHidden = false
        
        spinner.startAnimating()
        
        weerView.layer.cornerRadius = 15
        
        weerController.fetchWeerInfo { (weer) in
            if let weer = weer {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                self.updateUI(with: weer)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }else{
                let alert = UIAlertController(title: "Geen connectie", message: "Check je verbinding en probeer het opnieuw.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Sluit", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    func updateUI(with weer: Weer){
        DispatchQueue.main.async {
            let temp = round(weer.temperatuur)
            let luchtVocht = (weer.luchtvochtigheid * 100)

            self.beschrijvingLabel.text = weer.beschrijving
            self.temperatuurLabel.text = "Temperatuur: \(temp) °C"
            self.luchtvochtigheidLabel.text = "Luchtvochtigheid: " + String(luchtVocht) + " %"
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
