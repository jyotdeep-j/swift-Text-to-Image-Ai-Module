//
//  AIArtGeneratorViewModel.swift
//  DreamAI
//
//  Created by Pritpal Singh on 08/11/22.
//

import Foundation
import UIKit

enum ListPreview{
    case grid
    case list
}

protocol AIArtGeneratorDelegate: AnyObject {
    func didDoneText2ImageResult(_ model: Text2ImageResultDataModel?,_ message:String?)
    func didGetResultStabilityMemes(with url: String)
    func didGetStabilityResult(result: CutOutModel)
}

struct StabilityAiData {
    var prompt: String?
    var width: Int = 512
    var height: Int = 512
    var aspectRatioSize: AIArtDataModel.AspectRatio = .square
    var steps: Int = 30
    var numberOfImages: Int = 2
    var cfgScale: Int = 7
    var inferenceEngineModel: AIArtDataModel.AIStabileEngine = .diffusion_v1_5
    var samplingEngine: AIArtDataModel.SamplerEngine = .Automatic
    var seed: Int64 = 0
    var inputImage: UIImage?
    var isExpertModeOn: Bool = false
}

class AIArtGeneratorViewModel:NSObject {
    
    static let totalNumberOfCharactersAllowedInPrompt: Int = 500

    var text2ImageAPITimer: Timer?

    weak var delegate: AIArtGeneratorDelegate?
    
    public var currentSelectedStyle: String = ""
    public var currentAIStyle: AIStyle = .none
    public var currentSelectedMostPopularPrompt: AIArtDataModel.MostPopularPrompt?
    public var currentListPreview: ListPreview = .grid
    
    public var isShowAdvancedOption: Bool = false
    public var promtText: String = ""
    
    
    private var text2ImageTaskId: Int = 0
    
    public var stabilityAIData: StabilityAiData = StabilityAiData()
    
    public var createStyleType: CreateStyleType = .new

    public var resetStabilityData: StabilityAiData{
        return StabilityAiData()
    }
    
    lazy private var promptIdeasForAIArt = AIArtDataModel.PromptIdeasForAIArt.allCases.shuffled()
    
    private var postPopularPromptArr = AIArtDataModel.MostPopularPrompt.allCases.shuffled()
    
//    public var stabilityEngine: AIArtDataModel.AIStabileEngine?
    
//    public var inputImage: UIImage?
    
//    private var promtIdeasData: TryTheseIdeasData?
    private var promtIdeasData = [PromptStabilityData]()
    var aiStyleArr: [AIStyle]{
        get{
            let array = AIStyle.allCases
            return array
        }
    }
    
    override init() {
        super.init()
        self.loadTryThesePromptDataFromJSON()
    }
 }

extension AIArtGeneratorViewModel{
    
   
    var totalCreditScore: String{
        return String(Helper.sharedInstance.pendingCreditScore)
    }
    
    var isDailyCreditLimitClaimed: Bool{
        return self.createStyleType == .edit ? true : Helper.bool(forKey: kUserDefault.isDailyCreditLimitClamed)
    }
    
    func addDailyLimitCredit(creditCount: Int = 5){
        let creditScore = Helper.value(forKey: kUserDefault.totalCreditAvailable) as? Int ?? 0
        let dailyNewLimit = creditScore + creditCount
        Helper.setValue(dailyNewLimit, forKey: kUserDefault.totalCreditAvailable)
        Helper.setBool(true, forKey: kUserDefault.isDailyCreditLimitClamed)
    }
}

extension AIArtGeneratorViewModel{
    private func loadTryThesePromptDataFromJSON(){
        self.loadPromptIdeasData { [weak self] (jsonResult) in
            if let resultData = jsonResult?.data{
                self?.promtIdeasData = resultData.shuffled()
            }
        }
    }
    
    var numberOfPromptIdeas: Int{
        promtIdeasData.count
    }
    
    func promptIdeaData(atIndex index: Int) -> PromptStabilityData?{
        if numberOfPromptIdeas > index{
            return promtIdeasData[index]
        }
        return nil
    }
    
    
}
extension AIArtGeneratorViewModel {
    
    var numberOfMostPopularPrompt: Int{
        postPopularPromptArr.count
    }
    
