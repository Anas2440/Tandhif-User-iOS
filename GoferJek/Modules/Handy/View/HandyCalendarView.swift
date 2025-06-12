//
//  HandyCalendarView.swift
//  GoferHandy
//
//  Created by trioangle on 31/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class HandyCalendarView: BaseView {
    
    var calendarVC : HandyCalendarVC!
    
    
    //MARK:- Outlets
    @IBOutlet weak var headerView : HeaderView!
    @IBOutlet weak var titleLbl : SecondaryHeaderLabel!
    @IBOutlet weak var dateCollectionView :UICollectionView!
    @IBOutlet weak var hourlyTableView : CommonTableView!
    @IBOutlet weak var topHolderView: TopCurvedView!
    @IBOutlet weak var contentHolderView: UIView!
    @IBOutlet weak var bottomView: TopCurvedView!
    
    @IBOutlet weak var monthNameLbl : SecondaryHeaderLabel!
    @IBOutlet weak var nextMonthBtn : UIButton!
    @IBOutlet weak var prevMonthBtn : UIButton!
    @IBOutlet weak var monthTitleBGView: UIView!
    
    @IBOutlet weak var submitBtn : PrimaryButton!
    
    override func darkModeChange() {
        super.darkModeChange()
        self.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.dateCollectionView.backgroundColor = self.isDarkStyle ? .DarkModeBackground : .SecondaryColor
        self.monthTitleBGView.backgroundColor = UIColor.TertiaryColor.withAlphaComponent(0.1)
        self.titleLbl.customColorsUpdate()
        self.topHolderView.customColorsUpdate()
        self.bottomView.customColorsUpdate()
        self.headerView.customColorsUpdate()
        self.dateCollectionView.reloadData()
        self.monthNameLbl.customColorsUpdate()
        self.hourlyTableView.customColorsUpdate()
        self.hourlyTableView.reloadData()
        
    }
    //MARK:- Actions
    @IBAction
    override func backAction(_ sender : UIButton){
        super.backAction(sender)
    }
    @IBAction
    func switchMonthAction(_ sender : UIButton){
        self.selectedHour = nil
        if sender == self.nextMonthBtn{
            dates = self.calendarVC.getNexMonthDates()
        }else if sender == self.prevMonthBtn{
            dates = self.calendarVC.getPreviousMonthDates()
            
        }
        
        self.selectedDate = dates.first
        self.dateCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0),
                                             at: .left, animated: false)
    }
    @IBAction
    func confirmAction(_ sender : UIButton){
//        self.calendarVC.navigateToHandyRequestScreen()
      
      if let selectedDate = self.selectedDate,
        let selectedHour = self.selectedHour {
        let weekDay = DayEnum(fromInt: selectedDate.weekDay.rawValue)
        let hour = self.calendarVC.weekDataSource[weekDay]?.value(atSafe: selectedHour)
        
        
        
        let formattedDate = selectedDate.handyFormattedString
        print("-------->Formated String \(formattedDate)")
        guard let time = hour else{return}
        
        if self.calendarVC.isForEditTime {
            if let jobID = self.calendarVC.jobID,
               let jobReqID = self.calendarVC.jobReqID {
                self.calendarVC.editJobTimeUpdate(date: formattedDate,
                                                  time: time,
                                                  jobID: jobID,
                                                  jobReqID: jobReqID)
            }
        } else {
            self.calendarVC.donePicking(date: formattedDate, time: time)
        }
        
      }
    
      
     
    }
    //MARK:- Variables
    var dates : [Date] = []{
        didSet{
            guard self.calendarVC.isViewLoaded else {return}
            self.dateCollectionView.reloadData()
            self.setMonthName(fromDate: self.dates.first)
        }
    }
    var selectedDate : Date?{
        didSet{self.checkButtonStatus()}
    }
    var selectedHour : Int?{
        didSet{self.checkButtonStatus()}
    }
    //MAKR:- Life Cycle
    
    override func didLoad(baseVC: BaseViewController) {
        super.didLoad(baseVC: baseVC)
        self.calendarVC = baseVC as? HandyCalendarVC
        self.initView()
        self.initLanguage()
        self.darkModeChange()
        self.checkButtonStatus()
    }
    override func willAppear(baseVC: BaseViewController) {
        super.willAppear(baseVC: baseVC)
        if dates.isEmpty{
            dates = self.calendarVC.getCurrentMonthDates()
            self.selectedDate = dates.first
            self.dateCollectionView.reloadData()
            self.hourlyTableView.reloadData()
            
            self.goToLastPosition()
        }
        
    }
    override func didAppear(baseVC: BaseViewController) {
        super.didAppear(baseVC: baseVC)
    }
    //MARK:- initializers
    
    func initView(){
        self.titleLbl.text = LangHandy.bookingDate.capitalized
        self.submitBtn.setTitle(LangCommon.common1Continue.capitalized,
                                for: .normal)
        
        self.monthTitleBGView.cornerRadius = 15
        
        self.dateCollectionView.delegate = self
        self.dateCollectionView.dataSource = self
        
        
        self.hourlyTableView.delegate = self
        self.hourlyTableView.dataSource = self
        
        
        if isRTLLanguage {
            self.nextMonthBtn.transform = CGAffineTransform(rotationAngle: .pi)
            self.prevMonthBtn.transform = .identity
        } else {
            self.nextMonthBtn.transform = .identity
            self.prevMonthBtn.transform = CGAffineTransform(rotationAngle: .pi)
        }
        
    }
    func initLanguage(){
        
    }
    //MARK:- UDF
    func goToLastPosition() {
        if let date = self.calendarVC.jobDate,
           let pos = self.dates.find(includedElement: {$0.handyFormattedString == date.handyFormattedString}),
           self.calendarVC.isForEditTime {
            let format = DateFormatter()
            format.timeZone = TimeZone(identifier: "UTC")
            format.dateFormat = "HH:mm:ss"
            let time = format.string(from: date)
            self.selectedDate = self.dates.value(atSafe: pos)
            self.selectedHour = self.calendarVC.weekDataSource.first?.value.find(includedElement: {$0.time == time})
            self.setMonthName(fromDate: self.selectedDate)
            self.dateCollectionView.scrollToItem(at: IndexPath(item: pos, section: 0),
                                                 at: .right,
                                                 animated: true)
            
        } else {
            if case JobBookingType.bookLater(date: let date, time: let time) = Shared.instance.currentBookingType,
               let pos = self.dates.find(includedElement: {$0.handyFormattedString == date}){
                self.selectedDate = self.dates.value(atSafe: pos)
                self.selectedHour = self.calendarVC.weekDataSource.first?.value.find(includedElement: {$0.time == time.time})
                self.setMonthName(fromDate: self.selectedDate)
                self.dateCollectionView.scrollToItem(at: IndexPath(item: pos, section: 0),
                                                     at: .right,
                                                     animated: true)
            }
        }
        
        
    }
    func setMonthName(fromDate date : Date?){
        if let month = date?.month.description.capitalized,
            let year = date?.year{
            self.monthNameLbl.text = "\(month) \(year)"
        }else{
            self.monthNameLbl.text = nil
        }
    }
    func scrollToTop(){
//        self.hourlyTableView.scrollsToTop = true
        guard !self.calendarVC.weekDataSource.isEmpty else{
            return
        }
        
        if let hourPosition = self.selectedHour{
            
            self.hourlyTableView.scrollToRow(at: IndexPath(row: hourPosition, section: 0),
                                             at: .bottom,
                                             animated: true)
        }else{
            self.hourlyTableView.scrollToRow(at: IndexPath(row: 0, section: 0),
                                             at: .top,
                                             animated: false)
        }
    }
    func checkButtonStatus(){
        if self.selectedDate != nil{
//            self.prevMonthBtn.isHidden = !(_selectedDate >= Date())
        }
        guard self.submitBtn != nil else{return}
        self.submitBtn.setMainActive(self.selectedDate != nil && self.selectedHour != nil)
    }
    
}
//MARK:- UICollectionViewDataSource
extension HandyCalendarView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : HandyCalendarCVC = collectionView.dequeueReusableCell(for: indexPath)
        guard let date = self.dates.value(atSafe: indexPath.item) else{return cell}
        cell.dayLbl.text = date.weekDay.description.capitalized
        cell.dateLbl.text = date.description.split(separator: " ").first?.suffix(2).description
