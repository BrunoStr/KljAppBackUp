import UIKit
import JTAppleCalendar

class KalenderViewController: UIViewController {
    
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var maandLabel: UILabel!
    @IBOutlet weak var jaarLabel: UILabel!
    @IBOutlet weak var activiteitNaam: UILabel!
    @IBOutlet weak var activiteitOmschrijving: UILabel!
    @IBOutlet weak var activiteitDatum: UILabel!
    @IBOutlet weak var activiteitStartUur: UILabel!
    @IBOutlet weak var activiteitEindUur: UILabel!
    
    let todaysDate = Date()
    var eventsFromServer: [String:Activiteit] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hier zetten we een timer zodat het lijkt dat we met server praten
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let serverObjects = self.getServerEvents()
            
            //Hier converten we de dictionary [date:string] naar [string:string]
            for(date, event) in serverObjects {
                let stringData = self.dateFormatter.string(from: date)
                self.eventsFromServer[stringData] = event
            }
        }
        
        DispatchQueue.main.async {
            self.calendarView.reloadData()
        }
        
        //Dit stelt de kleur van de LargeTitle in. Werkt niet via de attribute inspector (Bug)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        // Hier zet men de kleur van de notificationbar naar wit, ookal zet men hier .black (Bug)
        navigationController?.navigationBar.barStyle = .black
        
        setUpCalendarView()
    }
    
    
    func setUpCalendarView(){
        
        //Dit doen we om de insets/padding van de custom cell te verwijderen. Op die manier wanier we op een datum klikken zal er een volledige cirkel getoond worden en geen afgesneden cirkel
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        calendarView.visibleDates { (visibleDates) in
            self.handleViewsOfCalendar(from: visibleDates)
        }
        
        calendarView.scrollToDate(Date(),animateScroll: true)
        calendarView.selectDates([ Date() ])
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState){
        guard let validCell = view as? KalenderCustomCell else {return}
        
        dateFormatter.dateFormat = "dd MM yyyy"
        //Ik vorm Date objecten om naar strings omdat Date minuten, uren, ... bezitten en string niet.
        let todaysDateString = dateFormatter.string(from: todaysDate)
        let selectedDateString = dateFormatter.string(from: cellState.date)
        
        //Hier check ik of datum van vandaag overeenkomt met de geselecteerde datum
        if todaysDateString == selectedDateString{
            validCell.today.isHidden = false
            validCell.selectedView.isHidden = true
        }else{
            
            //Wanneer de cell niet geselecteerd is, zullen de dagen buiten de maand mindere opacity krijgen dan de dagen van de maand
            if cellState.isSelected {
                validCell.dateLabel.textColor = .white
            }else{
                if cellState.dateBelongsTo == .thisMonth{
                    let monthcolor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
                    validCell.dateLabel.textColor = monthcolor
                }else{
                    let outsidemonthcolor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.3)
                    validCell.dateLabel.textColor = outsidemonthcolor
                }
                
            }
            
        }

    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState){
        guard let validCell = view as? KalenderCustomCell else {return}
        
        if cellState.isSelected {
            validCell.selectedView.isHidden = false
            
            if eventsFromServer.contains(where: {$0.key == dateFormatter.string(from: cellState.date)} ){
                if let activiteit = self.eventsFromServer[dateFormatter.string(from: cellState.date)] {
                    self.activiteitNaam.text = activiteit.naam
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    self.activiteitDatum.text = dateFormatter.string(from: cellState.date)
                    self.activiteitStartUur.text = "\(activiteit.startUur) Uur"
                    self.activiteitEindUur.text = "\(activiteit.eindUur) Uur"
                    self.activiteitOmschrijving.text = activiteit.omschrijving
                }
                
            }
            
        }else{
            validCell.selectedView.isHidden = true
            validCell.today.isHidden = true
        }

    }
    
    func handleViewsOfCalendar(from visibleDates: DateSegmentInfo){
        
        let date = visibleDates.monthDates.first!.date
        
        dateFormatter.dateFormat = "yyyy"
        jaarLabel.text = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "MMMM"
        maandLabel.text = dateFormatter.string(from: date)
    }
    
}

extension KalenderViewController: JTAppleCalendarViewDataSource{
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        dateFormatter.dateFormat = "dd MM yyyy"
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        
        let startDate = dateFormatter.date(from: "01 12 2018")!
        let endDate = dateFormatter.date(from: "01 01 2020")!

        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 6, calendar: .current, generateInDates: .forFirstMonthOnly, generateOutDates: .off, firstDayOfWeek: .monday, hasStrictBoundaries: true)
        
        return parameters
    }
}

extension KalenderViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "KalenderCustomCell", for: indexPath) as! KalenderCustomCell
        
        cell.dateLabel.text = cellState.text
        
        //Dit doen we zodat wanneer we een cell selecteren er geen andere random cell geselecteerd wordt (bug in library)
       handleCellSelected(view: cell, cellState: cellState)
       handleCellTextColor(view: cell, cellState: cellState)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        let cell = cell as! KalenderCustomCell
        
        cell.dateLabel.text = cellState.text
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)

    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)

    }
    
    //Deze functie wordt opgeroepen wanneer de gebruiker door de kalender scrollt
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        
        handleViewsOfCalendar(from: visibleDates)
        
    }
    
}

extension KalenderViewController {
    func getServerEvents() -> [Date:Activiteit]{
        dateFormatter.dateFormat = "dd MM yyyy"
        
        return [
            dateFormatter.date(from: "22 12 2018")!: Activiteit(naam: "Hallo", omschrijving: "Dit is activiteit 1: We spelen dropping vandaag. Trek je stoute schoenen aan en ontsnap zo lang mogelijk van de leiding. Lukt het je om te ontsnappen staat er een prijs te winnen, zeker komen dus!Dit is activiteit 1: We spelen dropping vandaag. Trek je stoute schoenen aan en ontsnap zo lang mogelijk van de leiding. Lukt het je om te ontsnappen staat er een prijs te winnen, zeker komen dus!", leeftijdsgroep: "+16", startUur: "15:00", eindUur: "18:00"),
            dateFormatter.date(from: "23 12 2018")!: Activiteit(naam: "Hoy", omschrijving: "Dit is activiteit 2", leeftijdsgroep: "+16", startUur: "15:00", eindUur: "18:00"),
            dateFormatter.date(from: "24 12 2018")!: Activiteit(naam: "Beste", omschrijving: "Dit is activiteit 3", leeftijdsgroep: "+16", startUur: "15:00", eindUur: "18:00"),
            dateFormatter.date(from: "25 12 2018")!: Activiteit(naam: "Gey", omschrijving: "Dit is activiteit 4", leeftijdsgroep: "+16", startUur: "15:00", eindUur: "18:00")

        ]
    }
}
