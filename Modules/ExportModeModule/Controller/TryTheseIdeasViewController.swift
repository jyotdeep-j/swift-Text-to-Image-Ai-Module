//
//  TryTheseIdeasViewController.swift
//  DreamAI
//
//  Created by iApp on 10/01/23.
//

import UIKit

protocol DeletedDraftModel: AnyObject{
    func deletedDraftModel(promptStabilityData:PromptStabilityData,isDeleted:Bool)
}

class TryTheseIdeasViewController: BaseViewController {

    weak var delegate: SuggestedStyleDelegate?
    weak var draftDelegate: DeletedDraftModel?


    @IBOutlet weak var backgroundTintView: UIView!
    
    @IBOutlet weak var promptDetailScrollView: UIScrollView!
    @IBOutlet weak var fullImageContainerView: UIView!
    @IBOutlet weak var fullImagePreviewConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var fullPreviewCollectionView: UICollectionView!
    
    @IBOutlet weak var imageListCollectionView: UICollectionView!
    
    @IBOutlet weak var promtTextLabel: UILabel!
    
    @IBOutlet weak var copyPromptContainerView: UIView!
    @IBOutlet weak var copyPromptButton: UIButton!
    @IBOutlet weak var copiedPromptButton: UIButton!
    
    @IBOutlet weak var deleteImageButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var usePromptContainerView: UIView!
    @IBOutlet weak var usePromptButton: UIButton!
    
    @IBOutlet weak var aiEngineTitleLabel: UILabel!
    @IBOutlet weak var aiEngineLabel: UILabel!
    
    @IBOutlet weak var cfgScaleTitleLabel: UILabel!
    @IBOutlet weak var cfgScaleLabel: UILabel!
    
    @IBOutlet weak var dimensionTitleLabel: UILabel!
    @IBOutlet weak var dimensionsLabel: UILabel!
    
    @IBOutlet weak var seedTitleLabel: UILabel!
    @IBOutlet weak var seedValueLabel: UILabel!
    
    @IBOutlet weak var stepsTitleLabel: UILabel!
    @IBOutlet weak var stepsValueLabel: UILabel!
    
    @IBOutlet weak var samplerTitleLabel: UILabel!
    @IBOutlet weak var samplerValueLabel: UILabel!
    
//    var promptIdeaAiArt: AIArtDataModel.PromptIdeasForAIArt?
    
//    private let stabilityDataModel = StabilityAiData()
    
    
    private var currentImageIndex: Int = 0
    
    public var promptStabilityData: PromptStabilityData?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerCell()
        uiDesignSetup()
        setUIFont()
        
        guard let promptStabilityData = self.promptStabilityData else {return}
        let ratio = CGFloat(promptStabilityData.width)/CGFloat(promptStabilityData.height)
        if ratio != 0{
            let newHeight = self.fullPreviewCollectionView.bounds.width/ratio
            debugPrint("newHeight ",newHeight)
            self.fullImagePreviewConstraintHeight.constant = newHeight
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0,options: .curveEaseInOut) {
            self.backgroundTintView.alpha = 0.5
        }
        self.promptDetailScrollView.contentOffset = CGPoint(x: 0, y: -900)
        
        UIView.animate(withDuration: 0.5, delay: 0,options: .curveEaseInOut) {
            self.promptDetailScrollView.contentOffset = CGPoint(x: 0, y: 0)
        } completion: { isCompleted in
            self.promptDetailScrollView.backgroundColor = UIColor.appColor(.appBackground)
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        fullImageContainerView.roundCorners([.topRight,.topLeft], radius: 20)
        if self.promptStabilityData?.isDraft ?? false{
            self.deleteImageButton.isHidden = false
        }
    }
    
