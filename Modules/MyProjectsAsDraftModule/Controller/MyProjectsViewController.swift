//
//  MyProjectsViewController.swift
//  DreamAI
//
//  Created by iApp on 19/01/23.
//

import UIKit
import JHWaterFallFlowLayout


class MyProjectsViewController: UIViewController {
    
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var crossButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var myProjectsCollectionView: UICollectionView!{
        didSet{
            self.myProjectsCollectionView.collectionViewLayout = self.layout
        }
    }
    
    private lazy var layout: WaterFallFlowLayout = {
        let layout = WaterFallFlowLayout()
        layout.delegate = self
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return layout
    }()
    
    
    lazy var myProjectVM = { MyProjectViewModel() }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        self.loadViewModel()
 
    }
    
    @objc func reloadViewModel(){
        myProjectVM.promptStabilityData = []
        self.loadViewModel()
    }
    
    
    private func loadViewModel() {
        myProjectVM.reloadModelView = { [weak self] in
            DispatchQueue.main.async {
                self?.myProjectsCollectionView.reloadData()
            }
        }
        myProjectVM.fetchPromptDataDB()
    }
    
    @IBAction func settingButtonAction(_ sender: UIButton) {
        
         let settingVC = SettingViewController.initiantiate(fromAppStoryboard: .Main)
         self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    @IBAction func crossButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}



//MARK: Collection View Delegate and Data Sources
extension MyProjectsViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    private func registerCell(){
        myProjectsCollectionView.registerCollectionCell(identifier: SuggestedStyleCollectionCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return myProjectVM.numberOfItem //aiArtGeneratorVM.numberOfPromptIdeas
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let  cellA  = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestedStyleCollectionCell.identifier, for: indexPath) as! SuggestedStyleCollectionCell
        
        if let promptIdeaData = myProjectVM.myProject(atIndex: indexPath.item){
            if let imageName = promptIdeaData.resultImages.first?.url{
                cellA.configureCellForPreview(with: imageName,byURL: true)
            }
        }
        return cellA
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let tryTheseIdeaVC = TryTheseIdeasViewController.initiantiate(fromAppStoryboard: .ExportMode)
        if let promptIdeaData = myProjectVM.myProject(atIndex: indexPath.item){
            tryTheseIdeaVC.promptStabilityData = promptIdeaData
        }
        tryTheseIdeaVC.delegate = self
        tryTheseIdeaVC.draftDelegate = self
        tryTheseIdeaVC.modalPresentationStyle = .overCurrentContext
        self.present(tryTheseIdeaVC, animated: false)
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}

extension MyProjectsViewController: SuggestedStyleDelegate {
    
    func didSelectIdeaOfTry(prompt: String, image: UIImage) {
//        setupPromptAndUpdateHeight(prompt: prompt)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
//            self.contentScrollView.contentOffset = .zero
        } completion: { isComplete in
            
        }
    }
}

extension MyProjectsViewController: WaterFallFlowLayoutDelegate, DeletedDraftModel{
    
    func deletedDraftModel(promptStabilityData: PromptStabilityData,isDeleted:Bool) {
        
        if isDeleted{
            if let index =  myProjectVM.promptStabilityData.firstIndex(where: { $0 == promptStabilityData}) {
                myProjectVM.promptStabilityData.remove(at: index)
                self.myProjectsCollectionView.reloadData()
                
            }
        }else{
            myProjectVM.promptStabilityData = []
            self.loadViewModel()
        }
    }
    
    func waterFallFlowLayout(_ waterFallFlowLayout: WaterFallFlowLayout, itemHeight indexPath: IndexPath) -> CGFloat {
      guard let promptIdeaData = myProjectVM.myProject(atIndex: indexPath.item) else {
        return 0.0
      }
      let imageWidth = waterFallFlowLayout.itemWidth
      let imageHeight = CGFloat(promptIdeaData.height) * imageWidth / CGFloat(promptIdeaData.width)
      print("\(indexPath.item) image height: \(imageHeight)")
      return imageHeight
    }

    func columnOfWaterFallFlow(in collectionView: UICollectionView) -> Int {
      return 2
    }
}
