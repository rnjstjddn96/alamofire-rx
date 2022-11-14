//
//  Todos.swift
//  RxSwift + Alamofire
//
//  Created by 권성우 on 2022/11/14.
//

import Foundation
struct TodoListDto: Decodable {
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool
}
