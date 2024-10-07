//
//  MyProjectViewModel.swift
//  DreamAI
//
//  Created by iApp on 20/01/23.
//

import Foundation
class MyProjectViewModel {
    
    var promptStabilityData = [PromptStabilityData]() {
        didSet {
            reloadModelView?()
        }
    }
    var reloadModelView: (() -> Void)?
    
    // FETCH PROMPT DRAFT DATA FROM DB
    
    final func fetchPromptDataDB(){
        
        if !DBManager.isDbAvailable { return }
        guard let storedPromtData = DBManager.shared.localDB?.objects(PromptStabilityData.self) else {return}
        self.promptStabilityData = storedPromtData.filter({$0.isDraft == true})
    }
}

extension MyProjectViewModel{
    var numberOfItem: Int{
        return promptStabilityData.count
    }
    
    func myProject(atIndex index: Int)  -> PromptStabilityData?{
        if numberOfItem > index{
            return self.promptStabilityData[index]
        }
        return nil
    }
}


