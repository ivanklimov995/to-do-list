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
    
    //MARK: все для показа избранных заметок
    @IBOutlet weak var favoritesOutlet: UIBarButtonItem!
    var isShowFavorites = false
    var favoritesArray: [Notes] = []
    var arrayForShow = [Notes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testApprndArray()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isShowFavorites{
            return favoritesArray.count
        }else{
            return notesArray.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        if isShowFavorites{
                arrayForShow = favoritesArray
            }else{
                arrayForShow = notesArray
        }
        
            if arrayForShow[indexPath.row].isFavorites {
                cell.addFavorites()
            } else {
                cell.notFfavorites()
            }
        
        cell.favoritesButton.tag = indexPath.row
        cell.notesLabel.text = arrayForShow[indexPath.row].text
        
        return cell
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
        arrayForShow[indexNotes].isFavorites.toggle()
        tableView.reloadData()
    }
    
    @IBAction func buttonFavoritesAction(_ sender: UIBarButtonItem) {
        isShowFavorites.toggle()
        if isShowFavorites {
            for notes in notesArray {
                if notes.isFavorites {
                    favoritesArray.append(notes)
                }
            }
            if favoritesArray.isEmpty{
                let alert = UIAlertController(title: "Нет избранных заметок", message: nil, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Закрыть", style: .cancel)
                alert.addAction(cancel)
                present(alert, animated: true)
                isShowFavorites.toggle()
                favoritesOutlet.title = "Показать избранное"
                favoritesOutlet.tintColor = UIColor.blue
                tableView.reloadData()
            }else{
                favoritesOutlet.title = "Избранное"
                favoritesOutlet.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            }
        } else{
            favoritesOutlet.title = "Показать избранное"
            favoritesOutlet.tintColor = UIColor.blue
            favoritesArray.removeAll()
        }
        tableView.reloadData()
    }
    
    
          
        
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "redactionNotes"{
            guard let index = tableView.indexPathForSelectedRow else { return}
            let vc = segue.destination as! ViewController
            vc.addNotes = false
            vc.index = index.row
            vc.text = notesArray[index.row].text
        } else  if segue.identifier == "addNotes"{
            let vc = segue.destination as! ViewController
            vc.addNotes = true
        }
    }
    
    
    @IBAction func unwingSegue( _ segue: UIStoryboardSegue) {
        guard let newNotes = segue.source as? ViewController else {return}
            if newNotes.textView.text != nil && newNotes.textView.text != newNotes.text {
                if newNotes.addNotes{
                    notesArray.append(Notes(text: newNotes.textView.text!))
                }else{
                    
                    //фикс форс анрап
                    notesArray[newNotes.index!].text = newNotes.textView.text!
                }
                
            } else {
                print("text field == nil")
            }
//
//
//
//
//
//                if newNotes.addNotes{
//                    if newNotes.textView.text != nil && newNotes.textView.text != newNotes.text {
//                        notesArray.append(Notes(text: newNotes.textView.text!))
//                    } else {
//                        print("text field == nil")
//                    }
//                }else{
//                    if newNotes
//                }
        tableView.reloadData()
    }

    //MARK: тест залупа пока нет рабочего рилма
    func testApprndArray (){
        notesArray.append(Notes(text: "1"))
        notesArray.append(Notes(text: "2"))
        notesArray.append(Notes(text: "3"))
        notesArray.append(Notes(text: "4"))
        notesArray.append(Notes(text: "5"))
        notesArray.append(Notes(text: "51фвафафафаьтыжпатофпотловтпаотывпотвптваптвылаптвыльптыбвьптбывтпыпывьпт"))
        notesArray[3].isFavorites = true
    }
}
