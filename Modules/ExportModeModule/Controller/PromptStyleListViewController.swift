//
//  PromptStyleListViewController.swift
//  DreamAI
//
//  Created by iApp on 21/12/22.
//

import UIKit

class PromptStyleListViewController: UIViewController {

    weak var delegate: ModifierListDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var promptStyleCollectionView: UICollectionView!
    
    private var aiStyleArr: [AIStyle] = AIStyle.allCases
    public var currentAIStyle: AIStyle = .none

    @IBOutlet weak var selctePromptButton: UIButton!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        self.setUpUIFont()
//        self.preferredContentSize = CGSize(width: 300, height: 200)

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func setUpUIFont(){
        let fontSize18 = Font(.installed(.PadaukRegular), size: .standard(.h2)).instance
        let titleTextAttri = titleLabel.text?.attributedTo(font: fontSize18, spacing: 0, color: .white,alignment: .center)
        titleLabel.attributedText = titleTextAttri
        
        let select = selctePromptButton.currentTitle?.attributedTo(font: fontSize18, spacing: 0, color: .black,alignment: .center)
        selctePromptButton.setAttributedTitle(select, for: .normal)
    }

    @IBAction func selectPromptAction(_ sender: UIButton) {
//        let prompt = self.currentAIStyle//.styleDetail().prompt
        delegate?.didApplyAiStyleInPrompt(promptStyle: self.currentAIStyle)
        
//        delegate?.didApplySelectedModifier(prompt: prompt)
        self.dismiss(animated: true)
    }
}

//MARK: Collection View Delegate and Data Sources
extension PromptStyleListViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    private func registerCell(){
        promptStyleCollectionView.registerCollectionCell(identifier: AIStyleCollectionCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.aiStyleArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cellA  = collectionView.dequeueReusableCell(withReuseIdentifier: AIStyleCollectionCell.identifier, for: indexPath) as! AIStyleCollectionCell
        let style =  self.aiStyleArr[indexPath.item]
        cellA.isStyleSelected = self.currentAIStyle == style
        cellA.configureCell(with: style)
        return cellA
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let style =  self.aiStyleArr[indexPath.item]
        
       /* if style.styleDetail().isPro && !StoreManager.shared.isPurchased{
            Helper.sharedInstance.openIAPSubscription()
        }else{*/
            self.currentAIStyle = style
            collectionView.reloadData()
            collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
          /*  aiArtGeneratorVM.didSelectStyleAtIndex(index: indexPath.item)
            self.styleCollectionView.reloadData()
            self.styleCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            if aiArtGeneratorVM.isShowAdvancedOption {
                //Append text in text view
                if aiArtGeneratorVM.currentAIStyle != .none{
                    if isTextViewHavePlaceholder{
                        prompTextView.text = ""
                        aiArtGeneratorVM.promtText = ""
                    }
                    let truncatedText = aiArtGeneratorVM.setPromptTextUptoLimit()
                    self.didSelectIdeaOfTry(prompt: truncatedText, image: UIImage())
                    let stringLength:Int = self.prompTextView.text.count
                    self.prompTextView.scrollRangeToVisible(NSMakeRange(stringLength-1, 0))
                }
            }*/
//        }
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        /* let collectionWidth = collectionView.bounds.width  - 50
         return CGSize(width: collectionWidth / 4, height: collectionView.frame.size.height - 15)*/
        let collectionWidth = collectionView.bounds.width/3.65 // - 50
        let cellSize = CGSize(width: collectionWidth, height: collectionWidth)
        debugPrint("cellSize ",cellSize)
        return cellSize
        //return CGSize.init(width: collectionView.frame.size.width/4.3, height:collectionView.frame.size.height)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 14
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 18, bottom: 0, right: 18)
        
    }
}
