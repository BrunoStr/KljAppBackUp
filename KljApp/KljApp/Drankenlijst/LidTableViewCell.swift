import UIKit

class LidTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profielImg: UIImageView!
    @IBOutlet weak var naamLabel: UILabel!
    @IBOutlet weak var teBetalenLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func update(with lid:Lid){
        profielImg.image = #imageLiteral(resourceName: "KljLogo")
        naamLabel.text = lid.naam
        teBetalenLabel.text = String(format: "%.2f €", lid.teBetalen)
    }
}
