import UIKit

class DrankenLijstTableViewController: UITableViewController {
    
    var leden: [Lid] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Dit stelt de kleur van de LargeTitle in. Werkt niet via de attribute inspector (Bug)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        // Hier zet men de kleur van de notificationbar naar wit, ookal zet men hier .black (Bug)
        navigationController?.navigationBar.barStyle = .black
        
        if Lid.loadFromFile().count != 0{
            leden.append(contentsOf: Lid.loadFromFile())
        }else{
            leden.append(contentsOf: Lid.loadSampleLeden())
        }
        
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return leden.count
        }
        else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LidCell", for: indexPath) as! LidTableViewCell
        
        let lid = leden[indexPath.row]
        cell.update(with: lid)
        Lid.saveToFile(leden: leden)

        cell.showsReorderControl = true

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        let tableViewEditingMode = tableView.isEditing
        
        tableView.setEditing(!tableViewEditingMode, animated: true)
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedLid = leden.remove(at: fromIndexPath.row)
        leden.insert(movedLid, at: to.row)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            leden.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editEmoji"{
            let indexPath = tableView.indexPathForSelectedRow!
            let lid = leden[indexPath.row]
            //Deze tussenstap nodig anders kan hij niet deftig casten
            let navController = segue.destination as! UINavigationController
            let addEditLidTableViewController = navController.topViewController as! AddEditLidTableViewController
            
            addEditLidTableViewController.lid = lid
            
        }
    }
    
    @IBAction func unwindToLidTableView(segue: UIStoryboardSegue){
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! AddEditLidTableViewController
        
        if let lid = sourceViewController.lid{
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                
                leden[selectedIndexPath.row] = lid
                Lid.saveToFile(leden: leden)
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                
            }else{
                
                let newIndexPath = IndexPath(row: leden.count, section: 0)
                leden.append(lid)
                Lid.saveToFile(leden: leden)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
            }
        }
        
    }

}
