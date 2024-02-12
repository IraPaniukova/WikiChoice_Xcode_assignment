//
//  ShowAllTableViewCell.swift
//  WikiChoice
//
//  Created by Ira Paniukova on 10/21/23.
//

import UIKit

class ShowAllTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.orange.cgColor
        layer.borderWidth = 0.3
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var ImgLabel: UIImageView!
    
 
}
