//
//  FilmeTableViewCell.swift
//  Cinema
//
//  Created by Evosystems on 26/02/18.
//  Copyright © 2018 Evosystems. All rights reserved.
//

import UIKit

class FilmeTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var filmeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
