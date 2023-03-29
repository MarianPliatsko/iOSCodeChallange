//
//  DetailViewController.swift
//  iOSCodeChallange
//
//  Created by mac on 2023-03-25.
//

import UIKit

final class CalendarViewController: UIViewController {
    
    //MARK: - Properties
    
    let calendarHelper = CalendarHelper()
    let networkService = StubNetworkService()
    var selectedDate = Date()
    var totalDaysInMonth = [CalendarDay]()
    var sheduleEvents: Shedule?
    
    //MARK: - Outlet
    
    @IBOutlet weak var monthAndYearLabel: UILabel!
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var calendarTableView: UITableView!
    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        flowLayout()
        
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource  = self
        calendarCollectionView.register(CalendarCollectionViewCell.nib(),
                                        forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
        
        calendarTableView.delegate = self
        calendarTableView.dataSource = self
        calendarTableView.register(CalendarTableViewCell.nib(),
                                   forCellReuseIdentifier: CalendarTableViewCell.identifier)
        
        setMonth()
    }
    
    //MARK: - IBAction
    
    @IBAction func previousMonthBtnPressed(_ sender: UIButton) {
        selectedDate = calendarHelper.minusMonth(date: selectedDate)
        setMonth()
    }
    
    @IBAction func nextMonthBtnPressed(_ sender: UIButton) {
        selectedDate = calendarHelper.plusMonth(date: selectedDate)
        setMonth()
    }
    
    //MARK: - Methods
    
    func flowLayout(){
        let width = (calendarCollectionView.frame.size.width - 2) / 8
        let height = (calendarCollectionView.frame.size.height - 2) / 8
        
        let flowLayout = calendarCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.itemSize = CGSize(width: width, height: height)
    }
    
    func setMonth() {
        totalDaysInMonth.removeAll()
        let daysInMonth = calendarHelper.daysInMonth(date: selectedDate)
        let firstDayOfMonth = calendarHelper.firstOfMonth(date: selectedDate)
        let startingSpaces = calendarHelper.weekDay(date: firstDayOfMonth)
        
        let previousMonth = calendarHelper.minusMonth(date: selectedDate)
        let daysInPreviousMonth = calendarHelper.daysInMonth(date: previousMonth)
        
        var count = 1
        
        while totalDaysInMonth.count < 35 {
            let calendarDay: CalendarDay
            if count <= startingSpaces {
                let previosMonthDay = daysInPreviousMonth - startingSpaces + count
                calendarDay = CalendarDay(day: String(previosMonthDay),
                                          month: .previous)
            } else if count - startingSpaces > daysInMonth {
                calendarDay = CalendarDay(day: String(count - daysInMonth - startingSpaces),
                                          month: .next)
            } else {
                calendarDay = CalendarDay(day: String(count - startingSpaces),
                                          month: .current)
            }
            totalDaysInMonth.append(calendarDay)
            count += 1
        }
        monthAndYearLabel.text = calendarHelper.monthToString(date: selectedDate) + " " + calendarHelper.yearToString(date: selectedDate)
        calendarCollectionView.reloadData()
    }
}

// MARK: - extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalDaysInMonth.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarCollectionViewCell.identifier,
            for: indexPath) as? CalendarCollectionViewCell else {return UICollectionViewCell()}
        
        let calendarDay = totalDaysInMonth[indexPath.item]
        let currentDate = calendarHelper.monthToString(date: selectedDate)
        let dayType: DayType
        if calendarDay.month == CalendarDay.Month.current {
            dayType = .currentMonth(isToday:  calendarDay.day == calendarHelper.getCurrentDay() && currentDate == calendarHelper.getCurrentMonth())
        } else {
            dayType = .nonCurrentMonth
        }
        cell.setupUI(day: calendarDay.day, data: dayType)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let calendarDay = totalDaysInMonth[indexPath.item].day
        let date = calendarHelper.dateFromDayMonthYear(day: calendarDay,
                                                       date: selectedDate)
        networkService.getEvents(date: date) { result in
            switch result {
            case .success(let events):
                DispatchQueue.main.async {
                    self.sheduleEvents = events
                    self.calendarTableView.reloadData()
                }
            case .failure(let error):
                print(error)
                self.createAlert(title: "Error",
                                 message: "Can not get your events list")
            }
        }
    }
}
//MARK: - extension CalendarViewController: UITableViewDelegate, UITableViewDataSource

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sheduleEvents?.data.isEmpty == true {
            return 1
        } else {
            return sheduleEvents?.data.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = calendarTableView.dequeueReusableCell(
            withIdentifier: CalendarTableViewCell.identifier,
            for: indexPath) as? CalendarTableViewCell else {return UITableViewCell()}
        
        var sheduleData: SheduleData?
        if let data = sheduleEvents?.data {
            sheduleData = data[indexPath.row]
        }
        cell.setupUI(data: sheduleData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        calendarTableView.deselectRow(at: indexPath, animated: true)
    }
}
