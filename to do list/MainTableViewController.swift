//
//  MainTableViewController.swift
//  to do list
//
//  Created by Иван Климов on 29.09.2022.
//

import UIKit
import RealmSwift

class MainTableViewController: UITableViewController {
    
    var notesArray: Results<Notes>!
    
    //MARK: все для показа избранных заметок
    @IBOutlet weak var favoritesOutlet: UIBarButtonItem!
    var isShowFavorites = false
    var favoritesArray: Results<Notes>!
    var arrayForShow: Results<Notes>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesArray = realm.objects(Notes.self)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isShowFavorites{
            return favoritesArray.count
        }else{
            return notesArray.isEmpty ? 0 : notesArray.count
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
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let notes = notesArray[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (_, _) in
            let alert = UIAlertController(title: "Удалить?", message: nil, preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            let yes = UIAlertAction(title: "Удалить", style: .destructive) { yes in
                StoragemManager.deleteObgect(notes)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
                                            
            alert.addAction(cancel)
            alert.addAction(yes)
            
            self.present(alert, animated: true)
        }
        return [deleteAction]
    }

    
 
    @IBAction func favoritesButton(_ sender: UIButton) {
        let indexNotes = sender.tag
        try! realm.write({
            self.arrayForShow[indexNotes].isFavorites.toggle()
            self.tableView.reloadData()
        })
        tableView.reloadData()
    }
    
    @IBAction func buttonFavoritesAction(_ sender: UIBarButtonItem) {
        isShowFavorites.toggle()
        if isShowFavorites {
            favoritesArray = notesArray.where { $0.isFavorites == true}
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
                    DispatchQueue.main.async {
                        StoragemManager.saveObject(Notes(text: newNotes.textView.text!))
                        self.tableView.reloadData() // нужен именно тут - чтобы обновил таблицу после записи и отобразилась новая заметка
                    }
                }else{
                    if newNotes.index != nil {
                        DispatchQueue.main.async {
                            try! realm.write({
                                self.notesArray[newNotes.index!].text = newNotes.textView.text!
                                self.tableView.reloadData()
                            })
                        }
                     } else {
                        print("newNotes.index == nil")
                    }
                }
            } else {
                print("text field == nil")
            }
    }
}
