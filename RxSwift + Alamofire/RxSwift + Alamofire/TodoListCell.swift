//
//  TodoCell.swift
//  RxSwift + Alamofire
//
//  Created by 권성우 on 2022/11/15.
//

import Foundation
import UIKit

class TodoListCell: UITableViewCell {
    static let id: String = "TodoListCell"
    let lblTodoTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .label
        
        return label
    }()
    
    let lblCompletion: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .label
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.addSubview(lblTodoTitle)
        self.addSubview(lblCompletion)
    }
    
    private func setConstraints() {
        lblTodoTitle.snp.makeConstraints { [weak self] create in
            guard let self = self else { return }
            create.centerY.equalToSuperview()
            create.top.left.equalToSuperview()
                .offset(20)
            create.bottom.equalToSuperview()
                .offset(-20)
            create.right.lessThanOrEqualTo(self.lblCompletion.snp.left)
        }
        
        lblCompletion.snp.makeConstraints { [weak self] create in
            guard let _ = self else { return }
            create.right.equalToSuperview()
                .offset(-20)
            create.centerY.equalToSuperview()
            
        }
    }
}
