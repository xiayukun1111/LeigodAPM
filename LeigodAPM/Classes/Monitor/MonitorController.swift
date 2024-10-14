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
    public var navigationBar: NNBaseNavigationBar = NNBaseNavigationBar()
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
         setUpNavBar()
         self.navigationBar.title = "性能监控"
         self.navigationBar.addNavRightButtons(buttons: [.text(title: "开关")]) { [weak self] result in
             EyesManager.shared.isShowFPS = !EyesManager.shared.isShowFPS
         }
//         if let nav = self.navigationController {
//             nav.title = "性能监控"
////             nav.navigationBar.addNavRightButtons(buttons: [.text(title: "开关")]) { result in
////                EyesManager.shared.isShowFPS = !EyesManager.shared.isShowFPS
////            }
//             let button = UIButton()
//             button.frame = CGRect(x: UIScreen.main.bounds.width - 44, y: 0, width: 44, height: 44)
//             button.setTitle("开关", for: .normal)
//             button.setTitleColor(UIColor.black, for: .normal)
//             nav.navigationBar.addSubview(button)
//             button.addTarget(self, action: #selector(touchOpenOrClose), for: .touchUpInside)
//         }
        
        self.view.addSubview(self.containerView)
        self.containerView.delegateContainer = self;
    }
    private func setUpNavBar(){
        self.view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(TopHeight)
        }
//        navigationBar.hideNavLeftButton = isFirstOfNavigationController()
        addLeftNav()
    }
    public func addLeftNav() {
//        if let count = self.navigationController?.viewControllers.count, count > 1 {
        navigationBar.addNavLeftButtons(buttons: [.image(image: NNInternalMethod.getImage("导航栏_返回_黑色"))]) { [weak self] result in
                if result == .left1 {
//                    self?.navBack()
                    self?.navigationController?.popViewController(animated: true)
                }
            }
//        }
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

