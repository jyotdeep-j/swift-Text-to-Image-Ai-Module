//
//  FullMediaPreviewViewModel.swift
//  DreamAI
//
//  Created by iApp on 04/01/23.
//

import UIKit

class FullMediaPreviewViewModel: NSObject {

    weak var delegate: AIArtGeneratorDelegate?

    public var stabilityResponseModel: CutOutModel?
    public var stabilityAIData: StabilityAiData = StabilityAiData()
    public var currentAIStyle: AIStyle = .none

    public var currentSelectedMedia: Int = 0
   
}

extension FullMediaPreviewViewModel{
    var numberOfItem: Int{
        self.stabilityResponseModel?.images?.count ?? 0
    }
    
    func imageData(atIndex index: Int) -> StabilityImages?{
        if numberOfItem > index{
            return self.stabilityResponseModel?.images?[index]
        }
        return nil
    }
    
    func didSelect(atIndex index: Int){
        self.currentSelectedMedia  = index
    }
}


extension FullMediaPreviewViewModel{
    
    func createTextToImageAICutProWithImage() {
        
        if !APIManager.shared().isInternetAvailable{
            self.didUpdateText2ImageResult(nil, "Internet is not available, Please try again.")
            return
        }
        
        let image: UIImage? = self.stabilityAIData.inputImage?.resized(toPixels: 1024)
        
        let style = self.currentAIStyle.styleDetail().prompt.trim()
        let searchedText = self.stabilityAIData.prompt?.trim() ?? "" + " " + style
        
        let pendingImages =  8 - self.stabilityAIData.numberOfImages
        self.stabilityAIData.numberOfImages = pendingImages
        let parameterType = ParameterType.textWithImage(prompt: searchedText, stabilityData: self.stabilityAIData)
        debugPrint("parameterType ",parameterType.params)
        
        let textWithImage = EndpointItem.textWithImage(prompt: searchedText)
        _ =  APIManager.shared().uploadImageWithText(type: textWithImage,params: parameterType.params, imageToUpload: image, uploadProgress: { progress in
            print(progress)
        }, success: { [weak self] (model: CutOutModel?) in
//            guard self = self else {return}
            if let _ = model?.success{
                if let response = model{
                    if let newImages = response.images{
                        self?.stabilityResponseModel?.images?.append(contentsOf: newImages)
                    }
                    if let stableData = self?.stabilityResponseModel{
                        self?.delegate?.didGetStabilityResult(result: stableData)
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
    private func didUpdateText2ImageResult(_ model: Text2ImageResultDataModel?,_ message:String?){
        self.delegate?.didDoneText2ImageResult(model, message)
    }
}
