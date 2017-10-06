//
//  HighscoreTableViewCell.swift
//  Withstand to Space
//
//  Created by Андрей Бабий on 29.09.17.
//  Copyright © 2017 Андрей Бабий. All rights reserved.
//

import UIKit

class HighscoreTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
