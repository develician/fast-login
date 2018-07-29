//
//  JoinViewController.swift
//  FastLogin
//
//  Created by killi8n on 2018. 7. 29..
//  Copyright © 2018년 killi8n. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxDataSources

class JoinViewController: UIViewController {

    var disposeBag: DisposeBag = DisposeBag()
    
    var datasource: [JoinCategory] = [
        JoinCategory(name: "username"),
        JoinCategory(name: "password")
    ]
    
    lazy var dataSourceRelay: BehaviorRelay<[JoinCategory]> = {
        let relay = BehaviorRelay(value: self.datasource)
        return relay
    }()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.clear
        tv.register(JoinTableViewCell.self, forCellReuseIdentifier: "cellId")
        tv.tableFooterView = UIView()
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        self.title = "JOIN"
        
        let viewComponents = [tableView]
        viewComponents.forEach {
            view.addSubview($0)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0)
            make.left.equalTo(view.snp.left).offset(0)
            make.bottom.equalTo(view.snp.bottom).offset(0)
            make.right.equalTo(view.snp.right).offset(0)
        }
        bind()
    }

}

typealias CategorySectionModel = AnimatableSectionModel<String, JoinCategory>
typealias CategoryDataSource = RxTableViewSectionedAnimatedDataSource<CategorySectionModel>

extension JoinViewController {
    func createDataSource() -> CategoryDataSource {
       
        let dataSource = CategoryDataSource(configureCell: { (dataSource, tableView, indexPath, model) -> UITableViewCell in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! JoinTableViewCell
            
            cell.textLabel?.text = model.name
            switch indexPath.row {
            case 0:
                cell.detailTextLabel?.text = "fast"
            case 1:
                cell.detailTextLabel?.text = "campus"
            default:
                break
            }
            return cell
            }, titleForHeaderInSection: { (dataSource, index) -> String? in
                return "Use This Account"
        })
        
        return dataSource
    }
    
    func bind() {
        dataSourceRelay.map {
            models in
            [CategorySectionModel(model: "Section", items: models)]
        }.bind(to: tableView.rx.items(dataSource: createDataSource())).disposed(by: disposeBag)
    }
}
