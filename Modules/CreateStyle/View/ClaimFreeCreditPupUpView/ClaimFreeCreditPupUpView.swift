//
//  ClaimFreeCreditPupUpView.swift
//  DreamAI
//
//  Created by iApp on 06/01/23.
//

import UIKit

class ClaimFreeCreditPupUpView: UIView {

    @IBOutlet weak var fullBgTintView: UIView!
    
    @IBOutlet weak var backgroundContainerView: UIView!
    @IBOutlet weak var blurViewBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var congratsTitleLabel: UILabel!
    @IBOutlet weak var numberOfCreditsAddedLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var okayButton: UIButton!
    
    var startTime:Date?
    var scheduledTimer: Timer!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        blurViewBottomConstraint.constant = -440
        self.fullBgTintView.alpha = 0
        setUpUIDesign()
        initialSetupOfCreditCountDown()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundContainerView.mask(withRect: self.backgroundContainerView.frame, cornerRadius: 15,inverse: true)
    }
    
    private func setUpUIDesign() {
        
        backgroundContainerView.roundCorners([.topLeft,.topRight], radius: 15)
        
        okayButton.corner(cornerRadius: okayButton.bounds.height/2)
        let font20 = Font(.installed(.HelveticaBold), size: .custom(30)).instance
        let congratsTitle = congratsTitleLabel.text?.attributedTo(font: font20, spacing: 1.5, color: .white,alignment: .center)
        congratsTitleLabel.attributedText = congratsTitle
        
        let fontRegular = Font(.installed(.HelveticaRegular), size: .custom(21)).instance
        let numberOfCredits = numberOfCreditsAddedLabel.text?.attributedTo(font: fontRegular, spacing: 1.5,lineSpacing: 5, color: .white,alignment: .center)
        numberOfCreditsAddedLabel.attributedText = numberOfCredits
        
        let fontRegular14 = Font(.installed(.HelveticaRegular), size: .custom(14)).instance

        let messageText = messageLabel.text?.attributedTo(font: fontRegular14, spacing: 1.5, color: .white,alignment: .center)
        messageLabel.attributedText = messageText
        
        let padaukBold = Font(.installed(.PadaukBold), size: .custom(20)).instance
        let okayText = okayButton.currentTitle?.attributedTo(font: padaukBold, spacing: 0, color: .white,alignment: .center)
        okayButton.setAttributedTitle(okayText, for: .normal)

        
    }
    
    func updateCoutDownInLabel(time: String){
        let fontRegular14 = Font(.installed(.HelveticaBold), size: .custom(20)).instance

        let timeText = time.attributedTo(font: fontRegular14, spacing: 1.5, color: UIColor.appColor(.appYellow),alignment: .center)
        countDownLabel.attributedText = timeText
    }
    
    @IBAction func okayButtonAction(_ sender: UIButton) {
        Helper.setBool(true, forKey: kUserDefault.isDailyCreditLimitClamed)
        self.hideView()
    }
    
}


extension ClaimFreeCreditPupUpView{
    
    public func showView(withCreditNumber creditCount: Int = 5) {
        let fontRegular = Font(.installed(.HelveticaRegular), size: .custom(21)).instance
        let numberOfCredits = "\(creditCount) credits have been added\nto your account!".attributedTo(font: fontRegular, spacing: 1.5,lineSpacing: 5, color: .white,alignment: .center)
        numberOfCreditsAddedLabel.attributedText = numberOfCredits
        
        UIView.animate(withDuration: 0.1, delay: 0) {
            self.fullBgTintView.alpha = 1
        }
        blurViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3, delay: 0,options: [.curveEaseInOut]) {
            self.layoutIfNeeded()
        }
    }
    
    public func hideView(){
        UIView.animate(withDuration: 0.1, delay: 0) {
            self.fullBgTintView.alpha = 0
        }
        blurViewBottomConstraint.constant = -440
        UIView.animate(withDuration: 0.3, delay: 0,options: [.curveEaseInOut]) {
            self.layoutIfNeeded()
        }completion: { isComplete in
            self.removeFromSuperview()
        }
    }
}

extension ClaimFreeCreditPupUpView {
    
    private func initialSetupOfCreditCountDown(){
        
        let today = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
        startTime = tomorrow

    }
   
    func calcRestartTime(start: Date, stop: Date) -> Date
    {
        let diff = start.timeIntervalSince(stop)
        return Date().addingTimeInterval(diff)
    }
    func startTimer()
    {
        scheduledTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(refreshValue), userInfo: nil, repeats: true)
        RunLoop.main.add(scheduledTimer, forMode: RunLoop.Mode.common)
    }
    
    @objc func refreshValue()
    {
        if let start = startTime {
            let diff = Date().timeIntervalSince(start)
            if diff >= 0{
//                setTimeLabel(Int(diff))
            }else{
                setTimeLabel(Int(diff))
            }
        }
        else {
            stopTimer()
            setTimeLabel(0)
        }
    }
    func setTimeLabel(_ val: Int)
    {
        let time = self.secondsToHoursMinutesSeconds(val)
        let timeString = self.makeTimeString(hour: time.0, min: time.1, sec: time.2)
        self.updateCoutDownInLabel(time: timeString)
    }
    
    func secondsToHoursMinutesSeconds(_ ms: Int) -> (Int, Int, Int)
    {
        let hour = abs(ms / 3600)
        let min = abs((ms % 3600) / 60)
        let sec = abs((ms % 3600) % 60)
        return (hour, min, sec)
    }
    
    func makeTimeString(hour: Int, min: Int, sec: Int) -> String
    {
        var timeString = ""
        timeString += String(format: "%02d", hour)
        timeString += ":"
        timeString += String(format: "%02d", min)
        timeString += ":"
        timeString += String(format: "%02d", sec)
        return timeString
    }

    func stopTimer()
    {
        if scheduledTimer != nil
        {
            scheduledTimer.invalidate()
        }

    }
 
}
