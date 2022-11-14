//
//  ViewModel.swift
//  RxSwift + Alamofire
//
//  Created by 권성우 on 2022/11/14.
//

import Foundation

class ViewModel {
    struct State {
        var todos: [TodoListDto] = []
        var photos: [PhotoListDto] = []
    }
}
