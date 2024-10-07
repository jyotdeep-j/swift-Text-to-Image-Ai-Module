//
//	TryTheseIdeasData.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import RealmSwift


/*class Todo: Object, Codable {
    
   @Persisted(primaryKey: true) var _id: ObjectId
   @Persisted var name: String = ""
   @Persisted var status: String = ""
   @Persisted var ownerId: String?
    
    enum CodingKeys: String, CodingKey {
//        case id = "id"
        case name = "name"
        case status = "status"
        case ownerId = "ownerId"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        status = try values.decodeIfPresent(String.self, forKey: .status) ?? ""
        ownerId = try values.decodeIfPresent(String.self, forKey: .ownerId) ?? ""
//        _id = try values.decodeIfPresent(ObjectId.self, forKey: .id) ?? ""
    }
  /* convenience init(name: String, ownerId: String) {
       self.init()
       self.name = name
       self.ownerId = ownerId
   }*/
}*/


class TryTheseIdeasData : Object, Codable {
    
    @Persisted(primaryKey: true) var _id: ObjectId
//    @Persisted var data : [PromptStabilityData]?
    @Persisted var data = List<PromptStabilityData>()


	enum CodingKeys: String, CodingKey {
		case data = "data"
	}
    required override init() {
        super.init()
    }
    required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(List<PromptStabilityData>.self, forKey: .data) ?? List<PromptStabilityData>()
	}


}
class PromptStabilityData :Object, Codable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var cfgScale : Int = 7
    @Persisted var egine : String = "Stable Diffusion v1.5"
    @Persisted var height : Int = 512
    @Persisted var width : Int = 512
//    @Persisted var id : Int = 0
    @Persisted var propmt : String?
    @Persisted var resultImages = List<ResultImage>()
    @Persisted var sampler : String = "Automatic"
    @Persisted var steps : Int = 30
    @Persisted var isDraft : Bool = false


    enum CodingKeys: String, CodingKey {
        case cfgScale = "cfgScale"
        case egine = "egine"
        case height = "height"
//        case id = "id"
        case propmt = "propmt"
        case resultImages = "resultImages"
        case sampler = "sampler"
        case steps = "steps"
        case width = "width"
        case isDraft

    }
    required override init() {
        super.init()
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cfgScale = try values.decodeIfPresent(Int.self, forKey: .cfgScale) ?? 7
        egine = try values.decodeIfPresent(String.self, forKey: .egine) ?? "Stable Diffusion v1.5"
        height = try values.decodeIfPresent(Int.self, forKey: .height) ?? 512
//        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        propmt = try values.decodeIfPresent(String.self, forKey: .propmt)
        resultImages = try values.decodeIfPresent(List<ResultImage>.self, forKey: .resultImages) ?? List<ResultImage>()
        sampler = try values.decodeIfPresent(String.self, forKey: .sampler) ?? "Automatic"
        steps = try values.decodeIfPresent(Int.self, forKey: .steps) ?? 30
        width = try values.decodeIfPresent(Int.self, forKey: .width) ?? 512
        isDraft = try values.decodeIfPresent(Bool.self, forKey: .isDraft) ?? false

    }
    
    
    
    convenience init(withStabilityData stabilityData: CutOutModel){
        self.init()
        
        if let data = stabilityData.images?.first?.data{
            self.egine = data.engine ?? "Stable Diffusion v1.5"
            self.height = Int(data.height ?? "512") ?? 512
            self.width = Int(data.width ?? "512") ?? 512
            self.cfgScale = Int(data.cfgScale ?? "7") ?? 7
            self.propmt = data.prompt ?? ""
            self.sampler = data.sampler ?? "Automatic"
            self.steps = Int(data.steps ?? "30") ?? 30
        }
        
        if let stabilityImages = stabilityData.images{
            for images in stabilityImages{
                let resultImages = ResultImage(withStabilityImage: images)
                self.resultImages.append(resultImages)
            }
        }
    }
}


class ResultImage :Object, Codable {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var imageName : String?
    @Persisted var seed : Int = 34725

    @Persisted var url : String?
    @Persisted var date : Int?
    
    enum CodingKeys: String, CodingKey {
        case imageName = "imageName"
        case seed = "seed"
        case url = "url"
        case date = "date"
    }
    
    required override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        imageName = try values.decodeIfPresent(String.self, forKey: .imageName)
        seed = try values.decodeIfPresent(Int.self, forKey: .seed) ?? 34725
        url = try values.decodeIfPresent(String.self, forKey: .url)
        date = try values.decodeIfPresent(Int.self, forKey: .date) ?? 34725
    }

    
    convenience init(withStabilityImage stabilityImage: StabilityImages){
        self.init()
        self.url = stabilityImage.url
        self.date = stabilityImage.date
    }

}
