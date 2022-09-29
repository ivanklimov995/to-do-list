//
//  MainTableViewController.swift
//  to do list
//
//  Created by Иван Климов on 29.09.2022.
//

import UIKit
import Realm

class MainTableViewController: UITableViewController {
    var notesArray = [Notes]()
    override func viewDidLoad() {
        super.viewDidLoad()
        testApprndArray()
        notesArray[3].isFavorites = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        cell.favoritesButton.tag = indexPath.row
        cell.notesLabel.text = notesArray[indexPath.row].text
        if notesArray[indexPath.row].isFavorites {
            cell.addFavorites()
        } else if notesArray[indexPath.row].isFavorites == false {
            cell.notFfavorites()
        }
        return cell
    }
    
    func testApprndArray (){
        notesArray.append(Notes(text: "1"))
        notesArray.append(Notes(text: "2"))
        notesArray.append(Notes(text: "3"))
        notesArray.append(Notes(text: "4"))
        notesArray.append(Notes(text: "5"))
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

    
 
    @IBAction func favoritesButton(_ sender: UIButton) {
        let indexNotes = sender.tag
        notesArray[indexNotes].isFavorites.toggle()
        tableView.reloadData()
    }
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "redactionNotes"{
            guard let indexPath = tableView.indexPathForSelectedRow else { return}
            let vc = segue.destination as! ViewController
            vc.text = notesArray[indexPath.row].text
        } else  if segue.identifier == "addNotes"{
            let vc = segue.destination as! ViewController
           
        }
    }
    
    
    @IBAction func unwingSegue( _ segue: UIStoryboardSegue) {
        guard let redactNotes = segue.source as? ViewController else {return}
        if redactNotes.textView.text != nil && redactNotes.textView.text != redactNotes.text {
            notesArray.append(Notes(text: redactNotes.textView.text!))
            tableView.reloadData()
        } else {
            print("text field == nil")
        }
        
    }

}
