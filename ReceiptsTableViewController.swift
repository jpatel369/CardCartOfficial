//
//  ReceiptsTableViewController.swift
//  CardCart
//
//  Created by Jay Patel on 7/17/17.
//  Copyright © 2017 JP Apps. All rights reserved.
//

import UIKit

class ReceiptsTableViewController: UITableViewController {
    
    var receipts = [ReceiptData]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var filteredReceipts = [ReceiptData]() {
        didSet {
            tableView.reloadData()
        }
    }

    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        
        tableView.tableHeaderView = searchController.searchBar

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if let savedReceipts = CoreDataHelper.loadData(type: .RECEIPT) as? [ReceiptData] {
            self.receipts = savedReceipts
        }
        /*for receipt in receipts!{
            let newReceipt = Receipt()
            

            if let title = receipt.title{
                newReceipt.title = title
            }
            else{
                newReceipt.title = "Insert Title Here"
            }
           //
            if let info = receipt.info{
                newReceipt.info = info
            }
            else{
                newReceipt.info = ""
            }
           //
            if let store = receipt.store{
                newReceipt.store = store
            }
            else{
                newReceipt.store = "Insert Store Here"
            }
            //
        
//            guard let receiptImage = newReceipt.image else { return }
//            newReceipt.image = receiptImage
            newReceipt.image = UIImage(data: receipt.image! as Data)
            self.receipts.append(newReceipt)
        }
*/
    }
    
    func filterTableForSearchText(searchText: String, scope: String = "All") {
        
        filteredReceipts = receipts.filter { receipts in
            
            return (receipts.title?.lowercased().contains(searchText.lowercased()))!
            
        }
        
        tableView.reloadData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && (searchController.searchBar.text?.characters.count)! > 0 {
            
            return filteredReceipts.count
            
        } else {
        
        return receipts.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let receipt: ReceiptData?
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "receiptsTableViewCell", for: indexPath) as! ReceiptsTableViewCell
        
        
        let row = indexPath.row
        
        if searchController.isActive && (searchController.searchBar.text?.characters.count)! > 0 {
            
            receipt = filteredReceipts[row]
            
        } else {
        
         receipt = receipts[row]
        }
        
        
        cell.rItemTitleLabel.text = receipt?.title
        cell.rItemStoreLabel.text = receipt?.store
        
        //cell.rItemModificationTimeLabel.text = receipt.modificationTime.convertToString()
        
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            
            if identifier == "displayReceipt" {
                print("Table view cell tapped")
                
                let indexPath = tableView.indexPathForSelectedRow!
                
                let receipt = receipts[indexPath.row]
                
                let displayReceiptsViewController = segue.destination as! DisplayReceiptsViewController
                
                if searchController.isActive && (searchController.searchBar.text?.characters.count)! > 0 {
                    
                    displayReceiptsViewController.receipt = filteredReceipts[indexPath.row]
                    
                } else {
                
                displayReceiptsViewController.receipt = receipts[indexPath.row]
                }
                
            } else if identifier == "addReceipt" {
                print("+ button tapped")
            }
        }
    }
    
    @IBAction func unwindToReceiptsTableViewController(_ segue: UIStoryboardSegue) {
        
        // for now, simply defining the method is sufficient.
        // we'll add code later
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            CoreDataHelper.deleteAt(type: .RECEIPT, index: indexPath.row)
            
            
            receipts.remove(at: indexPath.row)
        }
    }


    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptsTableViewCell", for: indexPath) as! ReceiptsTableViewCell

        let row = indexPath.row
        
        
        let receipt = receipts[row]
        
        
        cell.rItemTitleLabel.text = receipt.title
        cell.rItemStoreLabel.text = receipt.store
        
        
        cell.rItemModificationTimeLabel.text = receipt.modificationTime.convertToString()
        


        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ReceiptsTableViewController: UISearchResultsUpdating, UISearchBarDelegate, UITextFieldDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterTableForSearchText(searchText: searchController.searchBar.text!)
    }
    
}
