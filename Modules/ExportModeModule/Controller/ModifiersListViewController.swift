//
//  ModifiersListViewController.swift
//  DreamAI
//
//  Created by iApp on 29/11/22.
//

import UIKit

struct ModifierObject {
    var isOpen : Bool
    var modifierCategory: AIArtDataModel.Modifiers
    var selectedCell:[Int] = []
}

protocol ModifierListDelegate: AnyObject{
    func didApplySelectedModifier(prompt: String)
    func didApplyAiStyleInPrompt(promptStyle: AIStyle)
    func didApplyRandomPrompt()
}

class ModifiersListViewController: UIViewController {
    
    weak var delegate: ModifierListDelegate?
    
    //MARK: Top View outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //MARK: promptTextView outlets
    @IBOutlet weak var enterPromptContainerView: UIView!
    @IBOutlet weak var enterPromtTextBackView: UIView!
    @IBOutlet weak var promptTextView: UITextView!
    @IBOutlet weak var totalStringCountLabel: UILabel!
    
    //MARK: Modifiers list and outlets
    @IBOutlet weak var modifiersListTableView: UITableView!
//    @IBOutlet weak var modifierTableViewHeightConstraint: NSLayoutConstraint!
    
    //MARK: Bottom View outlets
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var cancelModifiersButton: UIButton!
    @IBOutlet weak var applyModifiersButton: UIButton!
    
    private lazy var modifierObject = [ModifierObject]()
    
    var modifiersArray: [String] = []
    
