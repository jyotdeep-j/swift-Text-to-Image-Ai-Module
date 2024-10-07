//
//  SaveShareMediaViewModel.swift
//  DreamAI
//
//  Created by Pritpal Singh on 09/11/22.
//

import UIKit
import Photos


enum SocialMediaType{
    case save
    case instagram
    case facebook
    case whatsapp
    case more
    
    
    var title: String{
        switch self {
        case .save:
            return "Save"
        case .instagram:
            return "Instagram"
        case .facebook:
            return "Facebook"
        case .whatsapp:
            return "Whatsapp"
        case .more:
            return "More"
        }
    }
}
class SaveShareMediaViewModel: NSObject {

//    private var shareMediaOptions: [SocialMediaType] = [.save,.instagram,.facebook,.whatsapp,.more]
    
    public var promptText: String{
        stabilityAIData.prompt ?? ""
    }
//    public var selectedStyleImage: UIImage?
    public var currentAIStyle: AIStyle = .none
    public var text2ImageResultData: Text2ImageResultDataModel?
    
    private var text2ImageAPITimer: Timer?
    private var text2ImageTaskId: Int = 0
    weak var delegate: AIArtGeneratorDelegate?

    public var stabilityAIData: StabilityAiData = StabilityAiData()
    public var stabilityResponseModel: CutOutModel?
//    public var isReCreated: Bool = false
//    public var canReCreate: Bool = false
    var reloadPopView: ((_ value:Bool) -> Void)?
    public var artSaved = Bool(){
        didSet{
            reloadPopView?(artSaved)
        }
    }

    override init() {
        super.init()
        
    }
}

extension SaveShareMediaViewModel{
    
    var numberOfItem: Int{
        self.stabilityResponseModel?.images?.count ?? 0
    }
    
    func imageData(atIndex index: Int) -> StabilityImages?{
        if numberOfItem > index{
            return self.stabilityResponseModel?.images?[index]
        }
        return nil
    }
}

extension SaveShareMediaViewModel{
    
    func saveStabilityDataInDraft(){
        if let stabilityData = self.stabilityResponseModel{
            let stabilityData = PromptStabilityData(withStabilityData: stabilityData)
            stabilityData.isDraft = true
            debugPrint("stabilityData ",stabilityData)
            if !DBManager.isDbAvailable { return }
            try! DBManager.shared.localDB?.write({
                
                //IMPLEMNT THIS CODE IF RECREATED ART REQUIRED TO OVERIDE PREVIOUS ART
//
//                if isReCreated && canReCreate{
//                    guard let storedPromtData = DBManager.shared.localDB?.objects(PromptStabilityData.self).last else {return}
//
//                    storedPromtData.cfgScale     =  stabilityData.cfgScale
//                    storedPromtData.egine        =  stabilityData.egine
//                    storedPromtData.height       =  stabilityData.height
//                    storedPromtData.width        =  stabilityData.width
//                    storedPromtData.propmt       =  stabilityData.propmt
//                    storedPromtData.resultImages =  stabilityData.resultImages
//                    storedPromtData.sampler      =  stabilityData.sampler
//                    storedPromtData.steps        =  stabilityData.steps
//                    storedPromtData.isDraft      =  stabilityData.isDraft
//
//                }else{
//                    canReCreate = true
//                    DBManager.shared.localDB?.add(stabilityData)//.add(self)
//                }
                
                DBManager.shared.localDB?.add(stabilityData)//.add(self)
                artSaved = true
            })
        }
 
    }
    
}

extension SaveShareMediaViewModel {
    
