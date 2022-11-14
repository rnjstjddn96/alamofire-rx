//
//  TodoService.swift
//  RxSwift + Alamofire
//
//  Created by 권성우 on 2022/11/14.
//

import Foundation
import RxSwift

protocol TodoServiceInterface {
    var service: NetworkService { get }
    func getTodoLists() -> Observable<TodoListDto>
}

class TodoService: TodoServiceInterface {
    var service = NetworkService()
    
    func getTodoLists() -> Observable<TodoListDto> {
        return service.requestPlain(APIs.TODOS)
    }
}

