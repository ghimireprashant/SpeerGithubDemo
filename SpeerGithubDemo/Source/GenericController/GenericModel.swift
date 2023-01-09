//
//  GenericModel.swift
//  SpeerGithubDemo
//
//  Created by Prashant Ghimire on 2023-01-08.
//

import Foundation
import ObjectMapper
class GenericResponseModel {
    /// This function is for fetching repo, follower or following data
    /// - Parameters:
    ///   - type: Type of controller
    ///   - gitUser: Github user
    ///   - pageNo: Page no
    ///   - loadMore: weather its load more, according to this user will see hud
    ///   - completion: return result
    class func getData(type: ViewControllerType, gitUser: String, pageNo: String, loadMore: Bool, completion: @escaping (Result<[GenericModel]?, UserError>) -> Void) {
        if !loadMore {
            ProgressHud.showProgressHUD()
        }
        let endpoint = Endpoint.genericType(type: type, userName: gitUser, pageNo: pageNo)
        guard let url = endpoint.url else {
            completion(.failure(.invalidURL))
            return
        }
        let request = URLRequest(url: url)
        Service().perform(request: request) { result in
            ProgressHud.hideProgressHUD()
            switch result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let result = Mapper<GenericModel>().mapArray(JSONObject: json)
                    completion(.success(result))
                } catch {
                    completion(.failure(.invalidJson))
                }
            case .failure:
                completion(.failure(.general))
            }
        }
    }
}

class GenericModel: Mappable {
    var name, artwork, fullDescription, language, url: String?
    var id: Int?
    var attributedString: NSAttributedString? // design view according to data
    required init?(map: ObjectMapper.Map) {
    }
    
    func mapping(map: ObjectMapper.Map) {
        id <- map["id"]
        name <- map ["name"]
        artwork <- map["avatar_url"]
        fullDescription <- map["description"]
        url <- map["html_url"]
        if name == nil {
            name <- map["login"]
        }
        let mutableAttribute = AttributedString()

        mutableAttribute.text("Name: ", attributes: [.textColor(UIColor.gray)]).text("\(name ?? "")")
        if let descrition = fullDescription  {
            mutableAttribute.text("\nDescription: ", attributes: [.textColor(UIColor.gray)]).text(" \(descrition)")
        }
        
        language <- map["language"]
        
        if let language = language {
            mutableAttribute.text("\nLanguage: ", attributes: [.textColor(UIColor.gray)]).text("\(language)")
        }
        
        self.attributedString = mutableAttribute.attributedString
    }
}
