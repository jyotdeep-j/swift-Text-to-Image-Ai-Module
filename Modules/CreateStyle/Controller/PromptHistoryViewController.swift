//
//  PromptHistoryViewController.swift
//  DreamAI
//
//  Created by iApp on 24/11/22.
//

import UIKit

protocol PromptHistoryDelegate: AnyObject{
    func didSelectPromptHistory(prompt: String)
}

class PromptHistoryViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var clearAllButton: UIButton!
    @IBOutlet weak var promptListTableView: UITableView!
    @IBOutlet weak var transparentBackgroundView: UIView!
    @IBOutlet weak var historyContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var promptHistoryContainerView: UIView!
    
    weak var delegate: PromptHistoryDelegate?
    var promptHistoryVM = PromptHistoryViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        self.setupUIFont()
        
        promptListTableView.estimatedRowHeight = 50
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let theme = ThemeManager.currentTheme()
        if theme == .lightTheme {
            overrideUserInterfaceStyle = .light
        }else{
            overrideUserInterfaceStyle = .dark
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        historyContainerBottomConstraint.constant = 0
        self.transparentBackgroundView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut) {
            self.transparentBackgroundView.alpha = 1
            self.view.layoutIfNeeded()
        } completion: { isComplete in
            
        }
    }
    
    func registerCell(){
        promptListTableView.registerTableCell(identifier: PromptHistoryTableCell.cellIdentifier)
    }
    private func setupUIFont(){
        
        let titleFont = Font(.installed(.myRiadRegular), size: .standard(.h2)).instance
        let titleAttribute = titleLabel.text?.attributedTo(font: titleFont, spacing: 0.91, color: UIColor.appColor(.appTextWhiteColor),alignment: .left)
        titleLabel.attributedText = titleAttribute
       
        let fontSize12 = Font(.installed(.appRegular), size: .standard(.h5)).instance
        let attString = clearAllButton.currentTitle?.attributedTo(font: fontSize12, spacing: 0.59, color: UIColor.appColor(.appTextWhiteColor))//.underline(1)
        clearAllButton.setAttributedTitle(attString, for: .normal)
    }
    
    func setNoDataInfoIfAbsenceNotExists()
    {
        let noDataLabel : UILabel = UILabel()
        noDataLabel.frame = CGRect(x: 0, y: 0, width: self.promptListTableView.bounds.width, height: self.promptListTableView.bounds.height)
        noDataLabel.text = "No history yet"
        noDataLabel.sizeToFit()
        noDataLabel.center.x = promptListTableView.frame.width - noDataLabel.frame.width
        noDataLabel.center.y = promptListTableView.frame.height - noDataLabel.frame.height
//        noDataLabel.textColor = UIColor.black
//        noDataLabel.textAlignment = .center
        let titleFont = Font(.installed(.myRiadRegular), size: .standard(.size15)).instance
        let titleAttribute = "No history yet".attributedTo(font: titleFont, spacing: 0.91, color: .lightGray,alignment: .center)
        noDataLabel.attributedText = titleAttribute
        
        self.promptListTableView.backgroundView = noDataLabel
        self.promptListTableView.separatorStyle = .none
    }
    
    func clearTableViewBackground(){
        self.promptListTableView.backgroundView = nil

    }
    
    private func dismissViewWithAnimation(){
        historyContainerBottomConstraint.constant = -750
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut) {
            self.transparentBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { isComplete in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func clearAllAction(_ sender: UIButton) {
        promptHistoryVM.clearAllPromptHistoryFromLocal { [weak self](isClearHistory) in
            Helper.dispatchMain {
                self?.promptListTableView.reloadData()
            }
        }
    }
}

extension PromptHistoryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = promptHistoryVM.numberOfItem
        
        if numberOfRows > 0{
            clearTableViewBackground()
        }else{
            setNoDataInfoIfAbsenceNotExists()
        }
        return promptHistoryVM.numberOfItem
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PromptHistoryTableCell.cellIdentifier, for: indexPath)as! PromptHistoryTableCell
        if let promptDataModel = promptHistoryVM.promptHistoryData(atIndex: indexPath.row){
            cell.configureCell(with: promptDataModel)
        }
       return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let promptDataModel = promptHistoryVM.promptHistoryData(atIndex: indexPath.row){
            debugPrint(promptDataModel.prompt)
            delegate?.didSelectPromptHistory(prompt: promptDataModel.prompt)
        }
        self.dismissViewWithAnimation()
    }
}

extension PromptHistoryViewController: UIGestureRecognizerDelegate{
    @IBAction func tapGestureRecognizerHandler(_ sender: UITapGestureRecognizer) {
        dismissViewWithAnimation()
        
    }

    
    @IBAction override func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        
        let translationY = sender.translation(in: sender.view!).y

        switch sender.state {
        case .began:
            break
        case .changed:
            debugPrint("translationY ",translationY)
            if translationY > 0{
                transparentBackgroundView.alpha = 1-(translationY/promptHistoryContainerView.bounds.height)

                self.promptHistoryContainerView.transform = CGAffineTransform(translationX: 0, y: translationY)
            }
        case .ended, .cancelled:
            debugPrint("translationY ",translationY)
            if translationY > 160 {
                transparentBackgroundView.alpha = 0

//                1- (1/600)
//
//                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut) {
//                    self.backgroundColorView.alpha = 0.0
//                } completion: { isComplete in
                    self.dismiss(animated: true, completion: nil)
//                }
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.promptHistoryContainerView.transform = CGAffineTransform(translationX: 0, y: 0)
                })
            }
        case .failed, .possible:
            break
        @unknown default:
            break
        }
    }
}
