//
//  CustomCell.swift
//  to do list
//
//  Created by Иван Климов on 29.09.2022.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var notesLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        favoritesButton.setImage(UIImage(named: "star.fill"), for: .normal)
    }
    func addFavorites (){
        favoritesButton.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
    }
    func notFfavorites(){
        favoritesButton.tintColor = UIColor.blue
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
