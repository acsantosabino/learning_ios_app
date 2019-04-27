//
//  BookTableViewCell.swift
//  Leiturama
//
//  Created by Danillo Oliveira on 27/04/19.
//  Copyright © 2019 Arthur Santos. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    
    func setBookInfo(image: UIImage, titulo: String){
        self.bookImage.image = image
        self.bookTitle.text = titulo
    }

}
