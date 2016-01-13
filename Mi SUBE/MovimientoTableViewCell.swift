//
//  MovimientoTableViewCell.swift
//  Mi SUBE
//
//  Created by Hernan Matias Coppola on 12/1/16.
//  Copyright © 2016 Hernan Matias Coppola. All rights reserved.
//

import UIKit

class MovimientoTableViewCell: UITableViewCell {

    
    //MARK: Properties
    @IBOutlet weak var labelFecha: UILabel!
    @IBOutlet weak var labelMonto: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