    //MARK: UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setUpInitialData()
        setUpFont()
        setUpUIDesign()
        setPlaceholder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//       self.modifierTableViewHeightConstraint.constant = self.modifiersListTableView.contentSize.height
//        enterPromptContainerView.addShadow(location: .bottom,color: .black, opacity: 1, radius: 2)
//        enterPromptContainerView.backgroundColor = UIColor.appColor(.appBackground)?.withAlphaComponent(0.7)
        enterPromptContainerView.addShadow(offset: .init(width: 0, height: 5),color: UIColor.appColor(.appBackground) ?? .black,opacity: 0.35,radius: 5)
//        bottomContainerView.backgroundColor = UIColor.appColor(.appBackground)?.withAlphaComponent(0.1)
        bottomContainerView.addShadow(offset: .init(width: 0, height: -5),color: .black,opacity: 1,radius: 4)

    }
    //MARK: UI and Font update Methods
    private func setUpInitialData(){
        let modifiersCategories = AIArtDataModel.Modifiers.allCases
        for object in modifiersCategories {
            let modifier = ModifierObject(isOpen: false, modifierCategory: object)
            self.modifierObject.append(modifier)
        }
        self.modifiersListTableView.reloadData()
    }
    
    private func setUpFont(){
        let fontSize18 = Font(.installed(.PadaukRegular), size: .standard(.h2)).instance
        
        titleLabel.attributedText = titleLabel.text?.attributedTo(font: fontSize18,spacing: 0,color: .white,alignment: .center)
        
        // Update Bottom View action fonts
        let fontSize16 = Font(.installed(.PadaukRegular), size: .standard(.h3)).instance
        descriptionLabel.attributedText = descriptionLabel.text?.attributedTo(font: fontSize16,spacing: 0,color: .white,alignment: .left)
        
       
       /* let cancelTitle = cancelModifiersButton.currentTitle?.attributedTo(font: fontSize16, spacing: 1.25, color: UIColor.appColor(.appTextMagenta),alignment: .center)
        cancelModifiersButton.setAttributedTitle(cancelTitle, for: .normal)*/
        let bold18 = Font(.installed(.PadaukBold), size: .standard(.h2)).instance

        let attString = applyModifiersButton.currentTitle?.attributedTo(font: bold18, spacing: 0, color: UIColor.appColor(.appBackground),alignment: .center)//.underline(1)
        applyModifiersButton.setAttributedTitle(attString, for: .normal)
        
        didSelectPromptHistory(prompt: promptTextView.text)
       
    }
    
   private func didSelectPromptHistory(prompt: String) {
        let fontSize13 = Font(.installed(.PadaukRegular), size: .standard(.h2)).instance
        let promtTextViewAttString = prompt.attributedTo(font: fontSize13, spacing: 0,lineSpacing: -5, color: UIColor.appColor(.appTextPlaceholder))
        promptTextView.attributedText = promtTextViewAttString
        let stringLength:Int = self.promptTextView.text.count
        self.promptTextView.scrollRangeToVisible(NSMakeRange(stringLength-1, 0))
    }
    
    private func setPlaceholder() {
        if modifiersArray.count == 0{
            let fontSize13 = Font(.installed(.appRegular), size: .standard(.size13)).instance
            let fontSize15 = Font(.installed(.appBold), size: .standard(.size15)).instance
            
            let firstString = "Enter a prompt"
            let secondString = "\nDescribe what you want the AI to create"
            
            let titleAttribute = firstString.attributedTo(font: fontSize15, spacing: 0.75,lineSpacing: 2, color: UIColor.appColor(.appTextPlaceholder),alignment: .left)
            
            let titleAttribute2 = secondString.attributedTo(font: fontSize13, spacing: 0.67,lineSpacing: 2, color: UIColor.appColor(.appTextPlaceholder) ,alignment: .left)
            
            titleAttribute.append(titleAttribute2)
            
            promptTextView.attributedText = titleAttribute
        }else{
            self.updateTextViewtext()
        }
//        setUpApplyButton()
    }
  
    private func setUpUIDesign() {
        
        self.view.backgroundColor = UIColor.appColor(.appBackground)?.withAlphaComponent(0.9)
        self.view.blurViewEffect(withAlpha: 0.9, cornerRadius: 0)
        cancelModifiersButton.layer.cornerRadius = 2
        cancelModifiersButton.layer.cornerRadius = 2
        
        enterPromtTextBackView.layer.cornerRadius = 25
        enterPromtTextBackView.layer.masksToBounds = true
        enterPromtTextBackView.layer.borderColor = UIColor.appColor(.appGray)?.cgColor
        enterPromtTextBackView.layer.borderWidth = 0.7
        
        self.modifiersListTableView.contentInset = .init(top: 0, left: 0, bottom: 80, right: 0) //UIEdgeInsetsMake(50, 0, 0, 0)
        
//        enterPromptContainerView.addShadow(offset: .init(width: 0, height: 5),color: .black.withAlphaComponent(0.35),opacity: 1,radius: 2)
      
    }
    
   /* private func setUpApplyButton(){
        if modifiersArray.count > 0{
            // enable apply button
            applyModifiersButton.setTitleColor(UIColor.appColor(.appGreen), for: .normal)
            applyModifiersButton.isEnabled = true
        }else{
            applyModifiersButton.setTitleColor(UIColor.gray, for: .normal)
            applyModifiersButton.isEnabled = false
        }
    }*/

    //MARK: UIAction Methods
    @IBAction func clearPromptTextAction(_ sender: UIButton) {
        modifiersArray.removeAll()
//        modifierObject.forEach { object in
//            object.selectedCell.removeAll()
//        }
        for (index,_) in modifierObject.enumerated() {
            modifierObject[index].selectedCell.removeAll()
        }
        self.promptTextView.text = ""
//        setUpApplyButton()
        self.setPlaceholder()
        self.modifiersListTableView.reloadData()
    }
    
    @IBAction func cancelModifiersAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
   
    @IBAction func applyModifiersAction(_ sender: UIButton) {
        if modifiersArray.count > 0, let prompt = self.promptTextView.text{
            self.delegate?.didApplySelectedModifier(prompt: prompt)
        }
        self.dismiss(animated: true)
    }
   
    
    private func updateTextViewtext(){
        var completetext = ""
        for (index, language) in modifiersArray.enumerated(){
            let modifier = index == 0 ? language : ", " + language
            completetext += modifier
        }
        didSelectPromptHistory(prompt: completetext)
        totalStringCountLabel.text = "\(completetext.count)/\(500)" //aiArtGeneratorVM.countOfTotalNumberOfCharacters
//        self.promptTextView.text = completetext
    }
    
}

extension ModifiersListViewController: UITableViewDelegate, UITableViewDataSource{
    
