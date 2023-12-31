//
//  NewPaymentVC.swift
//  CashFlow Calcula
//
//  Created by Krishna Panchal on 02/12/23.
//

import UIKit
import CoreData

class NewPaymentVC: UITableViewController, UITextFieldDelegate {
    
    var transaction: MOTransaction!
    
    // MARK: - Outlet Property
    @IBOutlet weak var titleTextField: UITextField! {
        didSet {
            
            titleTextField.becomeFirstResponder()
            titleTextField.delegate = self
        }
    }
    @IBOutlet weak var dateTextField: UITextField! {
        didSet {
            dateTextField.delegate = self
        }
    }
    @IBOutlet weak var amountTextField: UITextField! {
        didSet {
            amountTextField.delegate = self
        }
    }
    @IBOutlet weak var typeSegmentControl: UISegmentedControl!
    @IBOutlet weak var locationTextField: UITextField! {
        didSet {
            locationTextField.delegate = self
        }
    }
    @IBOutlet weak var detailTextField: UITextField! {
        didSet {
            detailTextField.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure tag for text fields
        titleTextField.tag = 1
        dateTextField.tag = 2
        amountTextField.tag = 3
        locationTextField.tag = 4
        detailTextField.tag = 5
        
        for textfield: UITextField in [titleTextField,dateTextField,amountTextField,locationTextField,detailTextField] {
            setUpShadow(textfield)
        }
        
        // configure navigatioin bar
        if let customFont = UIFont(name: "AvenirNext-Bold", size: 20.0) {
            navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: customFont
            ]
        }
        
        // get default value for date text field
        let date = getDate()
        dateTextField.text = "\(date[0])" + "/" + "\(date[1])" + "/" + "\(date[2])"
        
        // disable the seperator
        tableView.separatorStyle = .none
    }
    
    // MARK: - Table View Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Action Method
    
    @IBAction func close(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        
        // check whether title is empty
        if titleTextField.text == "" {
            // add alert controller
            let alertController = UIAlertController(title: "Oops", message: "Please enter a title~", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
            // check whether amount is valid
        else if Double(amountTextField.text!) == nil {
            let alertController = UIAlertController(title: "Oops", message: "Please enter a valid amount~", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
            // check whether date is valid
        else if check(for: dateTextField.text!) == false {
            let alertController = UIAlertController(title: "Oops", message: "Please enter a valid date~", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
            // pass check
        else {
            // create managed object
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                transaction = MOTransaction(context: appDelegate.persistentContainer.viewContext)
                
                transaction.title = titleTextField.text
                transaction.date = dateTextField.text
                transaction.amount = Double(amountTextField.text!)!
                transaction.type = Int32(typeSegmentControl.selectedSegmentIndex)
                transaction.isImportant = false
                
                if locationTextField.text == "" {
                    transaction.location = "Unknown location"
                }
                if detailTextField.text == "" {
                    transaction.detail = "None."
                }
                transaction.location = locationTextField.text
                transaction.detail = detailTextField.text
                
                appDelegate.saveContext()
            }
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Text Field Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
            
        }
        
        return true
    }
    
    func setUpShadow(_ boxes: UITextField) {
        boxes.layer.cornerRadius = 5
        boxes.layer.shadowColor = UIColor.lightGray.cgColor
        boxes.layer.shadowOffset = CGSize(width: 0, height: 5)
        boxes.layer.shadowOpacity = 0.3
        boxes.layer.shadowRadius = 4.0
        boxes.layer.masksToBounds = false
        boxes.layer.borderColor = UIColor.lightGray.cgColor
        boxes.layer.borderWidth = 0.21
    }
}
