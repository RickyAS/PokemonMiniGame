//
//  DetailView.swift
//  Pokemon
//
//  Created by Ricky Austin on 11/07/24.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class DetailView: UIViewController {
    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var viewLandscape: DetailDescSubView!
    @IBOutlet weak var tableMain: UITableView!
    @IBOutlet weak var btnMain: UIButton!
    
    var presenter: DetailPresenterProtocol!
    private let bag = DisposeBag()
    private let cellId = "DetailCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // change back button title
        let backItem = UIBarButtonItem()
        backItem.title = presenter.name
        backItem.tintColor = .white
        navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
    }
    
    private func setupViews() {
        // TableView
        tableMain.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        // Button
        let btnTitle = presenter.isCatch ? "Catch! (50% chance)" : "Release! (prime only)"
        btnMain.setTitle(btnTitle, for: .normal)
        btnMain.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        btnMain.layer.cornerRadius = 10
        
        // Image Card
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imgCardTapped))
        imgCard.addGestureRecognizer(tapGesture)
    }
    
    private func bindData() {
        // display activity logs when trying to capture or to release
        presenter.logs.bind(to: tableMain.rx.items(cellIdentifier: cellId, cellType: UITableViewCell.self)) { (ind, log, cell) in
            
            if #available(iOS 14.0, *) {
                var config = cell.defaultContentConfiguration()
                config.text = log
                config.textProperties.font = .systemFont(ofSize: 14)
                config.textProperties.color = .white
                cell.contentConfiguration = config
            } else {
                cell.textLabel?.text = log
                cell.textLabel?.font = .systemFont(ofSize: 14)
                cell.textLabel?.textColor = .white
                
            }
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
        }.disposed(by: bag)
        
        
        // display selected data
        presenter.entity.subscribe(onNext: { [unowned self] entity in
            guard let item = entity else { return }
            viewLandscape.configure(entity: item)
            imgCard.sd_setImage(with: URL(string: item.image))
        }).disposed(by: bag)
        
        // capture or release button
        btnMain.rx.tap.subscribe(onNext: { [unowned self] in
            presenter.insertActivityLog()
            let indexPath = IndexPath(row: presenter.logs.value.count - 1, section: 0)
            tableMain.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }).disposed(by: bag)
    }
    
    @objc func imgCardTapped(_ sender: UITapGestureRecognizer) {
        presenter.showCard()
    }
    
    deinit {
        print("DetailView released!!")
    }
    
}