    func mostPopularPrompt(index: Int) -> AIArtDataModel.MostPopularPrompt{
        return postPopularPromptArr[index]
    }
    
    

    
    var currentPrompt: String{
        if self.isShowAdvancedOption{
            let style = self.currentAIStyle.styleDetail().prompt.trim()
            let searchedText = self.promtText.trim() + " " + style
            return searchedText
        }else{
            let searchedText = self.promtText.trim()
            return searchedText
        }
    }
    
    var numberOfStyles: Int{
        return aiStyleArr.count
    }
    
    func styleAtIndex(index: Int) -> AIStyle{
        return aiStyleArr[index]
    }
    
    var indexOfCurrentStyle: Int? {
        if let index = aiStyleArr.firstIndex(where: {$0 == self.currentAIStyle}){
            return index
        }
        return nil
    }
    
    func didSelectStyleAtIndex(index: Int){
        currentAIStyle = aiStyleArr[index]
//        currentSelectedStyle = currentAIStyle?.styleDetail().0 ?? ""
    }
    
    func didSelectStyle(style: AIStyle) -> Int?{
        if let index = aiStyleArr.firstIndex(where: {$0 == style}){
            currentAIStyle = aiStyleArr[index]
            return index
        }
        return nil
    }
    
    
    func isStyleSelected(atIndex index: Int) -> Bool{
        return currentAIStyle == aiStyleArr[index]
    }
    
    var numberOfIdeas: Int {
        return self.promptIdeasForAIArt.count
    }
    
    func ideasAtIndex(index: Int) -> AIArtDataModel.PromptIdeasForAIArt {
        return self.promptIdeasForAIArt[index]
    }
    
    func isOriginalPrompt(currentText: String) -> Bool{
        let curretStylePrompt = self.currentAIStyle.styleDetail().prompt
        
        if currentText == curretStylePrompt{
            return true
        }
        return false
    }
    
    func setPromptTextUptoLimit() -> String{
        let prompTextView = self.promtText //self.prompTextView.text
        let selecteStyle = self.currentAIStyle.styleDetail().prompt
        let allText = prompTextView + selecteStyle
        
        if allText.count > Self.totalNumberOfCharactersAllowedInPrompt{
            let trimmedText =  allText.truncate(to: Self.totalNumberOfCharactersAllowedInPrompt+1,ellipsis: false)
            return  trimmedText
        }
        return allText
    }
    
    
    func setMostPopularPromptWithLimit(index: Int) -> String{
//        let prompTextView = self.promtText
        let prompt = postPopularPromptArr[index]//.styleDetail().prompt
        currentSelectedMostPopularPrompt = prompt
        let selecteStyle =  prompt.styleDetail().prompt
        let allText = selecteStyle //prompTextView + selecteStyle
        
        if allText.count > Self.totalNumberOfCharactersAllowedInPrompt {
            let trimmedText =  allText.truncate(to: Self.totalNumberOfCharactersAllowedInPrompt+1,ellipsis: false)
            return  trimmedText
        }
        return allText
    }
    
    
    
    func isExceedTheLimit(with promptInTextView: String) -> Bool {
        return promptInTextView.count <= Self.totalNumberOfCharactersAllowedInPrompt
    }
    
    var countOfTotalNumberOfCharacters: String {
        return "\(self.promtText.count)/\(Self.totalNumberOfCharactersAllowedInPrompt)"
    }
    
}


extension AIArtGeneratorViewModel {
    
    
    func createTextToImageAICutPro() {
        
        if !APIManager.shared().isInternetAvailable{
            self.didUpdateText2ImageResult(nil, "Internet is not available, Please try again.")
            return
        }
        
        let style = self.currentAIStyle.styleDetail().prompt.trim()
        let searchedText = self.promtText.trim() + " " + style
        
        debugPrint("promtText ", searchedText)
        debugPrint("style ", style)
        
        let parameterType = ParameterType.text2imageAsync(prompt: searchedText, style: nil, imageUrl: nil)
        debugPrint("parameterType ",parameterType.params)

        let stability = EndpointItem.stability(searchedText) //EndpointItem.text2imageAsync, parameterType.params
        
        _ = APIManager.shared().call(type: stability , params: nil) {[weak self] (model: CutOutModel?) in
            debugPrint(model ?? "")
            if let sucess = model?.success{
                if sucess, let response = model{
                    self?.delegate?.didGetStabilityResult(result: response)
                } else if sucess, let url = model?.url{
                    self?.delegate?.didGetResultStabilityMemes(with: url)
                }else{
                    self?.didUpdateText2ImageResult(nil, "Something went wrong, please try again.")
                }
            }else{
                self?.didUpdateText2ImageResult(nil, "Something went wrong, please try again.")
            }
            /*else if let taskId = model?.data {
                self?.text2ImageTaskId = taskId
                self?.scheduledTimerWithTimeInterval()
                CustomLoader.sharedInstance.show(withMessage: "Creating...0%")

//                self.createTextToImageResult(with: taskId, complition: complition)
            }else if let message = model?.msg {
                debugPrint("error message ",message)
                self?.didUpdateText2ImageResult(nil, message)
//                complition(nil,message)
            }*/
        } _: { [weak self] (error) in
            debugPrint(error ?? "")
            self?.didUpdateText2ImageResult(nil, error.debugDescription)
//            complition(nil,error.debugDescription)
        }
    }
    
    
    
