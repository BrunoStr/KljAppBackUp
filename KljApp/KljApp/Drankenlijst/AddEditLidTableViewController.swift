import UIKit

class AddEditLidTableViewController: UITableViewController {

    var lid:Lid!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var schuldLabel: UITextField!
    @IBOutlet weak var omschrijvingLabel: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        if let lid = lid {
            nameLabel.text = lid.naam
            schuldLabel.text = String(format: "%.2f", lid.teBetalen)
            omschrijvingLabel.text = lid.omschrijving
        }
        
        updateSaveButtonState()
    }

    func updateSaveButtonState(){
        let naam = nameLabel.text ?? ""
        let schuld = schuldLabel.text ?? ""
        let omschrijving = omschrijvingLabel.text ?? ""
        
        saveBtn.isEnabled = !naam.isEmpty && !schuld.isEmpty && isValidBedrag(bedrag: schuld) && !omschrijving.isEmpty
    }
    
    @IBAction func textInputChanged(_ sender: UITextField){
        updateSaveButtonState()
    }
    
    func isValidBedrag(bedrag:String) -> Bool{
        let bedragRegex = "[0-9]*.*[0-9]"
        let bedragTest = NSPredicate(format: "SELF MATCHES %@", bedragRegex)
        return bedragTest.evaluate(with: bedrag)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else {return}
        
        let naam = nameLabel.text ?? ""
        let schuld = Double(schuldLabel.text!)
        let omschrijving = omschrijvingLabel.text ?? ""
        
        lid = Lid(naam: naam, teBetalen: schuld!, omschrijving: omschrijving)
        
    }
}
