//
//  TransactionDetailVC.swift
//  CashFlow Calcula
//
//  Created by Krishna Panchal on 02/12/23.
//

import UIKit

class TransactionDetailVC: UIViewController {
    
    var transaction: MOTransaction!
    
    // Outlet
    @IBOutlet weak var displayView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    // Action参数
    @IBAction func close(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure view
        view.backgroundColor = .none
        displayView.layer.cornerRadius = 10.0
        closeButton.backgroundColor = .none
        
        // initialize label values
        activityLabel.text = transaction.title
        dateLabel.text = transaction.date
        locationLabel.text = transaction.location
        moneyLabel.text = (transaction.type == 0 ? "＋": "ー") + "$\(transaction.amount)"
        detailLabel.text = transaction.detail
    
    }
    
}
