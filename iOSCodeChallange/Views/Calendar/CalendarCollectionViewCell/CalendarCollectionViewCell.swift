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
        dayDateLabel.attributedText = nil
    }
    
    //MARK: - Methods
    
    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }

}
