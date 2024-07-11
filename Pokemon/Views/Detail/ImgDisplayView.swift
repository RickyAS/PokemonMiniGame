//
//  ImgDisplayView.swift
//  Pokemon
//
//  Created by Ricky Austin on 11/07/24.
//

import UIKit
import SDWebImage

class ImgDisplayView: UIViewController {
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var heightPortrait: NSLayoutConstraint!
    @IBOutlet weak var heightLandscape: NSLayoutConstraint!
    let image: String
    
    init(image: String) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imgUrl = URL(string: image) {
            imgCard.sd_setImage(with: imgUrl)
        } else {
            imgCard.image = nil
        }
        // background tap gesture to dismiss view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backTapped))
        viewBack.addGestureRecognizer(tapGesture)
        viewBack.isAccessibilityElement = true
        viewBack.accessibilityIdentifier = "viewBack"
    }
    
    @objc func backTapped(_ sender: UITapGestureRecognizer) {
        dismiss(animated: false)
    }
}
