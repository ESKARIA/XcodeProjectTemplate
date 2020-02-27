//___FILEHEADER___

import UIKit

protocol DIResolverComponents { }

class DIResolver { }

// MARK: - DIResolverComponents

extension DIResolver: DIResolverComponents {
    
    func rootViewController() -> RootViewController {
        let controller = RootViewController(resolver: self)
        return controller
    }
    
}
