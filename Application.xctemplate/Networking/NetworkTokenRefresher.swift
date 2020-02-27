//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import Foundation

class NetworkTokenRefresher: NetworkTokenRefresherProtocol {

    private var accountManager: AccountManagerProtocol!
    var networking: NetworkAuthtorizationProtocol!

    init(accountManager: AccountManagerProtocol) {
        self.accountManager = accountManager
    }

    func refreshAuthToken(completion: @escaping (NetworkError?) -> Void) {
        let error = NetworkErrorStruct(error: NSError(domain: "can do it", code: 10008, userInfo: nil))
        completion(error)
//        // TODO: - сделать реврештокен
    }
}
