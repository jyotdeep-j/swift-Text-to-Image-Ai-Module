
import Foundation
struct Text2ImageResultBase : Codable {
	let code : Int?
	let data : Text2ImageResultDataModel?
	let msg : String?
	let time : Int?

	enum CodingKeys: String, CodingKey {

		case code = "code"
		case data = "data"
		case msg = "msg"
		case time = "time"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		code = try values.decodeIfPresent(Int.self, forKey: .code)
		data = try values.decodeIfPresent(Text2ImageResultDataModel.self, forKey: .data)
		msg = try values.decodeIfPresent(String.self, forKey: .msg)
		time = try values.decodeIfPresent(Int.self, forKey: .time)
	}

}