    private func registerCell(){
        modifiersListTableView.registerTableCell(identifier: ModifiersTableCell.identifier)
        
        
        let sectionHeaderNib: UINib = UINib(nibName: "ModifierCategoryHeaderView", bundle: nil)
        self.modifiersListTableView.register(sectionHeaderNib, forHeaderFooterViewReuseIdentifier: "ModifierCategoryHeaderView")
        self.modifiersListTableView.sectionHeaderHeight = 40

        //        self.modifiersListTableView.registerNib(sectionHeaderNib, forHeaderFooterViewReuseIdentifier: SectionHeaderViewIdentifier)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return modifierObject.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // TODO : Custom your own view
        // have a callback to set property isOpen =  true or false to the internalData.
        
        let sectionHeaderView: ModifierCategoryHeaderView! = self.modifiersListTableView.dequeueReusableHeaderFooterView(withIdentifier: "ModifierCategoryHeaderView") as? ModifierCategoryHeaderView
        let obj = modifierObject[section]
        sectionHeaderView.configureHeaderView(with: obj, section: section)
        sectionHeaderView.delegate = self
        return sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let modifierCategory = modifierObject[section]
        if modifierCategory.isOpen{
            return modifierCategory.modifierCategory.keywords.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ModifiersTableCell.identifier, for: indexPath) as? ModifiersTableCell
        let modifierCategory = modifierObject[indexPath.section]
        let modifier = modifierCategory.modifierCategory.keywords[indexPath.row]
        cell?.configureCell(with: modifier)
        
        if (modifierObject[indexPath.section].selectedCell.contains(indexPath.row)){
            cell?.titleLabel.textColor = UIColor.appColor(.appBlueColor)
            cell?.radioIconImageView.image = UIImage(named: "buttton_selected")
        }else {
            cell?.titleLabel.textColor = UIColor.appColor(.appTextTitleColor)
            cell?.radioIconImageView.image = UIImage(named: "buttton_not_selected")
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let modifierCategory = modifierObject[indexPath.section]
        let title = modifierCategory.modifierCategory.keywords[indexPath.row]
       
        if (modifierObject[indexPath.section].selectedCell.contains(indexPath.row)){
            modifierObject[indexPath.section].selectedCell.remove(at: modifierObject[indexPath.section].selectedCell.firstIndex(of: indexPath.row)!)
            if let index = modifiersArray.firstIndex(of: title) {
                modifiersArray.remove(at: index)
                self.updateTextViewtext()
            }
        }else{
            modifierObject[indexPath.section].selectedCell.append(indexPath.row)
            modifiersArray.append(title)
            self.updateTextViewtext()
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? ModifiersTableCell{
            if (modifierObject[indexPath.section].selectedCell.contains(indexPath.row)){
                cell.titleLabel.textColor = UIColor.appColor(.appBlueColor)
                cell.radioIconImageView.image = UIImage(named: "buttton_selected")
            }else {
                cell.titleLabel.textColor = UIColor.appColor(.appTextTitleColor)
                cell.radioIconImageView.image = UIImage(named: "buttton_not_selected")
            }
        }
//        self.modifiersListTableView.beginUpdates()
//        self.modifiersListTableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
//        self.modifiersListTableView.reloadRows(at: [indexPath], with: .none)
//        self.modifiersListTableView.reloadData()
//        self.modifiersListTableView.endUpdates()
        //        self.modifiersListTableView.reloadRows(at: [indexPath], with: .bottom)
        //        self.modifiersListTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32
    }
}

//MARK: - TAPPED SECTION INDEX
extension ModifiersListViewController: SectionHeaderViewDelegate {
    func selectedSection(selIndex: Int) {
        debugPrint("")
        if modifierObject[selIndex].isOpen{
            modifierObject[selIndex].isOpen = false
        }else{
            modifierObject[selIndex].isOpen = true
        }
        Helper.dispatchMain {
            if let headerView =  self.modifiersListTableView.headerView(forSection: selIndex) as? ModifierCategoryHeaderView{
                UIView.animate(withDuration: 0.5, delay: 0) {
                    if self.modifierObject[selIndex].isOpen{
                        headerView.downArrowImageView.transform = CGAffineTransform(rotationAngle: 1.56)
                    }else{
                        headerView.downArrowImageView.transform = CGAffineTransform(rotationAngle: 0)
                    }
                }
            }
            self.modifiersListTableView.beginUpdates()
            let sectionIndex = IndexSet(integer: selIndex)
            self.modifiersListTableView.reloadSections(sectionIndex, with: .fade) // or fade, right, left, top, bottom, none, middle, automatic
            self.modifiersListTableView.endUpdates()
        }
    }
}
