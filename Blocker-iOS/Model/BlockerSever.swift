//
//  BlockerSever.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/08/18.
//

import Foundation
import UIKit

class BlockerServer {
    private var refreshToken:String = ""
    private var accessToken:String = ""
    private var userData:UserData = UserData(url: nil, name: "", email: "")
    private let host:String = ""
    static let shared = BlockerServer()
    
    func setUserData(_ inputData: UserData) {
        self.userData = inputData
    }
    
    func setToken(_ refreshToken: String?, _ accessToken: String?) {
        if refreshToken != nil {
            self.refreshToken = refreshToken!
        }
        if accessToken != nil {
            self.accessToken = accessToken!
        }
    }
    
    func reissueToken() {
        var request = URLRequest(url: URL(string: "\(self.host)/users/reissue-token")!)
        request.httpMethod = "Get"
        // header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.refreshToken)", forHTTPHeaderField: "Cookie")
        
        URLSession(configuration: .default).dataTask(with: request) {(data, response, error) in
            // error 체크
            if let e = error {
                print(e.localizedDescription)
                return
            }
            // response의 상태코드 따라 분기 처리
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    // 200 -> 토큰 재발급 성공
                } else if response.statusCode == 401 {
                    // 401 -> 리프레쉬 토큰 만료, 재로그인 시도 해야함
                } else {
                    
                }
            }
        }.resume()
       
    }
    
    func convertRefreshToken(_ input:String ) -> String {
        var res = ""
        var temp = input.split(separator: " ").first!.map { $0 }
        _ = temp.popLast()
        res = String(temp)
        return res
    }
    
    func login(_ user: UserData, completionHandler: @escaping (Bool) -> Void) {
        // 구글 로그인 통해서 얻은 profile 정보로 로그인 시도
        var request = URLRequest(url: URL(string: "\(self.host)/users/login")!)
        request.httpMethod = "Post"
        
        // header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // body
        let body = [
            "email": "\(user.email)",
            "name": "\(user.name)",
            "picture": "\(user.url!)"
        ] as [String: Any]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Error creating JSON data")
        }
        
        URLSession(configuration: .default).dataTask(with: request) {(data, response, error) in
            // error 체크
            if let e = error {
                print(e.localizedDescription)
                return
            }
            
            // response의 상태코드 따라 분기 처리
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    // 200 -> 로그인
                    let refreshToken = self.convertRefreshToken(response.value(forHTTPHeaderField: "Cookie")!)
                    let accessToken = response.value(forHTTPHeaderField: "Authorization")!
                    self.setToken(refreshToken, accessToken)
                    print(accessToken)
                    completionHandler(true)
                } else if response.statusCode == 201 {
                    // 201 -> 전자 서명 작성 뷰로 이동
                    // 전자 서명 작성 후 전자 서명 등록 API 호출해서 회원가입 진행
                    return
                }
            }
        }.resume()
    }
    
    func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
      let data = NSMutableData()

      data.appendString("--\(boundary)\r\n")
      data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
      data.appendString("Content-Type: \(mimeType)\r\n\r\n")
      data.append(fileData)
      data.appendString("\r\n")

      return data as Data
    }

    
    func UpdateSignature(_ image: UIImage, completionHandler: @escaping (Bool) -> Void) {
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: URL(string: "\(self.host)/users/signature")!)
        request.httpMethod = "Post"

        // header
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.accessToken)", forHTTPHeaderField: "Authorization")

        // body -> 이미지 파일
        let httpBody = NSMutableData()
        httpBody.append(convertFileData(fieldName: "signature",
                                        fileName: "\(self.userData.email)_signature.png",
                                        mimeType: "image/png",
                                        fileData: image.pngData()!,
                                        using: boundary))
        httpBody.appendString("--\(boundary)--")
        request.httpBody = httpBody as Data
        
        URLSession(configuration: .default).dataTask(with: request) {(data, response, error) in
            // error 체크
            if let e = error {
                print(e.localizedDescription)
                return
            }

            // response의 상태코드 따라 분기 처리
            if let response = response as? HTTPURLResponse {
                print(response)
                if response.statusCode == 200 {
                    completionHandler(true)
                } else if response.statusCode == 401 {
                    
                } else if response.statusCode == 403 {

                } else if response.statusCode == 500 {

                }
            }

        }.resume()
    }
}

extension NSMutableData {
  func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}
