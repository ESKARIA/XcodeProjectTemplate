//___FILEHEADER___

import UIKit

class BasePresenter {

    init() {
       
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
