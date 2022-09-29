//
//  ViewController.swift
//  to do list
//
//  Created by Иван Климов on 29.09.2022.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var textView: UITextView!
    var text = "Введите заметку"
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
}
