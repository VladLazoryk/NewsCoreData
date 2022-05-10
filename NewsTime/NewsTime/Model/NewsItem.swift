import Foundation

struct NewsItem: Decodable {
    var description: String
    var title: String
    var url: String
    var urlToImage: String
    var publishedAt: String
    
    enum CodingKeys: String, CodingKey{
        case description, title
        case url
        case urlToImage, publishedAt
        
    }
}
struct Articles: Decodable {
    let articles: [NewsItem]
}
