//
//  CashFlowSheetVC.swift
//  CashFlow Calcula
//
//  Created by Krishna Panchal on 02/12/23.
//

import UIKit
import CoreData


class CashFlowSheetVC: UIViewController, NSFetchedResultsControllerDelegate {
    
    var expense: Double = 0.0
    var income: Double = 0.0
    
    var transactions: [MOTransaction] = []
    var fetchResultController: NSFetchedResultsController<MOTransaction>!
    
    // Outlet property
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var totalBalanceLabel: UILabel!
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var stackView1: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // load data from store
        let fetchRequest: NSFetchRequest<MOTransaction> = MOTransaction.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    transactions = fetchedObjects
                }
                updateLabelValues()
            } catch {
                print(error)
            }
        }
        
        // configure navigation bar
        navigationController?.navigationBar.shadowImage = UIImage()
        if let customFont = UIFont(name: "AvenirNext-Bold", size: 20.0) {
            self.navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: customFont
            ]
        }
        
        // configure table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = 70.0
    }
}

extension CashFlowSheetVC: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MoneyTransactionTableViewCell
        
        // configure the cell
        cell.activityLabel.text = transactions[indexPath.row].title
        cell.dateLabel.text = getFormattedDate(for: transactions[indexPath.row].date!)
        cell.moneyLabel.text = (transactions[indexPath.row].type == 0 ? "＋": "ー") + "$\(transactions[indexPath.row].amount)"
        cell.activityImageView.image = UIImage(named: transactions[indexPath.row].type
            == 0 ? "income" : "expense")
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // add delete action
        let deleteAction = UIContextualAction(style: UIContextualAction.Style.destructive, title: "") { (action, view, completion) in
            // delete one row
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                let itemToBeDeleted = self.fetchResultController.object(at: indexPath)
                context.delete(itemToBeDeleted)
                
                appDelegate.saveContext()
            }
            
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            
        case "showDetail":
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! TransactionDetailVC
                destinationController.transaction = transactions[indexPath.row]
            }
            
        default:
            break
        }
    }
    
}

extension CashFlowSheetVC {
    
    private func updateLabelValues() {
        income = 0.0
        expense = 0.0
        
        for transaction in transactions {
            switch transaction.type {
            case 0:
                income += transaction.amount
            case 1:
                expense += transaction.amount
            default:
                break
            }
        }
        let totalBalance = income - expense
        
        // update label values
        incomeLabel.text = (income == 0.0) ? "$0" : "$\(income)"
        expenseLabel.text = (expense == 0.0) ? "$0" : "$\(expense)"
        totalBalanceLabel.text = (totalBalance < 0) ? "ー$\(-totalBalance)" : "$\(totalBalance)"
    }
    
    // MARK: - Fetch Result Method
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            transactions = fetchedObjects as! [MOTransaction]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateLabelValues()
        tableView.endUpdates()
    }
    
}
