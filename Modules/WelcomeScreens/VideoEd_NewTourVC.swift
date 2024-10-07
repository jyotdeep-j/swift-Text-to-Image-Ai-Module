//
//  VideoEd_NewTourVC.swift
//  VideoEditorial
//
//  Created by Lakhdeep on 22/10/20.
//  Copyright © 2020 iApp. All rights reserved.
//

import UIKit
import AVFoundation

class VideoEd_NewTourVC: UIViewController {

    @IBOutlet weak var mainView                             : UIView!
    @IBOutlet weak var bottomView                           : UIView!
    @IBOutlet weak var tourCV                               : UICollectionView!
    @IBOutlet weak var skipBtn                              : UIButton!
    @IBOutlet weak var pageController                       : UIPageControl!
    
    var cancelBtnAction                                     : (()->())?

    var avAvAsset                                           : AVAsset?          = nil
    var avPlayerItem                                        : AVPlayerItem?     = nil
    var avPlayer                                            : AVPlayer?         = nil
    var avPlayerLayer                                       : AVPlayerLayer?    = nil
    
    var currentPage                                         : Int               = 0

    var imageArray = [UIImage]()
    
    var videoUrlsArray:[URL] {
        
        get {
//            let introVideoNames  : [String]   = ["Slide_Show_1","Filters_Video_1","Full_size_ight_leaks"]
            let introVideoNames  : [String]   = ["fx_video1","slomo_video1","textStyle_video1","textStyle_video1"]
            //["Full_size_ight_leaks","Slide_Show_1","Filters_Video_1"]
            var urlArray = [URL]()
            for name in introVideoNames {
                if let videoUrl = Bundle.main.url(forResource: name, withExtension: "mp4") {
                    urlArray.append(videoUrl)
                }
            }
            return urlArray
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageArray = getThumbnailsFromUrls(urlArray: videoUrlsArray)
        setUpUI()
        
        NotificationCenter.default.addObserver( self, selector: #selector(didBecomActiveWelcome(_:)),name: UIApplication.didBecomeActiveNotification, object: nil)

        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        detectPresentCell(tourCV)
    }
    
    func getThumbnailsFromUrls (urlArray:[URL]) -> [UIImage] {

        let images: [UIImage] = [UIImage(),UIImage(),UIImage(),UIImage()]
//        [AIStyle.s1.styleDetail().2,AIStyle.s2.styleDetail().2,AIStyle.s3.styleDetail().2,AIStyle.s4.styleDetail().2]
//        let assetArray:[AVAsset] = urlArray.map{ AVAsset(url: $0 )}
//        var imageArray = [UIImage]()
//
//        for asset in assetArray            {
//            if let image = VideoEdVideoManager().generateThumbnail(asset: asset, at: CMTime(seconds: 1.0, preferredTimescale: 1000)) {
//                imageArray.append(image)
//            }
//        }
        return images
    }
    
    func setUpUI()  {
        
        setUpCollectionView()
    }

    func setUpCollectionView() {
        
        let nib = UINib(nibName: "VideoEd_VideoTourCV_Cell", bundle: nil)
        tourCV.register(nib, forCellWithReuseIdentifier: "VideoEd_VideoTourCV_Cell")
        tourCV.dataSource = self
        tourCV.delegate = self

    }
    
    
    @IBAction func skipBtnAct(_ sender: UIButton) {
        
        if currentPage < 2 {
            
            currentPage = currentPage + 1
            if currentPage < 3 {
                pageController.currentPage = currentPage
            }
            
            tourCV.scrollToItem(at: IndexPath(row: currentPage , section: 0), at: .centeredHorizontally, animated: true)
            Helper.dispatchMainAfter(time: .now() + 0.3) { [weak self] in
                self?.detectPresentCell(self!.tourCV)
            }
            
            /*
            currentSelectedIndex = currentSelectedIndex + 1
            
            pageControl.currentPage = currentSelectedIndex
            pageControl.customPageControl(dotFillColor: color4PageControl)
            
            collectionImages.scrollToItem(at: IndexPath(row: currentSelectedIndex , section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
            
            if currentSelectedIndex < titleLabels.count-1{
                nextBtn.setTitle("NEXT", for: .normal)
                
                self.nextButtonSmallWidthCons.isActive = true
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
                
            }else{
                nextBtn.setTitle("GET STARTED", for: .normal)
                
                self.nextButtonSmallWidthCons.isActive = false
                
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }
            */
            
        } else{
            
            UserDefaults.standard.set(true, forKey: "VideoEdTourVC_Completed_Status")
            UserDefaults.standard.synchronize()
        
            if let cancelBtnAction = cancelBtnAction {
                cancelBtnAction()
            }
            NotificationCenter.default.removeObserver(self)
            self.dismiss(animated: true, completion: nil)
        }
    }
}


extension VideoEd_NewTourVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell:VideoEd_VideoTourCV_Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoEd_VideoTourCV_Cell", for: indexPath) as? VideoEd_VideoTourCV_Cell {
            cell.setUpUI(frame: cell.bounds)

//            if IS_IPHONE_X {
//                cell.firstTitleLbl.font     = UIFont(name: AppFonts.sfCompactHeavy, size: 26)
//                cell.secondTitleLbl.font    = UIFont(name: AppFonts.sfCompactHeavy, size: 26)
//                cell.descriptionLbl.font    = UIFont(name: AppFonts.Regular, size: 14)
//            }else if IS_IPHONE_X_Series {
//                cell.firstTitleLbl.font     = UIFont(name: AppFonts.sfCompactHeavy, size: 28)
//                cell.secondTitleLbl.font    = UIFont(name: AppFonts.sfCompactHeavy, size: 28)
//                cell.descriptionLbl.font    = UIFont(name: AppFonts.Regular, size: 16)
//            }else if IS_IPHONE_X_MAX {
//                cell.firstTitleLbl.font     = UIFont(name: AppFonts.sfCompactHeavy, size: 28)
//                cell.secondTitleLbl.font    = UIFont(name: AppFonts.sfCompactHeavy, size: 28)
//                cell.descriptionLbl.font    = UIFont(name: AppFonts.Regular, size: 16)
//            }else if IS_IPHONE_6P {
//                cell.firstTitleLbl.font     = UIFont(name: AppFonts.sfCompactHeavy, size: 24)
//                cell.secondTitleLbl.font    = UIFont(name: AppFonts.sfCompactHeavy, size: 24)
//                cell.descriptionLbl.font    = UIFont(name: AppFonts.Regular, size: 13)
//            }else if IS_IPHONE {
//                cell.firstTitleLbl.font     = UIFont(name: AppFonts.sfCompactHeavy, size: 24)
//                cell.secondTitleLbl.font    = UIFont(name: AppFonts.sfCompactHeavy, size: 24)
//                cell.descriptionLbl.font    = UIFont(name: AppFonts.Regular, size: 13)
//            }
            
            if indexPath.item == 0  {
                cell.firstTitleLbl.text     = "Add FX"
                cell.secondTitleLbl.text    = "Effect in video"
                let discriptionString       = "1000+ FX effects and Filters for video"
                cell.descriptionLbl.text    = discriptionString
//                cell.firstTitleView.backgroundColor = UIColor.fxVideoTextBgColor
//                cell.secondTitleView.backgroundColor = UIColor.fxVideoTextBgColor
            } else if indexPath.item == 1 {
                cell.firstTitleLbl.text     = "Create"
                cell.secondTitleLbl.text    = "Slo Mo Video"
                let discriptionString       = "Slow down video speed with speed adjustment"
                cell.descriptionLbl.text    = discriptionString
//                cell.firstTitleView.backgroundColor = UIColor.slomoVideoTextBgColor
//                cell.secondTitleView.backgroundColor = UIColor.slomoVideoTextBgColor
            }else if indexPath.item == 2 {
                cell.firstTitleLbl.text     = "Add Multiple"
                cell.secondTitleLbl.text    = "Text Style"
                let discriptionString       = "Decorate your templates with text & stickers"
                cell.descriptionLbl.text    = discriptionString
//                cell.firstTitleView.backgroundColor = UIColor.textStyleVideoTextBgColor
//                cell.secondTitleView.backgroundColor = UIColor.textStyleVideoTextBgColor
            }

//            cell.firstTitleLbl.addCharacterSpacing(kernValue: 0.8)
//            cell.secondTitleLbl.addCharacterSpacing(kernValue: 0.8)
            if imageArray.count > indexPath.item {
                cell.backVideoThumbView.image = imageArray[indexPath.item]
            }
            
            /*if indexPath.item == 0 {
                
                cell.sampleImageView1.image = UIImage(named: "BokheSample")
                cell.sampleImageView2.image = UIImage(named: "GrungeSample")
                cell.sampleImageView3.image = UIImage(named: "SunburnSample")
                cell.sampleImageView4.image = UIImage(named: "RainbowSample")
            } else if indexPath.item == 1 {
                
                cell.sampleImageView1.image = UIImage(named: "SlideSample")
                cell.sampleImageView2.image = UIImage(named: "BlurSample")
                cell.sampleImageView3.image = UIImage(named: "RotateSample")
                cell.sampleImageView4.image = UIImage(named: "ZoomSample")
                
            } else if indexPath.item == 2 {
                
                cell.sampleImageView1.image = UIImage(named: "filmBurnSample")
                cell.sampleImageView2.image = UIImage(named: "lensFlareSample")
                cell.sampleImageView3.image = UIImage(named: "sunKiissedSample")
                cell.sampleImageView4.image = UIImage(named: "vintageSample")
            }*/
            
            
            //        let height = 60
            //        let parentViewHeight = 445/414 * cell.frame.width
            ////        cell.gradientLayer = CAGradientLayer()
            //        let frame = CGRect(x: 0, y: Int(parentViewHeight) - height , width: Int(cell.frame.width), height: height)
            //        cell.gradientLayer.frame = frame
            //        cell.gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
            //        cell.gradientLayer.locations = [0.0, 0.5]
            //        cell.videoView.layer.addSublayer(cell.gradientLayer)
            //
            //        cell.gradientLayer.backgroundColor = UIColor.red.cgColor
            //        cell.gradientLayer.borderColor = UIColor.yellow.cgColor
            //        cell.gradientLayer.borderWidth = 2.0
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            detectPresentCell(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        detectPresentCell(scrollView)
    }
    
    func detectPresentCell(_ scrollView: UIScrollView)  {
        
        let offset = scrollView.contentOffset

        let page =  Int(offset.x / scrollView.frame.width)
        pageController.currentPage = page
        currentPage = page
        if currentPage > 1{
            skipBtn.setTitle("Continue", for: .normal)
        }else{
            skipBtn.setTitle("Next", for: .normal)
        }
        if videoUrlsArray.count > page {
            
//            let name = introVideoNames[page]
            if let cell:VideoEd_VideoTourCV_Cell = tourCV.cellForItem(at: IndexPath(item: page, section: 0)) as? VideoEd_VideoTourCV_Cell {
                
                let url = videoUrlsArray[page]
                setAVplayer(videoUrl: url, view: cell.videoView, frame: cell.videoView.frame)
                
                /*
                if let videoUrl = Bundle.main.url(forResource: name, withExtension: "mp4") {
                    setAVplayer(videoUrl: videoUrl, view: cell.videoView, frame: cell.videoView.frame)
                }*/
                
            }
            
        }
        
    }
    

    func dellocAVPlayer() {
        
        if avPlayer != nil {
            avPlayer?.pause()
            NotificationCenter.default.removeObserver(self, name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer?.currentItem!)
//            avPlayer?.currentItem?.removeObserve
            avPlayer = nil
        }
        if avPlayerLayer != nil {
            avPlayerLayer?.removeAllAnimations()
            avPlayerLayer?.removeFromSuperlayer()
            avPlayerLayer = nil
        }
        if avPlayerItem != nil {
            avPlayerItem = nil
        }
        
        if avAvAsset != nil {
            avAvAsset = nil
        }
    }
    
    
    func setAVplayer(videoUrl:URL,view:UIView,frame:CGRect) {
        
        dellocAVPlayer()
        avAvAsset = AVAsset(url: videoUrl)
        avPlayerItem = AVPlayerItem(asset: avAvAsset!)
        avPlayer = AVPlayer(playerItem: avPlayerItem)
        
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        let parentViewHeight:CGFloat = 1774/1242 * frame.width //414/445
        avPlayerLayer?.frame = CGRect(x: 0, y: 0, width: frame.width, height: parentViewHeight)
        
        avPlayerLayer?.videoGravity = .resizeAspectFill
        
        view.layer.addSublayer(avPlayerLayer!)
        
        avPlayer?.seek(to: .zero)
        avPlayer?.play()
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer?.currentItem!)
        NotificationCenter.default.addObserver( self, selector: #selector(playerItemDidReachEnd(_:)),name: .AVPlayerItemDidPlayToEndTime, object: avPlayer?.currentItem)
    }
    
    @objc func playerItemDidReachEnd(_ notification: Notification?) {
        let playerItem = notification?.object as? AVPlayerItem
        playerItem?.seek(to: .zero, completionHandler: nil)
        avPlayer?.play()
    }
    
    @objc func didBecomActiveWelcome(_ notification: Notification?) {
        if let player = avPlayer {
            player.play()
        }
    }
    
    
}
