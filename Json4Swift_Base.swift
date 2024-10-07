/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation

struct CutOutModel : Codable {
	let code : Int?
	let data : Int?
	let msg : String?
	let time : Int?
    let success: Bool?
    let url: String?
    let error: String?

    var images : [StabilityImages]?

	enum CodingKeys: String, CodingKey {

		case code = "code"
		case data = "data"
		case msg = "msg"
		case time = "time"
        case success = "success"
        case url = "url"
        case images = "images"
        case error

	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		code = try values.decodeIfPresent(Int.self, forKey: .code)
		data = try values.decodeIfPresent(Int.self, forKey: .data)
		msg = try values.decodeIfPresent(String.self, forKey: .msg)
		time = try values.decodeIfPresent(Int.self, forKey: .time)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        error = try values.decodeIfPresent(String.self, forKey: .error)
        images = try values.decodeIfPresent([StabilityImages].self, forKey: .images)
	}

}


struct TextWithImageModel: Codable {
    let success: Bool
    let url: String
}


struct StabilityImages : Codable {
    let url : String?
    let date : Int?
    let data : StabilityImageData?

    enum CodingKeys: String, CodingKey {

        case url = "url"
        case date = "date"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        date = try values.decodeIfPresent(Int.self, forKey: .date)
        data = try values.decodeIfPresent(StabilityImageData.self, forKey: .data)
    }

}

struct StabilityImageData : Codable {
    let height : String?
    let width : String?
    let cfgScale : String?
    let samples : String?
    let seed : String?
    let engine: String?
    let sampler: String?
    let steps: String?
    let prompt : String?

    enum CodingKeys: String, CodingKey {

        case height = "height"
        case width = "width"
        case cfgScale = "cfg_scale"
        case samples = "samples"
        case seed = "seed"
        case engine = "engine"
        case sampler = "sampler"
        case steps = "steps"
        case prompt = "prompt"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        height = try values.decodeIfPresent(String.self, forKey: .height)
        width = try values.decodeIfPresent(String.self, forKey: .width)
        cfgScale = try values.decodeIfPresent(String.self, forKey: .cfgScale)
        samples = try values.decodeIfPresent(String.self, forKey: .samples)
        seed = try values.decodeIfPresent(String.self, forKey: .seed)
        engine = try values.decodeIfPresent(String.self, forKey: .engine)
        sampler = try values.decodeIfPresent(String.self, forKey: .sampler)
        steps = try values.decodeIfPresent(String.self, forKey: .steps)
        prompt = try values.decodeIfPresent(String.self, forKey: .prompt)

    }

}
