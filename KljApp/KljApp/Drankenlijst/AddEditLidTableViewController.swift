import UIKit

class AddEditLidTableViewController: UITableViewController, UIImagePickerControllerDelegate,  UINavigationControllerDelegate {

    var lid:Lid!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var schuldLabel: UITextField!
    @IBOutlet weak var omschrijvingLabel: UITextField!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var wijzigBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        if let lid = lid {
            navigationItem.title = "Wijzig \(lid.naam)"
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
    
    @IBAction func wijzigBtnTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let alertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {action in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let libraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: {action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(libraryAction)
        }
        
        alertController.popoverPresentationController?.sourceView = sender
        
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            profileImg.image = selectedImage
            dismiss(animated: true, completion: nil)
        }
    }
    
}
