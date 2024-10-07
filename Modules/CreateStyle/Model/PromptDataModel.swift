//
//  PromptDataModel.swift
//  DreamAI
//
//  Created by iApp on 24/11/22.
//

import Foundation

struct PromptDataModel: Codable{
    let id : Int
    let prompt : String
    let timeStamp : Double

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case prompt = "prompt"
        case timeStamp = "timeStamp"
    }
    
   /* init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        prompt = try values.decodeIfPresent(String.self, forKey: .prompt)
        timeStamp = try values.decodeIfPresent(Double.self, forKey: .timeStamp)
    }*/
    
   
}