//        cell.holderView.backgroundColor = date == self.selectedDate ? .ThemeMain : .white
        cell.ThemeChange()
        cell.holderView.backgroundColor = date == self.selectedDate ? .PrimaryColor : UIColor.TertiaryColor.withAlphaComponent(0.1)
        cell.dayLbl.textColor = date == self.selectedDate ? .PrimaryTextColor : nil
        return cell
    }
    

}
//MARK:- UICollectionViewDelegate
extension HandyCalendarView : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedDate = self.dates.value(atSafe: indexPath.item)
        self.selectedHour = nil
        self.setMonthName(fromDate: self.selectedDate)
        collectionView.reloadData()
        hourlyTableView.reloadData()
        self.scrollToTop()
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.monthNameSettingDuringScroll()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.monthNameSettingDuringScroll()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.monthNameSettingDuringScroll()
    }
    
    
    func monthNameSettingDuringScroll() {
        let middleDateCell = self.dateCollectionView.visibleCells.count/2
        let cell = self.dateCollectionView.visibleCells.value(atSafe: middleDateCell)
        if let cell = cell {
            let indexPath = self.dateCollectionView.indexPath(for: cell)
            if let indexPath = indexPath {
                let selectedDateMonth = self.dates.value(atSafe: indexPath.item)
                if let _selectedDateMonth = selectedDateMonth {
                    self.setMonthName(fromDate: _selectedDateMonth)
                } else {
                    self.setMonthName(fromDate: self.dates.last)
                }
            }
        }
    }
    
    
}
//MARK:- UICollectionViewDelegateFlowLayout
extension HandyCalendarView : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 120)
    }
}
//MARK:- UITableViewDataSource
extension HandyCalendarView : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.calendarVC.weekDataSource.first?.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HandyHourlyTVC = tableView.dequeueReusableCell(for: indexPath)
        
        guard let date = self.selectedDate else{ return cell}
        let weekDay = DayEnum(fromInt: date.weekDay.rawValue)
        guard let item = self.calendarVC.weekDataSource[weekDay]?.value(atSafe: indexPath.row) else{return cell}
        
        cell.ThemeChange()
        cell.timeLbl.text = item.value
        cell.radioIV.image = indexPath.row == self.selectedHour ? UIImage(named: "radio_on") : UIImage(named: "radio_off")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let today = Date()
        let todaySTR = dateFormatter.string(from: today)
        let selectedSTR = dateFormatter.string(from: date)
        if todaySTR == selectedSTR{
            let calendar = Calendar.current

            var hour = calendar.component(.hour, from: today)
            let minutes = calendar.component(.minute, from: today)
            if minutes > 0{
                hour += 1
            }
            let canInteract = indexPath.row > hour
            cell.contentView.alpha = canInteract ? 1 : 0.5
            cell.contentView.isUserInteractionEnabled = canInteract
            if canInteract{
                cell.contentView.alpha = item.status ? 1 : 0.45
                cell.contentView.isUserInteractionEnabled = item.status
            }
            
        }else{
            cell.contentView.alpha = item.status ? 1 : 0.45
            cell.contentView.isUserInteractionEnabled = item.status
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
//MARK:- UITableViewDelegate
extension HandyCalendarView : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let date = self.selectedDate else{ return }
        let weekDay = DayEnum(fromInt: date.weekDay.rawValue)
        guard let item = self.calendarVC
            .weekDataSource[weekDay]?
            .value(atSafe: indexPath.row),
            item.status else{return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let today = Date()
        let todaySTR = dateFormatter.string(from: today)
        let selectedSTR = dateFormatter.string(from: date)
        if todaySTR == selectedSTR{
            let calendar = Calendar.current

            var hour = calendar.component(.hour, from: today)
            let minutes = calendar.component(.minute, from: today)
            if minutes > 0{
                hour += 1
            }
            let canInteract = indexPath.row > hour
            guard canInteract else {return}
            
        }
        
        self.selectedHour = indexPath.row
        tableView.reloadData()
        
    }
}
