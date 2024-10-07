//
//  FullMediaPreviewViewController.swift
//  DreamAI
//
//  Created by iApp on 04/01/23.
//

import UIKit

class FullMediaPreviewViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var previewFullImageCollectionView: UICollectionView!
    @IBOutlet weak var resultImagesCollectionView: UICollectionView!
    
    weak var delegate: AIArtGeneratorDelegate?

    public var fullMediaPreviewVM = FullMediaPreviewViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        fullMediaPreviewVM.delegate = self
        // Do any additional setup after loading the view.
        setObservations()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
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
            if isPurchased {
               // Load all pending 6 images
                CustomLoader.sharedInstance.show()
                self.fullMediaPreviewVM.createTextToImageAICutProWithImage()
                
            }
        }
    }
}

extension FullMediaPreviewViewController: AIArtGeneratorDelegate {
    
    func didGetStabilityResult(result: CutOutModel) {
        self.delegate?.didGetStabilityResult(result: result)
        Helper.sharedInstance.claimedCreditScore()
        CustomLoader.sharedInstance.hide()
        Helper.dispatchMain {
            self.resultImagesCollectionView.reloadData()
            self.previewFullImageCollectionView.reloadData()
        }
    }
    
    func didGetResultStabilityMemes(with url: String) {
        
    }
    
    func didDoneText2ImageResult(_ model: Text2ImageResultDataModel?, _ message: String?) {
        CustomLoader.sharedInstance.hide()
        Helper.dispatchMain {
            if let message = message {
                UIAlertController.alert(title: "Error", message: message, viewController: self)
            }
        }
    }
}

//MARK: Collection View Delegate and Data Sources
extension FullMediaPreviewViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    private func registerCell(){
        previewFullImageCollectionView.registerCollectionCell(identifier: AIStyleCollectionCell.identifier)

        resultImagesCollectionView.registerCollectionCell(identifier: AIStyleCollectionCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == previewFullImageCollectionView{
            return  self.fullMediaPreviewVM.numberOfItem
        }else{
            let count = StoreManager.shared.alreadyPurchased ? self.fullMediaPreviewVM.numberOfItem : 8
            return count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cellA  = collectionView.dequeueReusableCell(withReuseIdentifier: AIStyleCollectionCell.identifier, for: indexPath) as! AIStyleCollectionCell
        if collectionView == previewFullImageCollectionView{
            if let stabilityData =  self.fullMediaPreviewVM.imageData(atIndex: indexPath.item){
                cellA.configureCellWithFullPreview(withStabilityImage: stabilityData)
            }
        }else{
            let index = indexPath.item % self.fullMediaPreviewVM.numberOfItem
            if let stabilityData =  self.fullMediaPreviewVM.imageData(atIndex: index){
                cellA.configureCellWithFullPreview(withStabilityImage: stabilityData)
                if indexPath.item > (self.fullMediaPreviewVM.numberOfItem-1) && !StoreManager.shared.alreadyPurchased{
                    cellA.addBlurAndLockLabel()
                }
            }
            if indexPath.item == self.fullMediaPreviewVM.currentSelectedMedia{
                cellA.layer.borderWidth = 1
                cellA.layer.borderColor = UIColor.appColor(.appBlueColor)?.cgColor
            }else{
                cellA.layer.borderWidth = 0
                cellA.layer.borderColor = UIColor.clear.cgColor
            }
        }
        return cellA
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == resultImagesCollectionView{
            
            if (StoreManager.shared.alreadyPurchased) || (!StoreManager.shared.alreadyPurchased && indexPath.item < self.fullMediaPreviewVM.numberOfItem){
                previewFullImageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                fullMediaPreviewVM.didSelect(atIndex: indexPath.item)
                self.resultImagesCollectionView.reloadData()
            }else{
                Helper.sharedInstance.openIAPSubscription()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == resultImagesCollectionView{
            let width = (collectionView.bounds.width - 70) / 4
//            let height = collectionView.bounds.height
            let cellSize = CGSize(width: width, height: width)
            debugPrint("cellSize ",cellSize)
            return cellSize
        }else{
            let width = collectionView.bounds.width
            let height = collectionView.bounds.height
            let cellSize = CGSize(width: width, height: height)
            debugPrint("cellSize ",cellSize)
            return cellSize
        }
        
        //return CGSize.init(width: collectionView.frame.size.width/4.3, height:collectionView.frame.size.height)
        
    }
}
