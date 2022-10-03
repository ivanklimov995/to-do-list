//
//  MainTableViewController.swift
//  to do list
//
//  Created by Иван Климов on 29.09.2022.
//

import UIKit
import RealmSwift

class MainTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var notesArray: Results<Notes>!
    var arrayForShow: Results<Notes>!
    
    //MARK: все для показа избранных заметок
    @IBOutlet weak var favoritesOutlet: UIBarButtonItem!
    var isShowFavorites = false
    var favoritesArray: Results<Notes>!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesArray = realm.objects(Notes.self)
        searshController.searchResultsUpdater = self
        searshController.obscuresBackgroundDuringPresentation = false
        searshController.searchBar.placeholder = "Поиск"
        tableView.tableHeaderView = searshController.searchBar // интеграция строки поиска в тейбл вью
        definesPresentationContext = true  // отпустить сроку поиска при переходе на другой экран
        setupVariantSorting(ascendingSorting: ascendingSorting)
    }

    
    
    //MARK: search bar
    private let searshController = UISearchController(searchResultsController: nil)
    private var filtredNotes: Results<Notes>!
    private var searchBarIsEmpty: Bool {
        guard let text = searshController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool{
        return searshController.isActive && !searchBarIsEmpty
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if !notesArray.isEmpty{
            filtredNotes = arrayForShow.filter("text CONTAINS[cd] %@", searchController.searchBar.text!)
            tableView.reloadData()
        }else {
            searchController.searchBar.placeholder = "Нет заметок"
            return
        }
    }

    //MARK: sorted

    @IBOutlet weak var variandSortedOutlet: UIButton!
    private var ascendingSorting = true // cорт по возрастанию
    private func setupVariantSorting(ascendingSorting: Bool){
        if ascendingSorting {
            variandSortedOutlet.setTitle("↑", for: .normal)
        } else {
            variandSortedOutlet.setTitle("↓", for: .normal)
        }
    }
    private var isSorted = false
    private var sortedArray: Results<Notes>!
    private var keyForSearch = "text"
    
    @IBAction func variandSortedAction(_ sender: UIButton) {
        ascendingSorting.toggle()
        setupVariantSorting(ascendingSorting: ascendingSorting)
        sorting(byKeyPath: keyForSearch)
        self.tableView.reloadData()
    }
    
    private func sorting(byKeyPath: String){
        self.notesArray =  self.notesArray.sorted(byKeyPath: byKeyPath, ascending: self.ascendingSorting)
        self.tableView.reloadData()
    }
    
    @IBAction func sortedButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Сортировать", message: nil, preferredStyle: .actionSheet)
        let byName = UIAlertAction(title: "По имени", style: .default) { [self] _ in
            sorting(byKeyPath: "text")
            keyForSearch = "text"
      }
                              
        let byDate = UIAlertAction(title: "По дате", style: .default) { [self] _ in
            sorting(byKeyPath: "date")
            keyForSearch = "date"
        }
        let cancel = UIAlertAction(title: "Отмена", style: .destructive)
        alert.addAction(byName)
        alert.addAction(byDate)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isShowFavorites{
            if isFiltering {
                return filtredNotes.count
            }else {
                return favoritesArray.count
            }
        }else{
            if isFiltering {
                return filtredNotes.count
            }else {
                return notesArray.isEmpty ? 0 : notesArray.count
            }
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        if isShowFavorites{
            if isFiltering{
                arrayForShow = filtredNotes
            } else{
                arrayForShow = favoritesArray
            }
        }else{
            if isFiltering{
                arrayForShow = filtredNotes
            } else{
                arrayForShow = notesArray
            }
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
                tableView.deleteRows(at: [indexPath], with: .top)
                tableView.reloadData()
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
                favoritesOutlet.title = "Показать избранные"
                favoritesOutlet.tintColor = UIColor.blue
                tableView.reloadData()
            }else{
                favoritesOutlet.title = "Показать все"
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
                        let note = Notes(text: newNotes.textView.text!)
                        note.isFavorites = newNotes.isFavorites
                        StoragemManager.saveObject(note)
                        self.tableView.reloadData() // нужен именно тут - чтобы обновил таблицу после записи и отобразилась новая заметка
                    }
                }else{
                    if newNotes.index != nil {
                        DispatchQueue.main.async {
                            try! realm.write({
                                self.notesArray[newNotes.index!].text = newNotes.textView.text!
                                self.notesArray[newNotes.index!].isFavorites = newNotes.isFavorites
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
