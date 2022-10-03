//
//  ViewController.swift
//  to do list
//
//  Created by Иван Климов on 29.09.2022.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var favoritesOutlet: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!
    
    var isFavorites = false
    var text = "Введите заметку"
    var addNotes = true
    var index: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        textView.text = text
        if text == "Введите заметку"{
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    @IBAction func favoritesButton(_ sender: UIBarButtonItem) {
        isFavorites.toggle()
        if isFavorites {
            favoritesOutlet.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }else {
            favoritesOutlet.tintColor = UIColor.blue
        }
    }
    
}
