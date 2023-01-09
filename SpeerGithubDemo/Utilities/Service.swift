//
//  Service.swift
//  SpeerGithubDemo
//
//  Created by Prashant Ghimire on 2023-01-06.
//

import Foundation
import Alamofire
import SVProgressHUD
protocol Repository {
    func perform(request: URLRequest, completion: @escaping (Swift.Result<Data, Error>) -> Void)
    func performWithAlamofire(request: URLRequest, completion: @escaping (Swift.Result<Data, Error>) -> Void)
}

final class Service: Repository {
    init(
        session: URLSession = URLSession.shared
    ) {
        self.session = session
    }

    private let session: URLSession

    func perform(request: URLRequest, completion: @escaping (Swift.Result<Data, Error>) -> Void) {
        guard githubToken != "" else {
//            result = .failure(error)
            return
        }
        var injectedRequest = request
//        injectedRequest.setValue("Accept", forHTTPHeaderField: "application/vnd.github+json")
//        injectedRequest.setValue("Content-Type", forHTTPHeaderField: "application/json; charset=utf-8")
//        injectedRequest.setValue("X-GitHub-Api-Version", forHTTPHeaderField: "2022-11-28")
//        injectedRequest.setValue("Authorization", forHTTPHeaderField: "bearer \(githubToken)")
        session.dataTask(with: injectedRequest) { data, _, error in
            if let letDebugPrintForData = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: letDebugPrintForData, options: [])
                    print("#############RESPONSEJSON\(json)#############")
                } catch {
                    print("#############RESPONSEERROR#############")
                }
            }
            var result: Swift.Result<Data, Error> = .failure( NSError(domain: "Unknown", code: 000, userInfo: nil))
            if let error = error {
                ProgressHud.showInfoWithMessage(message: "Please try again later")
                result = .failure(error)
            }
            else if let data = data {
                result = .success(data)
            }
            DispatchQueue.main.async {
                completion(result)
            }
        }
        .resume()
    }
    func performWithAlamofire(request: URLRequest, completion: @escaping (Swift.Result<Data, Error>) -> Void) {
        var injectedRequest = request
                injectedRequest.setValue("Authorization", forHTTPHeaderField: "bearer \(githubToken)")
//        AF.request(injectedRequest).responseData { response in
//            var result: Swift.Result<Data, Error> = .failure(
//                NSError(domain: "Unknown", code: 000, userInfo: nil)
//            )
//            switch response.result {
//            case .success(let data):
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: [])
//                    print("#############RESPONSEJSON\(json)#############")
//                } catch {
//                    print("#############RESPONSEERROR#############")
//                }
//                result = .success(data)
//            case .failure(let error):
//                result = .failure(error)
//            }
//            DispatchQueue.main.async {
//                completion(result)
//            }
//        }
    }
}
class ProgressHud {
  class func showProgressHUD() {
    SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom)
    SVProgressHUD.setForegroundColor (UIColor.black)
    SVProgressHUD.setBackgroundColor (UIColor.clear)
    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
    SVProgressHUD.setRingNoTextRadius(20)
    SVProgressHUD.setRingThickness(3)
    SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.flat)
    SVProgressHUD.show()
  }
  class func hideProgressHUD() {
    SVProgressHUD.dismiss()
  }
  class func showInfoWithMessage(message: String?, completionHandler: (() -> Void)? = nil) {
    DispatchQueue.main.async {
      SVProgressHUD.setBackgroundColor(UIColor.black)
      SVProgressHUD.setForegroundColor (UIColor.white)
      SVProgressHUD.showInfo(withStatus: message)
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      SVProgressHUD.dismiss()
      completionHandler?()
    }
  }
}

