//
//  PromptHistoryViewModel.swift
//  DreamAI
//
//  Created by iApp on 24/11/22.
//

import Foundation

class PromptHistoryViewModel: NSObject{
    
    private var promptHistoryDataModelArr: [PromptDataModel]?
    
    
    
    override init() {
        super.init()
        self.promptHistoryDataModelArr = LocalDataManager.shared.promptHistoryData
    }
    
    
    
}

extension PromptHistoryViewModel{
    
    var numberOfItem: Int{
        return promptHistoryDataModelArr?.count ?? 0
    }
    
    func promptHistoryData(atIndex index: Int) -> PromptDataModel?{
        if numberOfItem > index{
            return promptHistoryDataModelArr?[index] ?? nil
        }
        return nil
    }
    
    func clearAllPromptHistoryFromLocal(complition: (_:Bool) -> Void){
        LocalDataManager.shared.clearAllPromptHistoryFromLocal { [weak self] (isHistoryClear) in
            self?.promptHistoryDataModelArr?.removeAll()
           complition(true)
        }
    }

    
}
