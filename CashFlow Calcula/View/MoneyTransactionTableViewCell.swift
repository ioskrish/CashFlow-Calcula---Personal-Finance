//
//  MoneyTransactionTableViewCell.swift
//  CashFlow Calcula
//
//  Created by Krishna Panchal on 02/12/23.
//

import UIKit

class MoneyTransactionTableViewCell: UITableViewCell {
    
    // Outlet properties
    @IBOutlet weak var activityImageView: UIImageView!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
   

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
