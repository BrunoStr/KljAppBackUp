import UIKit

class LeidingTableViewController: UITableViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    @IBAction func rowPushed(_ sender: UITableViewCell) {
        print("Row pushed \(sender.index)")
        UIView.animate(withDuration: 0.5, animations: {
            
            /*
            
            let translateTransform = CGAffineTransform (translationX: 0, y: -10)
            //self.redSquare.transform = translateTransform
            
        }) { (_) in
            UIView.animate(withDuration: 0.5, animations: {
                //self.redSquare.transform = CGAffineTransform.identity
            }
        */
        })
 
      }
    }
