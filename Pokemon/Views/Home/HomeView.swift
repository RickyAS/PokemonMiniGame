//
//  HomeView.swift
//  Pokemon
//
//  Created by Ricky Austin on 11/07/24.
//

import UIKit
import RxSwift
import RxCocoa

class HomeView: UIViewController {
    @IBOutlet weak var collectionMain: UICollectionView!
    @IBOutlet weak var controlMain: UISegmentedControl!
    
    var presenter: HomePresenterProtocol!
    private let bag = DisposeBag()
    private let cellId = "HomeCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter.retriveList(isReload: true)
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.changeSegment(ind: controlMain.selectedSegmentIndex)
        collectionMain.reloadData()
    }
    
    private func setupViews() {
        // CollectionView
        collectionMain.delegate = self
        collectionMain.register(UINib(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: cellId)
        
    }
    
    private func bindData() {
        controlMain.rx.selectedSegmentIndex.subscribe { [unowned self] ind in
            presenter.changeSegment(ind: ind)
        }.disposed(by: bag)
        
        // display data on collection
        presenter.entities
            .bind(to: collectionMain.rx
                .items(cellIdentifier: cellId, cellType: HomeCell.self)){ (ind, entity, cell) in
                    // access id for UITest
                    cell.isAccessibilityElement = true
                    cell.accessibilityIdentifier = "\(ind)"
                    cell.configure(entity: entity)
                }.disposed(by: bag)
        
        
        // append data when contents reach bottom
        collectionMain.rx
            .willDisplayCell
            .subscribe(onNext: { [unowned self] _,_ in
                
                let count = presenter.entities.value.count
                let indexPaths = collectionMain.indexPathsForVisibleItems.sorted()
                let lastIndexPath = indexPaths.last
                if let lastIndexPath = lastIndexPath, lastIndexPath.row > count - Int(0.8 * Double(count)) {
                    
                    if presenter.isCatch {
                        presenter.retriveList(isReload: false)
                    }
                }
            }).disposed(by: bag)
        
        
        // navigate when a cell's selected
        collectionMain.rx
            .modelSelected(PokemonEntity.self)
            .subscribe(onNext: { [unowned self] entity in
                presenter.openDetail(entity: entity)
            }).disposed(by: bag)
    }
}

extension HomeView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // more columns in landscape mode
        let isLandscape = collectionView.bounds.width > collectionView.bounds.height
        let size = isLandscape ? collectionView.bounds.height : collectionView.bounds.width
        let width = (size / 2 ) - 16
        return CGSize(width: width, height: width * 1.5)
    }
}
