//___FILEHEADER___

import UIKit
import KRProgressHUD

enum LoadingResult {
    case success
    case none
    case error
    case warning
    case info
}

class BaseViewController: UIViewController {
    
    public func showBaseOkAlertController(title: String?, message: String?, callback: (() -> Void)? = nil) {
        self.showBaseAlertController(style: .alert) {
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
    
    func showBaseAlertController(style: UIAlertController.Style, setupBlock: (UIAlertController) -> Void) {

        let alertController: UIAlertController = UIAlertController(title: "Ошибка", message: nil, preferredStyle: style)
        setupBlock(alertController)

        if alertController.actions.count < 1 {
            fatalError("No actions provided in alert controller")
        }

        self.present(alertController, animated: true, completion: nil)
    }
    

    func showBaseLoading(with message: String?, completion: (() -> Void)? = nil) {
        KRProgressHUD.show(withMessage: message, completion: completion)
    }
    
    func hideBaseLoading(with result: LoadingResult = .none, message: String? = nil) {
        switch result {
        case .success:
            KRProgressHUD.showSuccess(withMessage: message)
        case .none:
            KRProgressHUD.dismiss()
        case .error:
            KRProgressHUD.showError(withMessage: message)
        case .warning:
            KRProgressHUD.showWarning(withMessage: message)
        case .info:
            KRProgressHUD.showInfo(withMessage: message)
        }
    }
}
