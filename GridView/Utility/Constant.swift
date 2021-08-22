

import Foundation

let base_url = "https://api.nasa.gov/planetary/"

let get_photos = base_url + "apod?api_key=DEMO_KEY&count=42"


enum PlaceholderImage:String {
    case photo   = "DummyI"
}
