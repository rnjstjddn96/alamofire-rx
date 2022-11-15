//
//  ViewController.swift
//  RxSwift + Alamofire
//
//  Created by 권성우 on 2022/11/10.
//

import UIKit
import RxSwift
import SnapKit
import RxCocoa

class ViewController: UIViewController {
    var todoListView: UITableView = {
        let tableView = UITableView()
        tableView.register(TodoListCell.self, forCellReuseIdentifier: TodoListCell.id)
        return tableView
    }()
    
    var todoViewModel: TodoViewModelInterface
    var disposeBag = DisposeBag()
    
    init(todoViewModel: TodoViewModelInterface) {
        self.todoViewModel = todoViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.bind()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configure()
        todoViewModel.getTodos()
    }
}

extension ViewController {
    private func configure() {
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(todoListView)
        self.todoListView.snp.makeConstraints { [weak self] create in
            guard let self = self else { return }
            create.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

extension ViewController {
    private func bind() {
        self.todoViewModel
            .todoSubject
            .asObservable()
            .bind(to: self.todoListView.rx.items) { tableView, index, item -> UITableViewCell in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: TodoListCell.id
                ) as? TodoListCell else {
                    return UITableViewCell()
                }
                cell.lblTodoTitle.text = item.title
                cell.lblCompletion.text = item.completed ? "✔" : " "
                return cell
            }
            .disposed(by: disposeBag)
    
    }
}
