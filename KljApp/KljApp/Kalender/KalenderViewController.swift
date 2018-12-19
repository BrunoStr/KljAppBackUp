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
    @IBOutlet weak var activiteitUrenStackView: UIStackView!
    @IBOutlet weak var activiteitLeeftijd: UIButton!
    
    let todaysDate = Date()
    var eventsFromServer: [String:Activiteit] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hier zetten we een timer zodat het lijkt dat we met server praten
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let serverObjects = self.getServerEvents()
            
            //Hier converten we de dictionary [date:string] naar [string:string]
            for(date, event) in serverObjects {
                let stringData = self.dateFormatter.string(from: date)
                self.eventsFromServer[stringData] = event
            }
            print("Events opgehaald...")
            
            
            DispatchQueue.main.async {
                self.calendarView.reloadData()
                print("KalenderView reloaded...")
            }
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
    
    func handleCellBackgroundColor(view: JTAppleCell?, cellState: CellState){
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
                    self.activiteitUrenStackView.isHidden = false
                    self.activiteitOmschrijving.isHidden = false
                    
                    self.activiteitNaam.text = activiteit.naam
                    self.activiteitLeeftijd.setTitle(activiteit.leeftijdsgroep, for: .normal)
                    self.activiteitLeeftijd.backgroundColor = UIColor(displayP3Red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    self.activiteitDatum.text = dateFormatter.string(from: cellState.date)
                    self.activiteitStartUur.text = "\(activiteit.startUur) Uur"
                    self.activiteitEindUur.text = "\(activiteit.eindUur) Uur"
                    self.activiteitOmschrijving.text = activiteit.omschrijving
                }
                
            }else{
                self.activiteitNaam.text = "Geen activiteit"
                dateFormatter.dateFormat = "dd/MM/yyyy"
                self.activiteitDatum.text = dateFormatter.string(from: cellState.date)
                self.activiteitUrenStackView.isHidden = true
                self.activiteitOmschrijving.isHidden = true
                self.activiteitLeeftijd.setTitle("😥", for: .normal)
                self.activiteitLeeftijd.backgroundColor = UIColor.white
            }
            
        }else{
            validCell.selectedView.isHidden = true
            validCell.today.isHidden = true
        }

    }
    
    //Hier stellen we de naam van de maand en jaar in mbv de eerste visibledate
    func handleViewsOfCalendar(from visibleDates: DateSegmentInfo){
        
        let date = visibleDates.monthDates.first!.date
        
        dateFormatter.dateFormat = "yyyy"
        jaarLabel.text = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "MMMM"
        let datum = dateFormatter.string(from: date)
        
        switch datum {
        case "January":
            maandLabel.text = "Januari"
        case "February":
            maandLabel.text = "Februari"
        case "March":
            maandLabel.text = "Maart"
        case "April":
            maandLabel.text = "April"
        case "May":
            maandLabel.text = "Mei"
        case "June":
            maandLabel.text = "Juni"
        case "July":
            maandLabel.text = "Juli"
        case "August":
            maandLabel.text = "Augustus"
        case "September":
            maandLabel.text = "September"
        case "October":
            maandLabel.text = "Oktober"
        case "November":
            maandLabel.text = "November"
        case "December":
            maandLabel.text = "December"
            
        default:
            maandLabel.text = "Random"
        }
    }
    
    //Wanneer de datum een event bevat, geef dotevent weer
    func handleEvents(cell:KalenderCustomCell, cellState:CellState){
        cell.eventDot.isHidden = !eventsFromServer.contains{$0.key == dateFormatter.string(from: cellState.date)}
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
       handleCellBackgroundColor(view: cell, cellState: cellState)
       handleEvents(cell: cell, cellState: cellState)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        let cell = cell as! KalenderCustomCell
        
        cell.dateLabel.text = cellState.text
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        let kalCell = cell as! KalenderCustomCell
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellBackgroundColor(view: cell, cellState: cellState)
        handleEvents(cell: kalCell, cellState: cellState)


    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        let kalCell = cell as! KalenderCustomCell
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellBackgroundColor(view: cell, cellState: cellState)
        handleEvents(cell: kalCell, cellState: cellState)


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
            dateFormatter.date(from: "22 12 2018")!: Activiteit(naam: "Dropping", omschrijving: "Dit is activiteit 1: We spelen dropping vandaag. Trek je stoute schoenen aan en ontsnap zo lang mogelijk van de leiding. Lukt het je om te ontsnappen staat er een prijs te winnen, zeker komen dus! Dit is activiteit 1: We spelen dropping vandaag. Trek je stoute schoenen aan en ontsnap zo lang mogelijk van de leiding. Lukt het je om te ontsnappen staat er een prijs te winnen, zeker komen dus!", leeftijdsgroep: "+16", startUur: "19:00", eindUur: "22:00"),
            dateFormatter.date(from: "23 12 2018")!: Activiteit(naam: "Pleinspelen", omschrijving: "Kom vandaag de nieuwste pleinspelen spelen op en kaap samen met je vrienden prijzen weg. Vergeet zeker je speelkleren niet! Kom vandaag de nieuwste pleinspelen spelen op en kaap samen met je vrienden prijzen weg. Vergeet zeker je speelkleren niet! Kom vandaag de nieuwste pleinspelen spelen op en kaap samen met je vrienden prijzen weg. Vergeet zeker je speelkleren niet!", leeftijdsgroep: "-12", startUur: "14:00", eindUur: "18:00"),
            dateFormatter.date(from: "24 12 2018")!: Activiteit(naam: "Karaoke avond", omschrijving: "Maak je klaar voor een avond vol dans en muziek. Vergeet ook zeker jullie stembanden niet in te smeren. Wie zal de origineelste performance brengen? Maak je klaar voor een avond vol dans en muziek. Vergeet ook zeker jullie stembanden niet in te smeren. Wie zal de origineelste performance brengen? Maak je klaar voor een avond vol dans en muziek. Vergeet ook zeker jullie stembanden niet in te smeren. Wie zal de origineelste performance brengen?", leeftijdsgroep: "+12", startUur: "18:00", eindUur: "21:00"),
            dateFormatter.date(from: "25 12 2018")!: Activiteit(naam: "Ontbijt op bed", omschrijving: "Vandaag zullen wij heel Vissenaken voorzien van heerlijke ontbijtjes. Er is veel werk te doen dus helpende handjes is zeker welkom. Vandaag zullen wij heel Vissenaken voorzien van heerlijke ontbijtjes. Er is veel werk te doen dus helpende handjes is zeker welkom. Vandaag zullen wij heel Vissenaken voorzien van heerlijke ontbijtjes. Er is veel werk te doen dus helpende handjes is zeker welkom.", leeftijdsgroep: "+16", startUur: "07:00", eindUur: "12:00")

        ]
    }
}
