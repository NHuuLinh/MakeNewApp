//
//  NewEnity.swift
//  Newsapp
//
//  Created by LinhMAC on 26/08/2023.
//

import Foundation
import Foundation
import ObjectMapper

struct NewsEntity: Decodable {
    var image: String?
    var id: String?
    var title: String?
    var created_at: String?
    var author: AuthorNewsEntity?
}
struct AuthorNewsEntity: Decodable {
    var id: String?
    var name: String?
    var username: String?
    var avatar: String?
}
struct ArrayResponse<T: Decodable>: Decodable {
    var data: [T]?
    var page: Int?
    var pageSize: Int?
}