    func createTextToImageAICutProWithImage(unlockAllImages: Bool = false) {
        
        if !APIManager.shared().isInternetAvailable{
            self.didUpdateText2ImageResult(nil, "Internet is not available, Please try again.")
            return
        }
        
        let image: UIImage? = self.stabilityAIData.inputImage?.resized(toPixels: 1024)
        
        let style = self.currentAIStyle.styleDetail().prompt.trim()
        let searchedText = self.promptText.trim() + " " + style
        //        let originalNumberOfImages = self.stabilityAIData.numberOfImages
        if unlockAllImages{
            let pendingImages =  8 - self.stabilityAIData.numberOfImages
            self.stabilityAIData.numberOfImages = pendingImages
        }
        //        let parameterType = ParameterType.textWithImage(prompt: searchedText,stableEngine: "")
        let parameterType = ParameterType.textWithImage(prompt: searchedText, stabilityData: self.stabilityAIData)
        if unlockAllImages{
            self.stabilityAIData.numberOfImages = 8//originalNumberOfImages
        }
        debugPrint("parameterType ",parameterType.params)
        
        let textWithImage = EndpointItem.textWithImage(prompt: searchedText)
        _ =  APIManager.shared().uploadImageWithText(type: textWithImage,params: parameterType.params, imageToUpload: image, uploadProgress: { progress in
            print(progress)
        }, success: { [weak self] (model: CutOutModel?) in
            if let _ = model?.success{
                if let response = model{
                    if (model?.success ?? false){
                        if unlockAllImages{
                            if let newImages = response.images{
                                self?.stabilityResponseModel?.images?.append(contentsOf: newImages)
                            }
                            if let stableData = self?.stabilityResponseModel{
                                self?.delegate?.didGetStabilityResult(result: stableData)
                            }
                        }else{
                            self?.delegate?.didGetStabilityResult(result: response)
                        }
                    }else{
                        self?.didUpdateText2ImageResult(nil, model?.error ?? "")
                    }
                    
                }else if let url = model?.url{
                    self?.delegate?.didGetResultStabilityMemes(with: url)
                }else{
                    self?.didUpdateText2ImageResult(nil, "Something went wrong, please try again.")
                }
            }else{
                self?.didUpdateText2ImageResult(nil, "Something went wrong, please try again.")
            }
        }, failure: {[weak self] err in
            self?.didUpdateText2ImageResult(nil, err.debugDescription)
        })
    }
    
    func createTextToImageAICutPro() {
        if !APIManager.shared().isInternetAvailable{
            self.didUpdateText2ImageResult(nil, "Internet is not available, Please try again.")
            return
        }
        
        let style = self.currentAIStyle.styleDetail().2.trim()
        let searchedText = self.promptText.trim() + " " + style
        debugPrint("promtText ", searchedText)
        debugPrint("style ", style)
        
//        let parameterType = ParameterType.text2imageAsync(prompt: searchedText, style: nil, imageUrl: nil)
//        debugPrint("parameterType ",parameterType.params)
        let stability = EndpointItem.stability(searchedText) //EndpointItem.text2imageAsync, parameterType.params
        _ = APIManager.shared().call(type: stability, params: nil) { [weak self](model: CutOutModel?) in
            debugPrint(model ?? "")
            if let sucess = model?.success{
                if sucess, let url = model?.url{
                    self?.delegate?.didGetResultStabilityMemes(with: url)
                }else{
                    self?.didUpdateText2ImageResult(nil, "Something went wrong, please try again.")
                }
            }else{
                self?.didUpdateText2ImageResult(nil, "Something went wrong, please try again.")
            }
            
           /* if let taskId = model?.data {
                self?.text2ImageTaskId = taskId
                self?.scheduledTimerWithTimeInterval()
                CustomLoader.sharedInstance.show(withMessage: "Creating...\(0)%")

//                self.createTextToImageResult(with: taskId, complition: complition)
            }else if let message = model?.msg {
                debugPrint("error message ",message)
                self?.didUpdateText2ImageResult(nil, message)
            }*/
        } _: { [weak self] (error) in
            debugPrint(error ?? "")
            self?.didUpdateText2ImageResult(nil, error.debugDescription)
        }
    }
    
    func scheduledTimerWithTimeInterval(){
       // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
       text2ImageAPITimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
   }

