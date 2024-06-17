//
//  MonitorViewController.swift
//  Pods
//
//  Created by zixun on 16/12/27.
//
//

import Foundation

public class MonitorController: UIViewController {
    
    private var containerView = MonitorContainerView()
    
    /// 顶部高度
    public let TopHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height + 44
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.view.backgroundColor = UIColor.niceBlack()
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.containerView.frame = self.view.bounds
        self.containerView.frame.origin.y = TopHeight
    }
    
     func setupUI() {
         if let nav = self.navigationController {
             nav.title = "性能监控"
//             nav.navigationBar.addNavRightButtons(buttons: [.text(title: "开关")]) { result in
//                EyesManager.shared.isShowFPS = !EyesManager.shared.isShowFPS
//            }
             let button = UIButton()
             button.frame = CGRect(x: UIScreen.main.bounds.width - 44, y: 0, width: 44, height: 44)
             button.setTitle("开关", for: .normal)
             button.setTitleColor(UIColor.black, for: .normal)
             nav.navigationBar.addSubview(button)
             button.addTarget(self, action: #selector(touchOpenOrClose), for: .touchUpInside)
         }
        
        self.view.addSubview(self.containerView)
        self.containerView.delegateContainer = self;
    }
    @objc func touchOpenOrClose(){
        EyesManager.shared.isShowFPS = !EyesManager.shared.isShowFPS
    }
}

extension MonitorController: MonitorContainerViewDelegate {
    func container(container:MonitorContainerView, didSelectedType type:MonitorSystemType) {
        
//        UIAlertView.quickTip(message: "detail and historical data coming soon")
        
        if type.hasDetail {
            //TODO: add detail
            
        }
    }
}

