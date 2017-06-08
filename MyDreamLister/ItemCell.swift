//
//  ItemCell.swift
//  MyDreamLister
//
//  Created by Max Furman on 6/4/17.
//  Copyright © 2017 Max Furman. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!
    

    func configureCell(item : Item){
        name.text = item.name
        price.text = "$\(item.price)"
        details.text = item.details
        img.image = item.toImage?.image as? UIImage
    }

}
