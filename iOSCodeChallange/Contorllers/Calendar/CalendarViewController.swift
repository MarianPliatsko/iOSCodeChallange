//
//  DetailViewController.swift
//  iOSCodeChallange
//
//  Created by mac on 2023-03-25.
//

import UIKit

final class CalendarViewController: UIViewController {
    
    //MARK: - Properties
    
    let networkService = StubNetworkService()
    var selectedDate = Date()
    var totalDaysInMonth = [CalendarDay]()
    var sheduleEvents = Shedule()
    
    //MARK: - Outlet
    
    @IBOutlet weak var monthAndYearLabel: UILabel!
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var calendarTableView: UITableView!
    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource  = self
        calendarCollectionView.collectionViewLayout = flowLayout()
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
        selectedDate = CalendarHelper().minusMonth(date: selectedDate)
        setMonth()
    }
    
    @IBAction func nextMonthBtnPressed(_ sender: UIButton) {
        selectedDate = CalendarHelper().plusMonth(date: selectedDate)
        setMonth()
    }
    
    //MARK: - Methods
    
    //setup layout for collection view
    func flowLayout() -> UICollectionViewFlowLayout {
        let width = (calendarCollectionView.frame.size.width - 2) / 8
        let height = (calendarCollectionView.frame.size.height - 2) / 8
        
        let flowLayout = calendarCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
        
        return flowLayout
    }
    
    //setup calendar
    func setMonth() {
        totalDaysInMonth.removeAll()
        let daysInMonth = CalendarHelper().daysInMonth(date: selectedDate)
        let firstDayOfMonth = CalendarHelper().firstOfMonth(date: selectedDate)
        let startingSpaces = CalendarHelper().weekDay(date: firstDayOfMonth)
        
        let previousMonth = CalendarHelper().minusMonth(date: selectedDate)
        let daysInPreviousMonth = CalendarHelper().daysInMonth(date: previousMonth)
        
        var count = 1
        
        while count <= 42 {
            let calendarDay = CalendarDay()
            if count <= startingSpaces {
                let previosMonthDay = daysInPreviousMonth - startingSpaces + count
                calendarDay.day = String(previosMonthDay)
                calendarDay.month = CalendarDay.Month.previous
            } else if count - startingSpaces > daysInMonth {
                calendarDay.day = String(count - daysInMonth - startingSpaces)
                calendarDay.month = CalendarDay.Month.next
            } else {
                calendarDay.day =  String(count - startingSpaces)
                calendarDay.month = CalendarDay.Month.current
            }
            totalDaysInMonth.append(calendarDay)
            count += 1
        }
        monthAndYearLabel.text = CalendarHelper().monthToString(date: selectedDate) + " " + CalendarHelper().yearToString(date: selectedDate)
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
        cell.dayDateLabel.font = UIFont.systemFont(ofSize: 14)
        cell.dayDateLabel.text = calendarDay.day
        
        let currentDate = CalendarHelper().monthToString(date: selectedDate)
        if calendarDay.month == CalendarDay.Month.current {
            if calendarDay.day == CalendarHelper().getCurrentDay() &&
                currentDate == CalendarHelper().getCurrentMonth() {
                cell.dayDateLabel.textColor = UIColor.darkText
                cell.dayDateLabel.font = UIFont.boldSystemFont(ofSize: 14)
                cell.dayDateLabel.attributedText = cell.dayDateLabel.text?.underLined
            }
            cell.dayDateLabel.textColor = UIColor.darkGray
        } else {
            cell.dayDateLabel.font = UIFont.systemFont(ofSize: 14)
            cell.dayDateLabel.textColor = UIColor.lightGray
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let calendarDay = totalDaysInMonth[indexPath.item].day else {
            print("Failure to set calendar day")
            return
        }
        let year = CalendarHelper().yearToString(date: selectedDate)
        let month = CalendarHelper().monthToStringNumber(date: selectedDate)
        let isoDate = "\(year)-\(month)-\(calendarDay)T10:44:00+0000"
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from:isoDate) ?? Date()
        
        networkService.getEvents(date: date) { result in
            switch result {
            case .success(let events):
                DispatchQueue.main.async {
                    self.sheduleEvents = events
                    self.calendarTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
//MARK: - extension CalendarViewController: UITableViewDelegate, UITableViewDataSource

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sheduleEvents.data.isEmpty {
            return 1
        } else {
            return sheduleEvents.data.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = calendarTableView.dequeueReusableCell(
            withIdentifier: CalendarTableViewCell.identifier,
            for: indexPath) as? CalendarTableViewCell else {return UITableViewCell()}
        if sheduleEvents.data.isEmpty {
            cell.titleLabel.text = "There is no event"
            cell.detailLabel.text = ""
            cell.timeLabel.text = ""
        } else {
            cell.setupUI(data: sheduleEvents.data[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        calendarTableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
