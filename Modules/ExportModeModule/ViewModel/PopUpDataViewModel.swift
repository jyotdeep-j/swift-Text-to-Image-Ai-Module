//
//  PopUpDataViewModel.swift
//  DreamAI
//
//  Created by iApp on 22/12/22.
//

import UIKit

struct ExpertModeAttributeModel{
    let title: String
    let description: String
    let minimumValue: Float
    let maximumValue: Float
    let isSliderWithSteps: Bool
}

enum PopUpListType{
    case engine//(AIArtDataModel.AIStabileEngine)
    case sampler//(AIArtDataModel.SamplerEngine)
    case steps//(Int)
    case cfgScale//(Int)
    case imageSelection
}

protocol PopUpDataDelegate: AnyObject {
    func didSelectStableEngine(_ stableEngine: AIArtDataModel.AIStabileEngine)
    func didChangeSteps(type: PopUpListType,steps: Int, event: UITouch.Phase)
    func didSelectSamplerEngine(_ samplerEngine: AIArtDataModel.SamplerEngine)
    func popUpListControllerControllerDidDismiss()
}

protocol ImageSelectionPopUpDelegate: AnyObject{
    func removeSelectedImage()
    func replaceSelectedImage()
}

/*extension PopUpDataDelegate{
    func didChangeSteps(steps: Int) {}
}*/

class PopUpDataViewModel: NSObject {
    
    public var popUpListType: PopUpListType = .engine//(.diffusion_v1_5)

    private var stabilityEngineList:[AIArtDataModel.AIStabileEngine] =  AIArtDataModel.AIStabileEngine.allCases
    
    var currentStabileEngine: AIArtDataModel.AIStabileEngine = .diffusion_v1_5
    
    private var samplerEngineLists: [AIArtDataModel.SamplerEngine] = AIArtDataModel.SamplerEngine.allCases
    
    public var currentSamplerEngine: AIArtDataModel.SamplerEngine = .Automatic
    
    public var stepsValue: Int = 0
    public var cfgScaleValue: Int = 0
    lazy var stepsModel = ExpertModeAttributeModel(title: "Steps", description: "How many steps to spend generating \n(diffusing) your image.", minimumValue: 10, maximumValue: 150,isSliderWithSteps: false)
    
    lazy var cfgScaleModel = ExpertModeAttributeModel(title: "CFG Scale", description: "Cfg scale adjusts how much the image will be like you're prompt. Higher values keep your image closer to your prompt.", minimumValue: 0, maximumValue: 20,isSliderWithSteps: true)
    
    
    override init() {
        super.init()
    }
    
}

extension PopUpDataViewModel{
    
    var numberOfEngine: Int{
        switch popUpListType {
        case .sampler:
            return samplerEngineLists.count
        default:
           return stabilityEngineList.count
        }
    }
    
    func stableEngine(atIndex index: Int) -> AIArtDataModel.AIStabileEngine{
        return self.stabilityEngineList[index]
    }
    
    func didSelectStabilityEngine(atIndex index: Int){
        currentStabileEngine = self.stabilityEngineList[index]
    }
    var numberOfSetp: Int{
        switch popUpListType {
        case .cfgScale:
            return 20
        default:
            return 0
        }
    }
    
    
    var preferredContentSize: CGSize{
        switch popUpListType {
        case .engine:
            return CGSize(width: 329, height: 343)
        case .sampler:
            return CGSize(width: 329, height: 460)
        case .steps:
            return CGSize(width: 329, height: 150)
        case .cfgScale:
            return CGSize(width: 329, height: 160)
        case .imageSelection:
            return CGSize(width: 253, height: 70)
        }
    }
    
    /*var shouldShowList: Bool{
        return self.popUpListType == .engine || self.popUpListType == .sampler
    }*/
    
    func isSelected(atIndex index: Int) -> Bool{
        switch popUpListType {
        case .sampler:
            let engine = self.sampleEngine(atIndex: index)
            return engine == currentSamplerEngine
        default:
            let stabilityEngine = self.stableEngine(atIndex: index)
            return stabilityEngine == self.currentStabileEngine
        }
    }
    
    func popUpViewWithSlider() -> ExpertModeAttributeModel?{
        switch self.popUpListType {
        case .steps:
            return stepsModel
        case .cfgScale:
            return cfgScaleModel
        default:
            break
        }
        return nil
    }
    
    func sampleEngine(atIndex index: Int) -> AIArtDataModel.SamplerEngine{
        self.samplerEngineLists[index]
    }
    
    func didSelectSamplerEngine(atIndex index: Int){
        self.currentSamplerEngine = self.sampleEngine(atIndex: index)
    }
    
    
}