   @objc func updateCounting(){
       NSLog("counting..")
       self.createTextToImageResult(with: self.text2ImageTaskId)
   }

    
    func createTextToImageResult(with taskId: Int) {
        _ = APIManager.shared().call(type: EndpointItem.text2imageResultAsync(taskId), success: { [weak self] (model: Text2ImageResultBase?) in
            debugPrint(model ?? "")
            if let dataModel = model?.data {
                if dataModel.status == 0 {
                    if let percentage = dataModel.percentage{
                        CustomLoader.sharedInstance.show(withMessage: "Creating...\(percentage)%")

//                        Helper.dispatchMain {
//                            SwiftLoader.show(title: "Creating...\(percentage)%", animated: true)
//                        }
                    }
                   /* if dataModel.percentage ?? 100 < 100{
                        self.createTextToImageResult(with: taskId, complition: complition)
                    }else{
//                        complition(nil,"Something went wrong, please try again.")
                        self?.delegate?.didDoneText2ImageResult(nil, "Something went wrong, please try again.")
                    }*/
                }else if dataModel.status == 1{
                    self?.didUpdateText2ImageResult(dataModel, nil)
                    
                }else if dataModel.status == 2{
//                    complition(nil,"Something went wrong, please try again.")
                    self?.didUpdateText2ImageResult(nil, "Something went wrong, please try again.")
                }
            }else if let message = model?.msg {
//                complition(nil,message)
                self?.didUpdateText2ImageResult(nil, message)
            }
        }, { [weak self] (error) in
            debugPrint(error ?? "")
//            complition(nil,error.debugDescription)
            self?.didUpdateText2ImageResult(nil, error.debugDescription)

        })
    }
    
    private func didUpdateText2ImageResult(_ model: Text2ImageResultDataModel?,_ message:String?){
        self.invalidateText2ImageTimer()
        self.delegate?.didDoneText2ImageResult(model, message)
    }
    
    private func invalidateText2ImageTimer(){
        text2ImageAPITimer?.invalidate()
        text2ImageAPITimer = nil
    }
}
/*extension SaveShareMediaViewModel{
    
    //MARK: Methods
    func postImageToInstagram(instaImage: UIImage) {
        UIImageWriteToSavedPhotosAlbum(Iimage!, self, #selector(saveImage(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func saveImage(_ instaImage: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            print(error ?? "")
        }
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if let lastAsset = fetchResult.firstObject {
            
            let url = URL(string: "instagram://library?LocalIdentifier=\(lastAsset.localIdentifier)")!
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                
                UIAlertController.alert(title: "instagram is not installed", message: "please install instagram for sharing", viewController: self)
            }
            
        }
    }
}*/

extension SaveShareMediaViewModel{
    
//    var numberOfItems: Int{
//        return shareMediaOptions.count
//    }
//    
//    func mediaAtIndex(index: Int) -> SocialMediaType{
//        return shareMediaOptions[index]
//    }
//    
    func didSelectStyleAtIndex(index: Int) {
        
//        currentSelectedStyle = AIArtDataModel.cutProStyles[index]
    }
    
    //Share To whatsApp

    fileprivate func shareImageViaWhatsapp(image: UIImage, onView: UIView) {
        
        //            JGLoader.shared.loader.dismiss()
        
        //        SVProgressHUD.dismiss()
        
        /*  spinner.hideIndicator()
         
         let urlWhats = "whatsapp://app"
         
         if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed) {
         
         if let whatsappURL = URL(string: urlString) {
         
         if UIApplication.shared.canOpenURL(whatsappURL as URL) {
         
         guard let imageData = image.pngData() else { debugPrint("Cannot convert image to data!"); return }
         
         let tempFile = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents/whatsAppTmp.wai")
         
         do {
         
         try imageData.write(to: tempFile, options: .atomic)
         
         self.documentInteractionController = UIDocumentInteractionController(url: tempFile)
         
         self.documentInteractionController.uti = "net.whatsapp.image"
         
         self.documentInteractionController.presentOpenInMenu(from: CGRect.zero, in: onView, animated: true)
         
         
         
         } catch {
         
         return
         
         }
         
         } else {
         
         
         
         CustomAlertView.sheared.openAlertViewOnlyOk(inSuperView: self.view, message: "Cannot open Whatsapp, be sure Whatsapp is installed on your device.")
         
         CustomAlertView.sheared.SaveAction = {
         
         CustomAlertView.sheared.closeWithAnimation()
         
         
         
         }
         
         }
         
         }
         
         }*/
        
    }
}
