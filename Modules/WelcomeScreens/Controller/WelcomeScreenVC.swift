//
//  WelcomeScreenVC.swift
//  ScreenRecorder
//
//  Created by iApp on 03/09/21.
//

import UIKit
import AppTrackingTransparency
import UIKit
import AVFoundation
import Foundation
import AVKit
import Photos

protocol WelcomeScreenDelagate: AnyObject{
    func welcomeScreenWillDismiss()
}
class WelcomeScreenVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    weak var delagate: WelcomeScreenDelagate?
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //AdManager.sharedInstance.loadInterstitial()
        self.setupCollectionView()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 14, *) {
            
//            let trackingPopDisplayed = UserDefaults.standard.bool(forKey: NotificationKeys.K_TRACKING_POPUP_ALREADY_DSIPALYED)
//            if trackingPopDisplayed != true {
//                showCustomAlert()
//            }
            
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: WelcomeScreenCVCell.Identifier, bundle: nil), forCellWithReuseIdentifier: WelcomeScreenCVCell.Identifier)
        collectionView.reloadData()
        collectionView.isPagingEnabled = true
        pageController.isUserInteractionEnabled = false
    }
    
    
    
    
//    func showCustomAlert(){
//        AlertManager.shared.alertWithTitleAndImage(title: "Screen Recorder", message: "Your data will be used to track events so that we can provide a better user experience and measure our marketing efforts.", image: UIImage(imageLiteralResourceName: "happyemoji"), dismiss: "Continue") {
//
//            debugPrint("completion")
////            let isCustomReviewDone = Helper.bool(forKey: Notification_Keys.K_FEEDBACK_REVIEW_DONE)
////            if isCustomReviewDone {
////                Globals.showAppleReview()
////            }else{
////                //self.showSwipeUpCustomInAppPopUpView()
////            }
//            UserDefaults.standard.set(true, forKey: NotificationKeys.K_TRACKING_POPUP_ALREADY_DSIPALYED)
//            self.requestPermission()
//
//        } dismissBlock: {
//            debugPrint("dimiss")
//        }
//    }
    
    
    
    //NEWLY ADDED PERMISSIONS FOR iOS 14
//    private func requestPermission() {
//        if #available(iOS 14, *) {
//            ATTrackingManager.requestTrackingAuthorization { status in
//                switch status {
//                case .authorized:
//                    // Tracking authorization dialog was shown
//                    // and we are authorized
//                    print("Authorized")
//
//                    // Now that we are authorized we can get the IDFA
//                case .denied:
//                    // Tracking authorization dialog was
//                    // shown and permission is denied
//                    print("Denied")
//                case .notDetermined:
//                    // Tracking authorization dialog has not been shown
//                    print("Not Determined")
//                case .restricted:
//                    print("Restricted")
//                @unknown default:
//                    print("Unknown")
//                }
//            }
//        }
//    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(#function)
        let visibleIndex = collectionView.indexPathsForVisibleItems
        if !visibleIndex.isEmpty{
            pageController.currentPage = visibleIndex.first!.item
        }

//        pageController.currentPage = collectionView.centerCellIndexPath?.item ?? 0
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print(#function)
    }
    
    @objc func continueButtonAction(_ sender: UIButton) {
       // sender.isUserInteractionEnabled = false
        if sender.tag == 0 {
            print("last cell")
            if !UserDefaults.standard.bool(forKey: "AppTourCompleted"){
                //Globals.showAppleReview()
                UserDefaults.standard.set(true, forKey: "AppTourCompleted")
                self.delagate?.welcomeScreenWillDismiss()
             self.dismiss(animated: true) {
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "CompleteTour"), object: nil, userInfo: [:])
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "ProductLoadedNotification"), object: nil, userInfo: [:])
             }
            }else{
                self.delagate?.welcomeScreenWillDismiss()
                self.dismiss(animated: true, completion: nil)
            }
            
        }else{
            collectionView.scrollToItem(at: IndexPath(item: sender.tag+1, section: 0), at: .centeredHorizontally, animated: true)
            pageController.currentPage = sender.tag+1
            sender.isUserInteractionEnabled = true
        }
    }
    
//    MARK:- Collection View Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WelcomeScreenCVCell.Identifier, for: indexPath) as? WelcomeScreenCVCell else {
            return UICollectionViewCell()
        }
        switch indexPath.item {
        case 0:
            cell.setupFirstScreen()
           
        case 1:
            cell.setupSecondScreen()
        case 2:
            cell.setupThirdScreen()
        case 3:
            cell.setupFourthScreen()
        default:
            break
        }
        cell.bgImageView.contentMode = .scaleAspectFill
        cell.continueBtn.tag = indexPath.item
        cell.continueBtn.addTarget(self, action: #selector(continueButtonAction(_:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
