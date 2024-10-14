//
//  APMNavigationBar.swift
//  LeigodAPM
//
//  Created by xyk on 2024/10/14.
//

import UIKit
import SnapKit

public enum NNNavBarHandleType: Int {
    case left1
    case left2
    case right1
    case right2
}

public enum NNBarButtonType: Equatable {
    
    case text(title: String)
    case image(image: UIImage?)
    
    static public func == (
        lhs: NNBarButtonType,
        rhs: NNBarButtonType)
        -> Bool
    {
        switch (lhs, rhs) {
        case (.text, .text):
            return true
        case (.image, .image):
            return true
        default:
            return false
        }
    }
}

public typealias NNNavBarHandle = (_ result: NNNavBarHandleType) -> Void

fileprivate let k_item_width  = CGFloat(44)
fileprivate let k_item_height = CGFloat(44)
fileprivate let k_leftTag     = 800
fileprivate let k_rightTag    = 900
fileprivate let NavBarHeight: CGFloat = 44.0
public let NNStatusBarHeight: CGFloat = k_Height_statusBar()
public let NNTopHeight:CGFloat = NNStatusBarHeight + NavBarHeight
public let shadowOffsetY      = CGFloat(10)

///获取状态栏高度
func k_Height_statusBar() -> CGFloat {
    var statusBarHeight: CGFloat = 0;
    if #available(iOS 13.0, *) {
        let scene = UIApplication.shared.connectedScenes.first;
        guard let windowScene = scene as? UIWindowScene else {return 0};
        guard let statusBarManager = windowScene.statusBarManager else {return 0};
        statusBarHeight = statusBarManager.statusBarFrame.height;
    } else {
        statusBarHeight = UIApplication.shared.statusBarFrame.height;
    }
    return statusBarHeight;
}

open class NNBaseNavigationBar: UIView {
    
    public var navigationBgView = UIView()
    
    public var leftNavBarHandle: NNNavBarHandle?
    
    public var rightNavBarHandle: NNNavBarHandle?
    
    private var titleLabel = UILabel()
    
    private var line = UIImageView()
    
    /// 屏幕宽度
    private var screenW: CGFloat = UIScreen.main.bounds.size.width
    /// 屏幕高度
    private var screenH: CGFloat = UIScreen.main.bounds.size.height
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        navigationBgView = UIView(frame: CGRect(x: 0, y: 0, width: screenW, height: NNTopHeight))
//        navigationBgView.backgroundColor = UIColor(nnhexString: "F5F5F5")
        navigationBgView.backgroundColor = UIColor.white
        self.addSubview(navigationBgView)
//        
//        line = UIImageView(frame: CGRect(x: 0, y: NNTopHeight, w: screenW, h: shadowOffsetY))
//        line.image = RGInternalMethod.getImage("导航栏_底部_阴影")
//        line.isHidden = !showBottomline
//        navigationBgView.addSubview(line)
        
        titleLabel.textAlignment = .center
        titleLabel.font = FONT_MEDIUM(16)
        titleLabel.textColor = UIColor(nnhex: 0x212121)

        navigationBgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
        }
    }
    private func FONT_MEDIUM(_ size:CGFloat) ->UIFont {
        if let font = UIFont(name: "PingFangSC-Medium", size: size) {
            return font
        }
        else{
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    private func FONT_REGULAR(_ size:CGFloat) ->UIFont {
        if let font = UIFont(name: "PingFangSC-Regular", size: size) {
            return font
        }
        else{
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 属性
    
    /**导航栏下面阴影**/
    public var showBottomline = false {
        didSet {
            line.isHidden = !showBottomline
        }
    }
    
    /**标题**/
    public var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    /**标题颜色**/
    public var titleColor: UIColor? {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    
    /**背景颜色**/
    public var bgColor: UIColor = .white {
        didSet {
            navigationBgView.backgroundColor = bgColor
        }
    }
    
    /**按钮左margain**/
    public var leadingLeftMargain: CGFloat = 0.0 {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    /**按钮右margain**/
    public var leadingRightMargain: CGFloat = 10.0 {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    /**隐藏左边按钮**/
    public var hideNavLeftButton: Bool = false {
        didSet {
            if let leftButton1 = navigationBgView.viewWithTag(k_leftTag) {
                leftButton1.isHidden = hideNavLeftButton
            }
            if let leftButton2 = navigationBgView.viewWithTag(k_leftTag + 1) {
                leftButton2.isHidden = hideNavLeftButton
            }
        }
    }
    
    /**隐藏右边按钮**/
    public var hideNavRightButton: Bool = false {
        didSet {
            if let rightButton1 = navigationBgView.viewWithTag(k_rightTag) {
                rightButton1.isHidden = hideNavRightButton
            }
            if let rightButton2 = navigationBgView.viewWithTag(k_rightTag + 1) {
                rightButton2.isHidden = hideNavRightButton
            }
        }
    }
    
    /**移除按钮**/
    private func removeButtons() {
        if let leftButton1 = navigationBgView.viewWithTag(k_leftTag) {
            leftButton1.removeFromSuperview()
        }
        if let leftButton2 = navigationBgView.viewWithTag(k_leftTag + 1) {
            leftButton2.removeFromSuperview()
        }
        
        if let rightButton1 = navigationBgView.viewWithTag(k_rightTag) {
            rightButton1.removeFromSuperview()
        }
        if let rightButton2 = navigationBgView.viewWithTag(k_rightTag + 1) {
            rightButton2.removeFromSuperview()
        }
    }
    
    // MARK: - method
    
    public func configTitleLabel(title: String,
                                 font: CGFloat = 18,
                                 textColor: UIColor = UIColor(nnhex: 0x000000)) {
        titleLabel.text = title
        titleLabel.font = FONT_MEDIUM(font)
        titleLabel.textColor = textColor
    }
    
    // MARK: - left
    
    /*** buttons 最多不能超过2个 */
    public func addNavLeftButtons(buttons: [NNBarButtonType], actions: @escaping NNNavBarHandle) {

        navigationBgView.bringSubviewToFront(line)
        leftNavBarHandle = actions
        var leftMargain = 0.0
        leftMargain = leadingLeftMargain
        for (index, item) in buttons.enumerated() {
            
            let button = UIButton()
            button.tag = k_leftTag + index
            button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
            navigationBgView.addSubview(button)
            
            switch item {
            case .image(let image):
                button.setImage(image, for: .normal)
                button.snp.makeConstraints { make in
                    make.left.equalTo(leftMargain)
                    make.bottom.equalTo(0)
                    make.size.equalTo(CGSize(width: k_item_width, height: k_item_height))
                }
                leftMargain += k_item_width
            case .text(let title):
                button.setTitle(title, for: .normal)
                button.sizeToFit()
                button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
                button.titleLabel?.font = FONT_REGULAR(14)
                button.setTitleColor(UIColor(nnhex: 0x757575), for: .normal)
                button.snp.makeConstraints { make in
                    make.left.equalTo(leftMargain)
                    make.height.equalTo(k_item_height)
                    make.bottom.equalTo(0)
                }
                leftMargain += button.width
            }
        }
    }
    
    // MARK: - right
    
    /*** buttons 最多不能超过2个 */
    public func addNavRightButtons(buttons: [NNBarButtonType], actions: @escaping NNNavBarHandle) {
       
        navigationBgView.bringSubviewToFront(line)
        rightNavBarHandle = actions
        var rightMargain = 0.0
        rightMargain = leadingRightMargain
        for (index, item) in buttons.enumerated() {
            let button = UIButton()
            button.tag = k_rightTag + index
            button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
            navigationBgView.addSubview(button)
            switch item {
            case .image(let image):
                button.setImage(image, for: .normal)
                button.snp.makeConstraints { make in
                    make.right.equalTo(-rightMargain)
                    make.bottom.equalTo(0)
                    make.size.equalTo(CGSize(width: k_item_width, height: k_item_height))
                }
                rightMargain += k_item_width
            case .text(let title):
                button.setTitle(title, for: .normal)
                button.sizeToFit()
                button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
                button.titleLabel?.font = FONT_REGULAR(14)
                button.setTitleColor(UIColor(nnhex: 0x757575), for: .normal)
                button.snp.makeConstraints { make in
                    make.right.equalTo(-rightMargain)
                    make.height.equalTo(k_item_height)
                    make.bottom.equalTo(0)
                }
                rightMargain += button.width
            }
        }
    }
    
    @objc func buttonClick(sender:UIButton){
        switch sender.tag {
        case k_leftTag:
            leftNavBarHandle?(.left1)
            break
        case k_leftTag + 1:
            leftNavBarHandle?(.left2)
            break
        case k_rightTag:
            rightNavBarHandle?(.right1)
            break
        case k_rightTag + 1:
            rightNavBarHandle?(.right2)
            break
        default:
            break
        }
    }
}



