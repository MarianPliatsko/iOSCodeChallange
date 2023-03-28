//
//  CalendarTableViewCell.swift
//  iOSCodeChallange
//
//  Created by mac on 2023-03-26.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "CalendarTableViewCell"
    
    //MARK: - Outlet
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    //MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
    }
    
    //MARK: - Methods

    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
    
    func setupUI(data: SheduleData) {
        titleLabel.text = data.courseName
        detailLabel.text = data.room
        timeLabel.text = "\(data.startTime) - \(data.emdTime)"
    }
    
}
