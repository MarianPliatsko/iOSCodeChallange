//
//  CalendarCollectionViewCell.swift
//  iOSCodeChallange
//
//  Created by mac on 2023-03-25.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let identifier = "CalendarCollectionViewCell"
    
    //MARK: - Outlet
    
    @IBOutlet weak var dayDateLabel: UILabel!
    
    //MARK: - Nib life cicle
    
    override func prepareForReuse() {
        dayDateLabel.textColor = nil
        dayDateLabel.attributedText = nil
    }
    
    //MARK: - Methods
    
    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
    
    func setupUI(day:String, data: DayType) {
        dayDateLabel.font = UIFont.systemFont(ofSize: 14)
        dayDateLabel.text = day
        
        switch data {
        case .nonCurrentMonth:
            dayDateLabel.textColor = .lightGray
        case .currentMonth(isToday: false):
            dayDateLabel.textColor = .darkGray
        case .currentMonth(isToday: true):
            dayDateLabel.textColor = .darkText
            dayDateLabel.attributedText = dayDateLabel.text?.underLined
        }
    }
}
