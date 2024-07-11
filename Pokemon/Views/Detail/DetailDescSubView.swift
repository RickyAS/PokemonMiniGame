//
//  DetailDescSubView.swift
//  Pokemon
//
//  Created by Ricky Austin on 11/07/24.
//

import Foundation
import UIKit

class DetailDescSubView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblStats: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("DetailDescSubView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func configure(entity: PokemonEntity) {
        lblName.text = entity.name
        lblType.text = "\(entity.type)"
        var stats = ""
        entity.hp.forEach {
            stats += "\($0),"
        }
        lblStats.text = "[\(stats)]"
    }
}
