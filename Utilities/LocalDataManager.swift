//
//  LocalDataManager.swift
//  DreamAI
//
//  Created by iApp on 24/11/22.
//

import Foundation

class LocalDataManager {
    
    class var shared: LocalDataManager {
        struct Singleton {
            static let instance = LocalDataManager()
        }
        return Singleton.instance
    }
    
    
    //MARK: Promot History Save, Update and Retrive
    
    
    func addPromptInHistory(prompt: String){
        let timeStamp = Helper.sharedInstance.currentTimeStamp
        let id = Int(timeStamp)
        let newPrompt = PromptDataModel(id: id, prompt: prompt, timeStamp: timeStamp)
        
        if UserDefaults.standard.object(forKey: "promptHistoryData") != nil {
            let data = UserDefaults.standard.value(forKey: "promptHistoryData") as! Data
            var promptHistory = try? PropertyListDecoder().decode([PromptDataModel].self, from: data)
            promptHistory?.insert(newPrompt, at: 0)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(promptHistory), forKey: "promptHistoryData")
        }else{
            UserDefaults.standard.set(try? PropertyListEncoder().encode([newPrompt]), forKey: "promptHistoryData")
        }
    }
    
    func clearAllPromptHistoryFromLocal(complition: (_:Bool) -> Void){
        if UserDefaults.standard.object(forKey: "promptHistoryData") != nil {
            UserDefaults.standard.set(nil, forKey: "promptHistoryData")
        }
        complition(true)
    }
    
    var promptHistoryData: [PromptDataModel]? {
        get {
            if UserDefaults.standard.object(forKey: "promptHistoryData") != nil {
                let data = UserDefaults.standard.value(forKey: "promptHistoryData") as! Data
                let domainSchema = try? PropertyListDecoder().decode([PromptDataModel].self, from: data)
                
                return domainSchema!
            }
            
            return nil
        }
//        set {
//            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: "promptHistoryData")
//        }
    }

    
}
