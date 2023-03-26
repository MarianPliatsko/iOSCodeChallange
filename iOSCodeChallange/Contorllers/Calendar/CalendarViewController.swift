//
//  DetailViewController.swift
//  iOSCodeChallange
//
//  Created by mac on 2023-03-25.
//

import UIKit

final class CalendarViewController: UIViewController {
    
    //MARK: - Properties
    
    let selectedDate = Date()
    var totalDaysInMonth = [String]()
    
    //MARK: - Outlet
    
    @IBOutlet weak var monthAndYearLabel: UILabel!
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
    //MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource  = self
        
        calendarCollectionView.register(CalendarCollectionViewCell.nib(),
                                        forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
    }
    
    //MARK: - IBAction
    
    @IBAction func previousMonthBtnPressed(_ sender: UIButton) {
    }
    
    @IBAction func nextMonthBtnPressed(_ sender: UIButton) {
    }
    
    //MARK: - Methods
    
    func flowLayout() {
        
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
        cell.dayDateLabel.text = totalDaysInMonth[indexPath.item]
        
        return cell
    }
    
    
}
