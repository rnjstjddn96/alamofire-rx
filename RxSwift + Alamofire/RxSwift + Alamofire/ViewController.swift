//
//  ViewController.swift
//  RxSwift + Alamofire
//
//  Created by 권성우 on 2022/11/10.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    var viewModel: ViewModel?
    var disposeBag = DisposeBag()
    
    init(viewModel: ViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure()
        getTodos()
    }
}

extension ViewController {
    private func configure() {
        self.view.backgroundColor = .systemBackground
    }
    
    private func getTodos() {
        let service = TodoService()
        service
            .getTodoLists()
            .subscribe(onNext: { todos in
                print("todos from remote: \(todos)")
            },onError: { error in
                print(error.localizedDescription)
            })
            .disposed(by: self.disposeBag)
    }
}

