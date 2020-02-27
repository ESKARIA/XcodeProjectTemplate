//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import Foundation

class NetworkRequestProvider {

    let networkWrapper: NetworkRequestWrapperProtocol
    let tokenRefresher: NetworkTokenRefresherProtocol?
    let accountManager: AccountManagerProtocol

    init(networkWrapper: NetworkRequestWrapperProtocol, tokenRefresher: NetworkTokenRefresherProtocol?, accountManager: AccountManagerProtocol) {
        self.networkWrapper = networkWrapper
        self.tokenRefresher = tokenRefresher
        self.accountManager = accountManager
    }

    internal func runRequest(_ request: NetworkRequest, progressResult: ((Double) -> Void)?, completion: @escaping(_ statusCode: Int, _ requestData: Data?, _ error: NetworkError?) -> Void) {

        let baseUrl = self.accountManager.getBaseUrl()
        var tokenString: String?
        let token = accountManager.getUserToken()
        if !token.isEmpty {
            tokenString = "Bearer " + accountManager.getUserToken()
        }

        let s = self
        self.networkWrapper.runRequest(request, baseURL: baseUrl, authToken: tokenString, progressResult: progressResult) { (statusCode, data, error) in

            guard let error = error else {
                completion(statusCode, data, nil)
                return
            }

            switch error.type {
            case .unauthorized:
                if let tokenRefresher = s.tokenRefresher {
                    tokenRefresher.refreshAuthToken(completion: { (error) in
                        if let error = error {
                            s.accountManager.logOut()
                            completion(statusCode, data, error)
                            return
                        }

                        s.networkWrapper.runRequest(request, baseURL: baseUrl, authToken: tokenString, progressResult: progressResult, completion: completion)
                    })
                    return
                }
            default:
                completion(statusCode, nil, error)
                break
            }
        }
    }
}
