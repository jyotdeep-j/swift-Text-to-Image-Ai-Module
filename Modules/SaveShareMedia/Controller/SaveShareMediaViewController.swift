//
//  SaveShareMediaViewController.swift
//  DreamAI
//
//  Created by Pritpal Singh on 09/11/22.
//

import UIKit
import AVFoundation
import SDWebImage
import Photos
import StoreKit
//import FBSDKShareKit

protocol SavedInMyProject: AnyObject {
    func savedInProject(isSaved:Bool)
}


class SaveShareMediaViewController: UIViewController {
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var resultImagesCollectionView: UICollectionView!
    
    @IBOutlet weak var resultImagesPageControl: CustomPageControl!

    @IBOutlet weak var shareMediaPopUpView: UIView!
    @IBOutlet weak var mediaContainerView: UIView!

    
    @IBOutlet weak var recreateContainerView: UIView!
    @IBOutlet weak var reCreateTitleBtn: UIButton!
    
    @IBOutlet weak var editPromptContainerView: UIView!
    
    @IBOutlet weak var editPromptTitleLabel: UILabel!
    @IBOutlet weak var promptTextLabel: UILabel!
    

    @IBOutlet weak var saveWithLogoTitleBtn: UIButton!
    
    @IBOutlet weak var shareTitleBtn: UIButton!

    
    public var saveShareMediaVM = SaveShareMediaViewModel()
    weak var savedDelegate : SavedInMyProject?
    private var socialMediaType: SocialMediaType!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        registerCell()
        setUpUIDesign()
        setUpFont()
        saveShareMediaVM.delegate = self
     
//      resultImagesPageControl.numberOfPages = saveShareMediaVM.numberOfItem
        showCustomReviewPopUp()
        setObservations()
        saveDataAndShowPopup()
    
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name:  Notification.Name.purchaseDoneNotificationName, object: nil)
    }

    private func setObservations() {
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseDone(_:)), name: Notification.Name.purchaseDoneNotificationName, object: nil)
    }
    
    
    //MARK:- SAVE ART IN DB
    
    private func saveDataAndShowPopup(){
        saveShareMediaVM.reloadPopView  = { val in
            let showFirsTime = Helper.bool(forKey: kUserDefault.showSavedPreview)
            if val && !showFirsTime{
                Helper.setBool(true, forKey: kUserDefault.showSavedPreview)
                let previewVC = SavedPreviewViewController.initiantiate(fromAppStoryboard: .Main)
                previewVC.modalPresentationStyle = .overCurrentContext
                self.present(previewVC, animated: true)
            }
        }
        saveShareMediaVM.saveStabilityDataInDraft()
    }
    
    //MARK:- PURCHASE DONE
    @objc func purchaseDone(_ notification: Notification) {
        if let isPurchased = notification.object as? Bool {
            if isPurchased {
               // Load all pending 6 images
                CustomLoader.sharedInstance.show()
                self.saveShareMediaVM.createTextToImageAICutProWithImage(unlockAllImages: true)
            }
        }
    }
    
    func setUpFont(){
        let fontSize15 = Font(.installed(.PadaukRegular), size: .standard(.h3)).instance
        
        let reCreateTitle = reCreateTitleBtn.currentTitle?.attributedTo(font: fontSize15, spacing: 0, color: UIColor.appColor(.appTextLightGray),alignment: .right)//.underline(1)
        reCreateTitleBtn.setAttributedTitle(reCreateTitle, for: .normal)
        
        let fontSize18 = Font(.installed(.PadaukBold), size: .standard(.h2)).instance

        let attString = saveWithLogoTitleBtn.currentTitle?.attributedTo(font: fontSize18, spacing: 0, color: .white,alignment: .center)//.underline(1)
        saveWithLogoTitleBtn.setAttributedTitle(attString, for: .normal)
        
        
        let editText = self.editPromptTitleLabel.text?.attributedTo(font: fontSize18, spacing: 0, color: UIColor.appColor(.appTextPlaceholder),alignment: .left)
        self.editPromptTitleLabel.attributedText = editText
        
        let fontRegular18 = Font(.installed(.PadaukRegular), size: .standard(.h2)).instance
        let promptText = self.saveShareMediaVM.promptText.attributedTo(font: fontRegular18, spacing: 0, color: UIColor.appColor(.appTextPlaceholder),alignment: .left,lineBrackMode: .byTruncatingTail)
        self.promptTextLabel.attributedText = promptText

    }
    
 
    func setUpUIDesign() {
//        reCreateTitleBtn.layer.cornerRadius = 2
        recreateContainerView.blurViewEffect(withAlpha: 0.7)
        recreateContainerView.border(width: 1, color: .startImageBorderColor).corner(cornerRadius: recreateContainerView.bounds.height/2)
        
        saveWithLogoTitleBtn.border(width: 1, color: .startImageBorderColor).corner(cornerRadius: saveWithLogoTitleBtn.bounds.height/2)
        editPromptContainerView.corner(cornerRadius: 15)
    }
  
    private func showCustomReviewPopUp(){
        let isCustomReviewDone = Helper.bool(forKey: kUserDefault.isReviewComplete)
        if !isCustomReviewDone && Helper.sharedInstance.shouldShowCustomReviewPopUp{
            Helper.dispatchMainAfter(time: .now() + 2) {
                SKStoreReviewController.requestReview()
                /*let reviewPopUpVC  = CustomReviewPopUpViewController.initiantiate(fromAppStoryboard: .Main)
                reviewPopUpVC.modalPresentationStyle = .overCurrentContext
                self.present(reviewPopUpVC, animated: true)*/
            }
        }
    }
    
    
    //MARK: Save Share button Actions
    
    @IBAction func fullViewAction(_ sender: UIButton) {
        let fullViewVC = FullMediaPreviewViewController.initiantiate(fromAppStoryboard: .Main)
        fullViewVC.delegate = self
        fullViewVC.fullMediaPreviewVM.stabilityResponseModel = self.saveShareMediaVM.stabilityResponseModel
        fullViewVC.fullMediaPreviewVM.stabilityAIData = self.saveShareMediaVM.stabilityAIData
        fullViewVC.fullMediaPreviewVM.currentAIStyle = self.saveShareMediaVM.currentAIStyle
        fullViewVC.modalPresentationStyle = .overCurrentContext
        self.present(fullViewVC, animated: true)
    }
    
    @IBAction func editPromptAction(_ sender: UIButton) {
        let createStyleVC = CreateStyleViewController.initiantiate(fromAppStoryboard: .Main)
        createStyleVC.aiArtGeneratorVM.createStyleType = .edit
        createStyleVC.delegate = self
        createStyleVC.aiArtGeneratorVM.stabilityAIData = self.saveShareMediaVM.stabilityAIData
//        self.navigationController?.pushViewController(createStyleVC, animated: true)
        createStyleVC.modalPresentationStyle = .fullScreen
        self.present(createStyleVC, animated: true)
    }
    
    @IBAction func dismissViewAction(_ sender: UIButton) {
        requestReview()
//        Helper.sharedInstance.updateCustomReviewPopUpSenario()
        self.savedDelegate?.savedInProject(isSaved: self.saveShareMediaVM.artSaved)
        self.dismiss(animated: true)
    }
    
    @IBAction func reCreateAIAction(_ sender: UIButton) {
        if Helper.sharedInstance.pendingCreditScore <= 0 && !StoreManager.shared.isPurchased{
            Helper.sharedInstance.openIAPSubscription()
            return
        }
        
        if StoreManager.shared.isPurchased {
            self.reCreateAI()
        } else{
            if Helper.sharedInstance.isAppFreeForSave{
                self.reCreateAI()
            }else{
                if Helper.sharedInstance.shouldWhyAdsPopUpShow{
                    openWhyAdsPopUpFirstTime()
                }else{
                    Helper.dispatchMain {
                        //                SwiftLoader.show(animated: true)
                        CustomLoader.sharedInstance.show()
                        Helper.dispatchBackground {
                            GoogleAdMobHandler.shared.loadAddWithComplition { isAddLoaded in
                                Helper.dispatchMain {
                                    if !isAddLoaded{
                                        //                                SwiftLoader.show(animated: true)
                                        CustomLoader.sharedInstance.show()
                                    }
                                    GoogleAdMobHandler.shared.showAds(isRecreate: true, onViewController: self) { [weak self](isAddRewarded) in
                                        if !isAddRewarded{
                                            self?.reCreateAI()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
   
    }
    
    private func openWhyAdsPopUpFirstTime(){
        let reviewPopUpVC  = CustomReviewPopUpViewController.initiantiate(fromAppStoryboard: .Main)
        reviewPopUpVC.modalPresentationStyle = .overCurrentContext
        reviewPopUpVC.whyAdsDelegate = self
        reviewPopUpVC.shouldShowReviewPopUpView = false
        self.present(reviewPopUpVC, animated: true)
    }
    
    private func reCreateAI(){
        Helper.dispatchMain {
            CustomLoader.sharedInstance.show()
            self.saveShareMediaVM.createTextToImageAICutProWithImage()

        }
    }
    
    @IBAction func saveWithLogo(_ sender: UIButton) {

        if let outputImage = addWaterMark(){
            postImageToInstagram(instaImage: outputImage)
        }
    }
    
    
    @IBAction func shareMediaAction(_ sender: UIButton) {
        
        if let outputImage = addWaterMark(){
            Helper().shareDataActivity(withImage: true, text: "",outputImage)
        }
    }
    
    private func addWaterMark() -> UIImage? {
        
        let index = Int(resultImagesCollectionView.contentOffset.x / resultImagesCollectionView.bounds.size.width)
        
        if let currentCell = resultImagesCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? AIStyleCollectionCell{
            if let resultImage = currentCell.styleImageView.image{
                debugPrint(resultImage)
                let resultView = UIView(frame: CGRect(origin: .zero, size: resultImage.size))
                let imageView = UIImageView(frame: resultView.bounds)
                imageView.image = resultImage
                imageView.contentMode = .scaleAspectFit
                resultView.addSubview(imageView)
                guard let screenCapture = resultView.takeScreenshot(size: resultView.bounds.size) else {return nil}
                return screenCapture
            }
        }
        return nil
    }
}

extension SaveShareMediaViewController: EditPromptDataDelegate{
    func reCreatePromptWithStabilityData(stabilityData: StabilityAiData, stabilityResponseModel: CutOutModel,aiStyle : AIStyle) {
        self.saveShareMediaVM.stabilityAIData = stabilityData
        self.saveShareMediaVM.currentAIStyle = aiStyle
        self.saveShareMediaVM.stabilityResponseModel = stabilityResponseModel
        self.resultImagesCollectionView.reloadData()
        let fontRegular18 = Font(.installed(.PadaukRegular), size: .standard(.h2)).instance
        let promptText = self.saveShareMediaVM.promptText.attributedTo(font: fontRegular18, spacing: 0, color: UIColor.appColor(.appTextPlaceholder),alignment: .left,lineBrackMode: .byTruncatingTail)
        self.promptTextLabel.attributedText = promptText
       
    }
}

extension SaveShareMediaViewController: AIArtGeneratorDelegate, WhyAdsInTheAppDelegate {
    func didGetStabilityResult(result: CutOutModel) {
        Helper.sharedInstance.claimedCreditScore()
        CustomLoader.sharedInstance.hide()
        Helper.dispatchMain {
            self.saveShareMediaVM.stabilityResponseModel = result
        //    self.saveShareMediaVM.isReCreated = true
            self.resultImagesCollectionView.reloadData()
//            self.resultImagesPageControl.numberOfPages = self.saveShareMediaVM.numberOfItem
            self.saveShareMediaVM.saveStabilityDataInDraft()
            self.showCustomReviewPopUp()
        }
    }
    
    func didTapOnRemoveAdButton() {
        Helper.sharedInstance.openIAPSubscription()
    }
        
    func didTapOnWatchAdButton() {
        self.reCreateAIAction(self.reCreateTitleBtn)
    }
    
    func didTapCancelButton() {
        
    }
    
    func didGetResultStabilityMemes(with url: String) {
        Helper.sharedInstance.claimedCreditScore()
        CustomLoader.sharedInstance.hide()
        Helper.dispatchMain {
            Helper.sharedInstance.updateFreeTrailCountForCreateText2Image()
            Helper.sharedInstance.imageCreationCountPerAppSession += 1
            self.showCustomReviewPopUp()
        }
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

extension SaveShareMediaViewController {
        
    
    //MARK: Methods
    func postImageToInstagram(instaImage: UIImage) {
        UIImageWriteToSavedPhotosAlbum(instaImage, self, #selector(saveImage(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func requestReview() {
       /* if !Helper.sharedInstance.shouldShowCustomReviewPopUp{
            SKStoreReviewController.requestReview()
        }*/
    }
    
    @objc func saveImage(_ instaImage: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            print(error ?? "")
            if let message = error?.localizedDescription{
                let ac = UIAlertController(title: "Save", message: message, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
            }
            return
        }
        self.showAlertWithAction(title: "Save", message: "Image successfully saved in gallery.") {[weak self] in
            Helper.dispatchMain {
                self?.requestReview()
            }
        }

    }
}


//MARK: Collection View Delegate and Data Sources
extension SaveShareMediaViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    private func registerCell(){
        resultImagesCollectionView.registerCollectionCell(identifier: AIStyleCollectionCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return  self.saveShareMediaVM.numberOfItem
        if self.saveShareMediaVM.numberOfItem == 0{
            return 0
        }else{
            let count = StoreManager.shared.alreadyPurchased ? self.saveShareMediaVM.numberOfItem : 8
            resultImagesPageControl.numberOfPages = count
            return count

        }
            
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cellA  = collectionView.dequeueReusableCell(withReuseIdentifier: AIStyleCollectionCell.identifier, for: indexPath) as! AIStyleCollectionCell
        /*if let stabilityData =  self.saveShareMediaVM.imageData(atIndex: indexPath.item){
            cellA.configureCell(withStabilityImage: stabilityData)
        }*/
        let index = indexPath.item % self.saveShareMediaVM.numberOfItem
        if let stabilityData =  self.saveShareMediaVM.imageData(atIndex: index){
            cellA.configureCellWithFullPreview(withStabilityImage: stabilityData)
            if indexPath.item > (self.saveShareMediaVM.numberOfItem-1) && !StoreManager.shared.alreadyPurchased{
                cellA.addBlurAndLockLabel()
            }
        }
        return cellA
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (!StoreManager.shared.alreadyPurchased && indexPath.item > (self.saveShareMediaVM.numberOfItem - 1)){
            Helper.sharedInstance.openIAPSubscription()
        }
       /* if (StoreManager.shared.alreadyPurchased) || (!StoreManager.shared.alreadyPurchased && indexPath.item < self.saveShareMediaVM.numberOfItem){
            saveShareMediaVM.didSelect(atIndex: indexPath.item)
        }else{
            Helper.sharedInstance.openIAPSubscription()
        }*/
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        let cellSize = CGSize(width: width, height: height)
        debugPrint("cellSize ",cellSize)
        return cellSize
        //return CGSize.init(width: collectionView.frame.size.width/4.3, height:collectionView.frame.size.height)
        
    }
}

extension SaveShareMediaViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        if resultImagesPageControl.currentPage != index{
           // debugPrint(#function, " Current Page ",index)
            resultImagesPageControl.currentPage = index

        }
    }
}

