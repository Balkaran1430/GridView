

import Foundation
import ObjectMapper


struct PhotosM : Mappable {
   
    var copyright : String?
    var date : String?
    var explanation: String?
    var media_type: String?
    var service_version: String?
    var title: String?
    var url: String?
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        copyright <- map["copyright"]
        date <- map["date"]
        explanation <- map["explanation"]
        media_type <- map["media_type"]
        service_version <- map["service_version"]
        title <- map["title"]
        url <- map["url"]
    }

}

