//
//  TodoViewModel.swift
//  RxSwift + Alamofire
//
//  Created by 권성우 on 2022/11/14.
//

import Foundation
import RxSwift

protocol TodoViewModelInterface {
    var disposeBag: DisposeBag { get }
    var todoService: TodoServiceInterface { get }
    
    var todoSubject: BehaviorSubject<[TodoListDto]> { get }
    var error: Error? { get }
    
    func getTodos()
}

class TodoViewModel: TodoViewModelInterface {
    var disposeBag: DisposeBag
    var todoService: TodoServiceInterface
    
    var todoSubject: BehaviorSubject<[TodoListDto]>
    var error: Error?

    init(disposeBag: DisposeBag = DisposeBag(),
         todoService: TodoServiceInterface,
         initialTodos: [TodoListDto],
         error: Error? = nil) {
        self.disposeBag = disposeBag
        self.todoService = todoService
        self.todoSubject = BehaviorSubject<[TodoListDto]>(value: initialTodos)
        self.error = error
    }
    
    func getTodos() {
        todoService
            .getTodoLists()
            .withUnretained(self)
            .subscribe(onNext: { owner, todos in
                owner.todoSubject.onNext(todos)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.error = error
            })
            .disposed(by: disposeBag)
    }
}
