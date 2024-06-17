//
//  ConsoleViewController.swift
//  Pods
//
//  Created by zixun on 16/12/27.
//
//

import Foundation
import SnapKit
public class ConsoleController: UIViewController {
    
    /// 顶部高度
    public let TopHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height + 44
    
    private var dataSource: RecordTableViewDataSource = RecordTableViewDataSource()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        autolayoutViews()
    }
    
    func setupUI() {
        
//        self.navigationBar.title = "Crash 日志"
//        self.navigationBar.addNavRightButtons(buttons: [.text(title: "删除")]) { [weak self] result in
//            self?.dataSource.cleanRecord()
//            self?.recordTableView.reloadData()
//            // 清空数据库
//            NNDBManager.share.deleteFromDb(fromTable: EyesManager.tabString)
//        }
        if let nav = self.navigationController {
            nav.title = "Crash 日志"
//             nav.navigationBar.addNavRightButtons(buttons: [.text(title: "开关")]) { result in
//                EyesManager.shared.isShowFPS = !EyesManager.shared.isShowFPS
//            }
            let button = UIButton()
            button.frame = CGRect(x: UIScreen.main.bounds.width - 44, y: 0, width: 44, height: 44)
            button.setTitle("开关", for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            nav.navigationBar.addSubview(button)
            button.addTarget(self, action: #selector(deleteCrashLog), for: .touchUpInside)
        }
        
        self.view.backgroundColor = UIColor.niceBlack()
        self.view.addSubview(self.recordTableView)
    }
    @objc func deleteCrashLog() {
        self.dataSource.cleanRecord()
        self.recordTableView.reloadData()
        // 清空数据库
        NNDBManager.share.deleteFromDb(fromTable: EyesManager.tabString)
    }
    func autolayoutViews() {
        self.recordTableView.snp.makeConstraints {(make) in
            make.edges.equalTo(UIEdgeInsets(top: TopHeight, left: 0, bottom: 0, right: 0))
        }
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.dataSource.loadData()
        self.recordTableView.reloadData()
    }
    
    private lazy var recordTableView: RecordTableView = { [unowned self] in
        let new = RecordTableView()
        new.delegate = self.dataSource
        new.dataSource = self.dataSource
        return new
    }()
}

