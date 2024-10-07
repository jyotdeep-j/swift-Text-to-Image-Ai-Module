//
//  NumberOfImagesPopUpViewController.swift
//  DreamAI
//
//  Created by iApp on 28/12/22.
//

import UIKit

enum NumberOfOutputImages:CaseIterable{
    case one
    case two
    case four
    case eight
    
    func detail() -> (title: String, iconName: String, isPro: Bool){
        switch self {
        case .one:
            return (title: "1", iconName: "imageCount1", isPro: false)
        case .two:
            return (title: "2", iconName: "imageCount2", isPro: false)
        case .four:
            return (title: "4", iconName: "imageCount4", isPro: true)
        case .eight:
            return (title: "8", iconName: "imageCount8", isPro: true)
        }
    }
    
    init(number: Int) {
        switch number{
        case 1: self = NumberOfOutputImages.one
        case 2: self = NumberOfOutputImages.two
        case 4: self = NumberOfOutputImages.four
        case 8: self = NumberOfOutputImages.eight
        default: self = NumberOfOutputImages.one
        }
    }
    
}

protocol NumberOfImageCountDelegate: AnyObject{
    func didSelectNumberOfImagesForOutput(numberOfImage: NumberOfOutputImages)
    func didDismissPopUpView()
}

class NumberOfImagesPopUpViewController: UIViewController {

    weak var delegate: NumberOfImageCountDelegate?
    
    private let numberOfImages: [NumberOfOutputImages] = NumberOfOutputImages.allCases
    var currentNumberOfOutputImages: NumberOfOutputImages = .two
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberOfImagesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        self.preferredContentSize = CGSize(width: 316, height: 152)
        numberOfImagesCollectionView.reloadData()
        self.view.blurViewEffect(withAlpha: 1, cornerRadius: 15)
        setObservations()
        // Do any additional setup after loading the view.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name:  Notification.Name.purchaseDoneNotificationName, object: nil)
    }
    
    private func setObservations() {
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseDone(_:)), name: Notification.Name.purchaseDoneNotificationName, object: nil)
    }
    
    //MARK:- PURCHASE DONE
    @objc func purchaseDone(_ notification: Notification) {
        if let isPurchased = notification.object as? Bool {
            self.numberOfImagesCollectionView.reloadData()
        }
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.delegate?.didDismissPopUpView()
        self.dismiss(animated: true)
    }
}

//MARK: Collection View Delegate and Data Sources
extension NumberOfImagesPopUpViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    private func registerCell(){
        numberOfImagesCollectionView.registerCollectionCell(identifier: ImageNumberColleactionCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.numberOfImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cellA  = collectionView.dequeueReusableCell(withReuseIdentifier: ImageNumberColleactionCell.identifier, for: indexPath) as! ImageNumberColleactionCell
        cellA.configureCell(with: numberOfImages[indexPath.item],currentCount: self.currentNumberOfOutputImages)
        return cellA
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let numberOfImages = numberOfImages[indexPath.item]
        if numberOfImages.detail().isPro && !StoreManager.shared.isPurchased{
            switch numberOfImages {
            case .four,.eight:
                Helper.sharedInstance.openIAPSubscription()
                return
            default: break
            }
        }
        self.currentNumberOfOutputImages = numberOfImages
        delegate?.didSelectNumberOfImagesForOutput(numberOfImage: self.currentNumberOfOutputImages)
//        self.dismiss(animated: true)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width/4
        let cellSize = CGSize(width: collectionWidth, height: collectionWidth)
        debugPrint("cellSize ",cellSize)
        return cellSize
    }
    
    
   /* func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 14
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14
        
    }
    */
   /* func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        
    }*/
}
