//
//  TableViewCell.swift
//  MemeMe v2
//
//  Created by Rodrigo Astorga on 06-04-16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {


    @IBOutlet weak var imageMeme: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
