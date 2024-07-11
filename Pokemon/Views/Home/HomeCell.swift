//
//  HomeCell.swift
//  Pokemon
//
//  Created by Ricky Austin on 11/07/24.
//

import UIKit
import SDWebImage

class HomeCell: UICollectionViewCell {
    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var lblCard: UILabel!
    
    func configure(entity: PokemonEntity) {
        if let imgUrl = URL(string: entity.image) {
            imgCard.sd_setImage(with: imgUrl)
        } else {
            imgCard.image = nil
        }
        lblCard.text = entity.name
    }
}
