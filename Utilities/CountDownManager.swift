//
//  CountDownManager.swift
//  DreamAI
//
//  Created by iApp on 06/01/23.
//

import UIKit

class CountDownManager: NSObject {
   static let START_TIME_KEY = "startTime"
//    let STOP_TIME_KEY = "stopTime"
//    let COUNTING_KEY = "countingKey"
    
    weak var timer:Timer?
    
    var startDate: Date?
     
//    var time = 0

    
//     static var shared = VPNTimer()
     
    override init() {
        super.init()
        
       
        if let startDate = Helper.value(forKey: Self.START_TIME_KEY) as? Date{
            self.startDate = startDate
        }else{
            let today = Date()
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
            startDate = tomorrow
            Helper.setValue(tomorrow, forKey: Self.START_TIME_KEY)
        }
        
    }
    
     deinit {
         timer?.invalidate()
     }
     
     
    func startTimer(completionHandler: @escaping  (_ currentTime:String) -> Void) {
        let isAlrectClaimed = Helper.bool(forKey: kUserDefault.isDailyCreditLimitClamed)
        if !isAlrectClaimed{
            return
        }
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            if let start = self.startDate {
                let diff = Date().timeIntervalSince(start)
                if diff >= 0{
                    self.resetCreditCountdown()
                }else{
                    //self.time += 1
                    completionHandler(self.updateTimerLabel(currentTime: Int(diff)))
                }
            }
        })
    }
     
     func stopTimer(){
         timer?.invalidate()
     }
     
     func updateStartTime(startDateTime:Date){
         startDate = startDateTime
     }
     
    
    func resetCreditCountdown(){
        timer?.invalidate()
        let today = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
        Helper.setValue(tomorrow, forKey: Self.START_TIME_KEY)
        self.startDate = tomorrow
        Helper.setBool(false, forKey: kUserDefault.isDailyCreditLimitClamed)
    }
    
    func updateTimerLabel(currentTime: Int) -> String{
//         let interval = Int(startDate.timeIntervalSinceNow)
         let hours = abs(currentTime / 3600)
         let minutes = abs(currentTime / 60 % 60)
         let seconds = abs(currentTime % 60)
         return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
     }
    
    
/*    class var shared: CountDownManager {
        struct Singleton {
            static let instance = CountDownManager()
        }
        return Singleton.instance
    }
    var scheduledTimer: Timer!

    var previousDateTime: Date?
    
    
    private func initialSetupOfCreditCountDown(){
        previousDateTime = UserDefaults.standard.object(forKey: START_TIME_KEY) as? Date
//        stopTime = userDefaults.object(forKey: STOP_TIME_KEY) as? Date
//        timerCounting = userDefaults.bool(forKey: COUNTING_KEY)
        
        /*if timerCounting{
            startTimer()
        }else {
            stopTimer()
            if let start = startTime
            {
                if let stop = stopTime
                {
                    let time = calcRestartTime(start: start, stop: stop)
                    let diff = Date().timeIntervalSince(time)
                    setTimeLabel(Int(diff))
                }
            }
        }*/
    }
    
    func startTimer() {
        scheduledTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        RunLoop.main.add(scheduledTimer, forMode: RunLoop.Mode.common)
//        setTimerCounting(true)
    }
    
    
    @objc func updateTime() {
        if let start = previousDateTime {
            let diff = Date().timeIntervalSince(start)
            if diff >= 0 {
                resetAction()
                Helper.setBool(false, forKey: kUserDefault.isDailyCreditLimitClamed)
//                setUpCreditBannerWithCountDown()
//                Helper.bool(forKey: kUserDefault.isDailyCreditLimitClamed)
            }else{
                setTimeLabel(Int(diff))
            }
        }
        else {
            stopTimer()
            setTimeLabel(0)
        }
    }*/
}
