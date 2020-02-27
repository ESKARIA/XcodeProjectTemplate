//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import UIKit
import DevHelper
import KRProgressHUD
            
class BaseViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !AppUsagePermission.isAsked() {
            AppUsagePermission.displayAlert(viewController: self)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }

        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.isTranslucent = true

        self.setNeedsStatusBarAppearanceUpdate()
        self.view.backgroundColor = .white

        let contentImage = UIImageView(image: ThemeManager.currentTheme().backgroundImage)
        self.view.addSubview(contentImage)
        contentImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(showTestFlightError(_:)), name: NSNotification.Name.updateNeeded, object: nil)
    }

    @objc private func showTestFlightError(_ notification: Notification) {
        self.hideLoading()

        guard let serverText = notification.object as? String else { return }

        self.showOkAlertController(title: "Внимание!", message: serverText) {
            print("ok did tapped")
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func setTitleAndImage(title: String, imageName: String, tag: Int) {
        self.title = title
        let tabImage = UIImage(named: imageName)
        self.tabBarItem = UITabBarItem(title: title, image: tabImage, tag: tag)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    func showAlert(title: String?, message: String?, buttons: [UIAlertAction]) {
        self.showAlertController(style: .alert) {
            $0.title = title
            $0.message = message
            for button in buttons {
                $0.addAction(button)
            }
        }
    }

    func showAlertController(style: UIAlertController.Style, setupBlock: (UIAlertController) -> Void) {

        let alertController: UIAlertController = UIAlertController(title: "Ошибка", message: nil, preferredStyle: style)
//        alertController.view.tintColor = ThemeManager.currentTheme().mainColor
        setupBlock(alertController)

        if alertController.actions.count < 1 {
            fatalError("No actions provided in alert controller")
        }

        self.present(alertController, animated: true, completion: nil)
    }

    public func showOkAlertController(title: String?, message: String?, callback: (() -> Void)? = nil) {
        self.showAlertController(style: .alert) {
            $0.title = title
            $0.message = message
            let action = UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                if callback != nil {
                    callback!()
                }
            })
            $0.addAction(action)
        }
    }

    public func showNotYetRealizedAlert() {
        self.showAlertController(style: .alert) {
            $0.title = "This function is not realized"
            $0.message = "Соррри"
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            $0.addAction(action)
        }
    }

    public func showLoading(message: String?) {
        if let message = message {
            KRProgressHUD.show(withMessage: message)
        } else {
            KRProgressHUD.show()
        }
    }

    public func hideLoading() {
        KRProgressHUD.dismiss()
    }

    // MARK: - Bar button items
    open func makeLeftBarButtonItems() {
        let backImage = UIImage(named: "backIcon")
        let backBarButtonItem = UIBarButtonItem.item(icon: backImage, target: self, action: #selector(popBack(from:)), accessibilityName: "BackBarButtonItem")
        self.navigationItem.setLeftBarButton(backBarButtonItem, animated: false)
    }

    open func makeRightBarButtonItems() {

    }

    @objc func popBack(from: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func setRightBarButtonItems(_ items: [DHBarButtonItem]) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.items(items)
    }

}
