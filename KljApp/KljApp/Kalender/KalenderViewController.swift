import UIKit
import JTAppleCalendar

class KalenderViewController: UIViewController {
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

extension KalenderViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource{
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        dateFormatter.dateFormat = "dd MM yyyy"
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        
        let startDate = dateFormatter.date(from: "01 01 2018")!
        let endDate = dateFormatter.date(from: "01 01 2020")!

        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "KalenderCustomCell", for: indexPath) as! KalenderCustomCell
        
        cell.dateLabel.text = cellState.text
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        let cell = cell as! KalenderCustomCell
        calendar.calendarDelegate = self
        calendar.calendarDataSource = self
        
        cell.dateLabel.text = cellState.text
        
    }
    
    
    
}
