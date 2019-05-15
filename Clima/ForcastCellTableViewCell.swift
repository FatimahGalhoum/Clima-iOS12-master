//
//  ForcastCellTableViewCell.swift
//  Clima
//
//  Created by Fatimah Galhoum on 5/15/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit

class ForcastCellTableViewCell: UITableViewCell {

    
    //outlets
    @IBOutlet weak var forcastTemp: UILabel!
    @IBOutlet weak var forcastDay: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var forcastTempMax: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
