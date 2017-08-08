//
//  MapTableViewCell.swift
//  rssi
//
//  Created by Dan Morton on 8/8/17.
//  Copyright © 2017 Intelligent Locations. All rights reserved.
//

import UIKit

class MapTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var numberOfGatewaysLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