    func createTextToImageAICutProWithImage() {
        
        if !APIManager.shared().isInternetAvailable{
            self.didUpdateText2ImageResult(nil, "Internet is not available, Please try again.")
            return
        }
        
        let style = self.currentAIStyle.styleDetail().prompt.trim()
        let searchedText = self.promtText.trim() + " " + style
//        let engineName = self.stabilityAIData.engine().name ?? ""
//        let parameterType = ParameterType.textWithImage(prompt: searchedText, stableEngine: engineName)
        let parameterType = ParameterType.textWithImage(prompt: searchedText, stabilityData: self.stabilityAIData)
        debugPrint("parameterType ",parameterType.params)
        
        let resizeImage = self.stabilityAIData.inputImage?.resized(toPixels: 1024)
        let textWithImage = EndpointItem.textWithImage(prompt: searchedText)
        
        _ =  APIManager.shared().uploadImageWithText(type: textWithImage,params: parameterType.params, imageToUpload: resizeImage, uploadProgress: { progress in
            print(progress)
        }, success: { [weak self] (model: CutOutModel?) in
            if let _ = model?.success{
                if let response = model{
                    if (model?.success ?? false){
                        self?.delegate?.didGetStabilityResult(result: response)
                    }else{
                        self?.didUpdateText2ImageResult(nil, model?.error ?? "")

                    }
                } else if let url = model?.url{
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
    
    func scheduledTimerWithTimeInterval(){
       // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
       text2ImageAPITimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
   }

   @objc func updateCounting(){
       NSLog("counting..")
       self.createTextToImageResult(with: self.text2ImageTaskId)
//       self.createTextToImageResult(with: <#T##Int#>, complition: <#T##(Text2ImageResultDataModel?, String?) -> Void##(Text2ImageResultDataModel?, String?) -> Void##(_ model: Text2ImageResultDataModel?, _ message: String?) -> Void#>)
   }

    
    func createTextToImageResult(with taskId: Int) {
        
       
        _ = APIManager.shared().call(type: EndpointItem.text2imageResultAsync(taskId), success: { [weak self] (model: Text2ImageResultBase?) in
            debugPrint(model ?? "")
            if let dataModel = model?.data {
                if dataModel.status == 0 {
                    if let percentage = dataModel.percentage{
                        Helper.dispatchMain {
//                            SwiftLoader.show(title: "Creating...\(percentage)%", animated: true)
                            CustomLoader.sharedInstance.show(withMessage: "Creating...\(percentage)%")
                        }
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
    
    
   /* func dataToJSON(data: Data)  {
       do {
           let jsonDict =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
           debugPrint("jsonDict response",jsonDict)
       } catch let myJSONError {
           print("myJSONError", myJSONError)
       }
       
    }*/
   /* func jsonToData(json: Any) {
        do {
            let jsonDict = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
            debugPrint("jsonDict response",jsonDict)
        } catch let myJSONError {
            print("myJSONError", myJSONError)
        }
        
    }*/
}

extension AIArtGeneratorViewModel{
    
    func loadPromptIdeasData(onSuccess: @escaping (_ jsonResult:TryTheseIdeasData?) -> Void) {
//        var memeLayoutModels = [TryTheseIdeasData]()
        let jsonFileName = "TryThesePromptsData"
        if let url = Bundle.main.url(forResource: jsonFileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let promptIdeas = try decoder.decode(TryTheseIdeasData.self, from: data)
                print(promptIdeas)
                onSuccess(promptIdeas)
            } catch {
                print("error:\(error.localizedDescription)")
                onSuccess(nil)
            }
        }
//        onSuccess(memeLayoutModels)
    }
    
}