    private func uiDesignSetup(){
        
        copyPromptContainerView.blurViewEffect(withAlpha: 0.7, cornerRadius: copyPromptContainerView.bounds.height/2)
        copyPromptContainerView.border(width: 1, color: .startImageBorderColor).corner(cornerRadius: copyPromptContainerView.bounds.height/2)
        copiedPromptButton.blurViewEffect(withAlpha: 1.0, cornerRadius: copyPromptContainerView.bounds.height/2)
        shareButton.border(width: 1, color: .startImageBorderColor).corner(cornerRadius: shareButton.bounds.height/2)
        usePromptContainerView.border(width: 1, color: .appBlueColor).corner(cornerRadius: usePromptContainerView.bounds.height/2)
        usePromptContainerView.backgroundColor = UIColor.appColor(.appBlueColor)?.withAlphaComponent(0.5)
    }
    
    private func setUIFont() {
        let fontSize18 = Font(.installed(.PadaukRegular), size: .standard(.h2)).instance
        
        let copyPrompt = copyPromptButton.currentTitle?.attributedTo(font: fontSize18, spacing: 0,lineSpacing: 0, color: .white)
        copyPromptButton.setAttributedTitle(copyPrompt, for: .normal)
        
        let copiedPrompt = copiedPromptButton.currentTitle?.attributedTo(font: fontSize18, spacing: 0,lineSpacing: 0, color: .white)
        copiedPromptButton.setAttributedTitle(copiedPrompt, for: .normal)
        
        let usePrompt = usePromptButton.currentTitle?.attributedTo(font: fontSize18, spacing: 0,lineSpacing: 0, color: .white)
        usePromptButton.setAttributedTitle(usePrompt, for: .normal)
        
        let fontSize16 = Font(.installed(.PadaukRegular), size: .standard(.h3)).instance
        
        aiEngineTitleLabel.attributedText = aiEngineTitleLabel.text?.attributedTo(font: fontSize16, color: UIColor.appColor(.appTextPlaceholder))
        cfgScaleTitleLabel.attributedText = cfgScaleTitleLabel.text?.attributedTo(font: fontSize16, color: UIColor.appColor(.appTextPlaceholder))
        dimensionTitleLabel.attributedText = dimensionTitleLabel.text?.attributedTo(font: fontSize16, color: UIColor.appColor(.appTextPlaceholder))
        seedTitleLabel.attributedText = seedTitleLabel.text?.attributedTo(font: fontSize16, color: UIColor.appColor(.appTextPlaceholder))
        stepsTitleLabel.attributedText = stepsTitleLabel.text?.attributedTo(font: fontSize16, color: UIColor.appColor(.appTextPlaceholder))
        samplerTitleLabel.attributedText = samplerTitleLabel.text?.attributedTo(font: fontSize16, color: UIColor.appColor(.appTextPlaceholder))
        
        guard let promptStabilityData = self.promptStabilityData else {return}
        
        let prompt = promptStabilityData.propmt
        let titleTextAttri = prompt?.attributedTo(font: fontSize18, spacing: 0,lineSpacing: -10, color: UIColor.appColor(.appTextPlaceholder))
        promtTextLabel.attributedText = titleTextAttri
        
        
        aiEngineLabel.attributedText = promptStabilityData.egine.attributedTo(font: fontSize16, color: UIColor.appColor(.appTextLightGray))
        cfgScaleLabel.attributedText = "\(promptStabilityData.cfgScale)".attributedTo(font: fontSize16, color: UIColor.appColor(.appTextLightGray))

        let dimension = "\(promptStabilityData.width)x\(promptStabilityData.height)"
        dimensionsLabel.attributedText = dimension.attributedTo(font: fontSize16, color: UIColor.appColor(.appTextLightGray))
        stepsValueLabel.attributedText = "\(promptStabilityData.steps)".attributedTo(font: fontSize16, color: UIColor.appColor(.appTextLightGray))
        samplerValueLabel.attributedText = promptStabilityData.sampler.attributedTo(font: fontSize16, color: UIColor.appColor(.appTextLightGray))
        
        if let seedValue = promptStabilityData.resultImages.first?.seed{
            seedValueLabel.attributedText = "\(seedValue)".attributedTo(font: fontSize16, color: UIColor.appColor(.appTextLightGray))
        }
    }
    

   
    @IBAction func copyPromptAction(_ sender: UIButton) {
        guard let promptStabilityData = self.promptStabilityData else {return}
        UIPasteboard.general.string = promptStabilityData.propmt
        copiedPromptButton.isHidden = false
        copyPromptButton.isHidden = true
        Helper.dispatchMainAfter(time: .now() + 1) {
            self.copiedPromptButton.isHidden = true
            self.copyPromptButton.isHidden = false
        }
    }
    
