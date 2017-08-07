//
//  BusinessCardTableViewController.swift
//  CardCart
//
//  Created by Jay Patel on 7/17/17.
//  Copyright © 2017 JP Apps. All rights reserved.
//

import UIKit

class BusinessCardTableViewController: UITableViewController {
    
    
    var businesscards = [BusinessCardData]() {
        didSet {
            tableView.reloadData()
        }
        
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let savedBusinessCards = CoreDataHelper.loadData(type: .BUSINESS_CARD) as? [BusinessCardData] {
            self.businesscards = savedBusinessCards
        }
        /*for businesscard in businesscards!{
            let newBusinessCard = BusinessCard()
            
            if let title = businesscard.title{
                newBusinessCard.title = title
            }
            else{
                newBusinessCard.title = "Insert Title Here"
            }
            //newBusinessCard.title = businesscard.title!
            
            if let info = businesscard.info{
                newBusinessCard.info = info
            }
            else{
                newBusinessCard.info = "No Data"
            }
            //newBusinessCard.info = businesscard.info!
            
            if let company = businesscard.company{
                newBusinessCard.company = company
            }else{
                newBusinessCard.company = "Enter Store Here"
            }
            //newBusinessCard.company = businesscard.company!
            
           guard let cardImage = businesscard.image,
            let image = UIImage.init(data: cardImage as Data) else { return }
            newBusinessCard.image = image
            
            //newBusinessCard.image = UIImage(Data: businesscard.image! as Data)

            self.businesscards.append(newBusinessCard)
        }*/

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return businesscards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessCardTableViewCell", for: indexPath) as! BusinessCardTableViewCell
        
    
        let row = indexPath.row
        
        
        let businesscard = businesscards[row]
        
        
        cell.bcItemTitleLabel.text = businesscard.title
        cell.bcItemCompanyLabel.text = businesscard.company
        
        
        //cell.bcItemModificationTimeLabel.text = businesscard.modificationTime.convertToString()
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            
            if identifier == "displayBusinessCard" {
                
                print("Table view cell tapped")
                
                let indexPath = tableView.indexPathForSelectedRow!
                
                let businesscard = businesscards[indexPath.row]
                
                let displayBusinessCardsViewController = segue.destination as! DisplayBusinessCardsViewController
                
                displayBusinessCardsViewController.businesscard = businesscard
                
            } else if identifier == "addBusinessCard" {
                print("+ button tapped")
            }
        }
    }
    
    @IBAction func unwindToBusinessCardsTableViewController(_ segue: UIStoryboardSegue) {
        
        // for now, simply defining the method is sufficient.
        // we'll add code later
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            CoreDataHelper.deleteAt(type: .BUSINESS_CARD, index: indexPath.row)

            
            businesscards.remove(at: indexPath.row)
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCardTableViewCell", for: indexPath) as! BusinessCardTableViewCell

        let row = indexPath.row
        
        
        let businesscard = businesscards[row]
        
        
        cell.bcItemTitleLabel.text = businesscard.title
        
        
        cell.bcItemModificationTimeLabel.text = businesscard.modificationTime.convertToString()


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