    @IBAction func usePromptAction(_ sender: UIButton) {
        guard let promptStabilityData = self.promptStabilityData else {return}
        if let promptText = promptStabilityData.propmt{
            delegate?.didSelectIdeaOfTry(prompt: promptText, image: UIImage())
        }
//        self.dismiss(animated: true)
        customDismissViewController()
    }
    
    
    @IBAction func deleteImageAction(_ sender: UIButton) {
        let resultedImages = self.promptStabilityData?.resultImages
        if let index = resultedImages?.firstIndex(where: { $0.url ?? "" == promptStabilityData?.resultImages[currentImageIndex].url ?? ""}) {
            try? DBManager.shared.localDB?.write({
                if resultedImages?.count == 1{
                    if let _promptStabilityData = self.promptStabilityData{
                        draftDelegate?.deletedDraftModel(promptStabilityData: _promptStabilityData,isDeleted: true)
                        DBManager.shared.localDB?.delete(_promptStabilityData)
                        self.dismiss(animated: true)
                    }
                }else{
                    promptStabilityData?.resultImages.remove(at: index)
                    self.currentImageIndex = (resultedImages?.count == 1) ? 0 : index+1
                    self.imageListCollectionView.reloadData()
                    self.fullPreviewCollectionView.reloadData()
                }
                
            })
         
        }
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
        
        if let resultImage = promptStabilityData?.resultImages[currentImageIndex]{
            self.shareButton.isUserInteractionEnabled = false
            Helper().shortenURL(URLToSorten: AppDetail.appStoreLink) { finalURL in
                
                if (self.promptStabilityData?.isDraft ?? false){
                    if let _imageName = resultImage.url,let url = URL(string: _imageName){
                        UIImage.loadFrom(url: url) { image in
                            guard let _image = image else {return}
                            self.shareButton.isUserInteractionEnabled = true
                            Helper().shareDataActivity(withImage: true, text: "Made with Uranus\n\(finalURL ?? AppDetail.appStoreLink)",_image)
                        }
                    }
                    
                }else{
                    guard let _image = UIImage(named: resultImage.imageName ?? "") else {return}
                    Helper().shareDataActivity(withImage: true, text: "Made with Uranus\n\(finalURL ?? AppDetail.appStoreLink)",_image)
                }
            }
        }
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
//        self.dismiss(animated: true)
        if let _promptStabilityData = self.promptStabilityData{
            draftDelegate?.deletedDraftModel(promptStabilityData: _promptStabilityData,isDeleted: false)
        }
        customDismissViewController()
    }
    
    private func customDismissViewController(){
        self.promptDetailScrollView.backgroundColor = .clear
        UIView.animate(withDuration: 0.5, delay: 0,options: .curveEaseInOut) {
            self.backgroundTintView.alpha = 0.0
        }
//        self.promptDetailScrollView.contentOffset = CGPoint(x: 0, y: -900)

        UIView.animate(withDuration: 0.5, delay: 0,options: .curveEaseInOut) {
            self.promptDetailScrollView.contentOffset = CGPoint(x: 0, y: -900)
        } completion: { isCompleted in
            self.dismiss(animated: false)
        }
    }
    
}

//MARK: Collection View Delegate and Data Sources
extension TryTheseIdeasViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    private func registerCell(){
        fullPreviewCollectionView.registerCollectionCell(identifier: SuggestedStyleCollectionCell.identifier)
        imageListCollectionView.registerCollectionCell(identifier: SuggestedStyleCollectionCell.identifier)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return promptStabilityData?.resultImages.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == fullPreviewCollectionView{
            let  cell  = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestedStyleCollectionCell.identifier, for: indexPath) as! SuggestedStyleCollectionCell
            self.deleteImageButton.tag = indexPath.item
            if let resultImage = promptStabilityData?.resultImages[indexPath.item]{
                if let imageName = promptStabilityData?.isDraft ?? false ? resultImage.url : resultImage.imageName{
                    cell.configureCellForPreview(with: imageName,cornerRadius: 0, byURL: self.promptStabilityData?.isDraft ?? false)
                    
                }
            }
            /*  if let promptIdea = self.promptIdeaAiArt{
             cell.configureCell(with: promptIdea, layoutType: .grid,cornerRadius: 0)
             }*/
            return cell
        }else{
            let  cell  = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestedStyleCollectionCell.identifier, for: indexPath) as! SuggestedStyleCollectionCell
            if let resultImage = promptStabilityData?.resultImages[indexPath.item]{
                if let imageName = promptStabilityData?.isDraft ?? false ? resultImage.url : resultImage.imageName{
                    cell.configureCellForPreview(with: imageName,cornerRadius: 0, byURL: self.promptStabilityData?.isDraft ?? false)
                    
                }
            }
            if indexPath.item == currentImageIndex{
                _ = cell.border(width: 1, color: .appBlueColor)
            }else{
                _ = cell.border(width: 0, color: .appBlueColor)
            }
            /* if let promptIdea = self.promptIdeaAiArt{
             cell.configureCell(with: promptIdea, layoutType: .grid,cornerRadius: 5)
             }*/
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == imageListCollectionView{
            if let resultImage = promptStabilityData?.resultImages[indexPath.item]{
                let fontSize16 = Font(.installed(.PadaukRegular), size: .standard(.h3)).instance
                seedValueLabel.attributedText = "\(resultImage.seed)".attributedTo(font: fontSize16, color: UIColor.appColor(.appTextLightGray))
            }
            self.currentImageIndex = indexPath.item
            fullPreviewCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == fullPreviewCollectionView{
            let width = collectionView.bounds.width
            let height = collectionView.bounds.height
            let cellSize = CGSize(width: width, height: height)
            debugPrint("cellSize ",cellSize)
            return cellSize
        }else{
            let width = collectionView.bounds.height
            let cellSize = CGSize(width: width, height: width)
            debugPrint("cellSize ",cellSize)
            return cellSize
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == imageListCollectionView{
            return 6
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == imageListCollectionView{
            return 6
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == imageListCollectionView{
            let itemWidth = collectionView.bounds.height //collectionView.bounds.width / 6
            let spacingWidth: CGFloat = 6
            let numberOfItems = CGFloat(collectionView.numberOfItems(inSection: section))
            let cellSpacingWidth = numberOfItems * spacingWidth
            let totalCellWidth = numberOfItems * itemWidth + cellSpacingWidth
            let inset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth)) / 2
            return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        }
        return .zero
    }
    
}


extension TryTheseIdeasViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        debugPrint(#function)
        if scrollView == self.fullPreviewCollectionView{
            let index = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
            if  self.currentImageIndex != index {
                self.currentImageIndex = index
                if let resultImage = promptStabilityData?.resultImages[index]{
                    let fontSize16 = Font(.installed(.PadaukRegular), size: .standard(.h3)).instance
                    seedValueLabel.attributedText = "\(resultImage.seed)".attributedTo(font: fontSize16, color: UIColor.appColor(.appTextLightGray))
                }
                self.imageListCollectionView.reloadData()
            }
        }
    }
}

