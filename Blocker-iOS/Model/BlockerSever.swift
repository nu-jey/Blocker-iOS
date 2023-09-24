//
//  BlockerSever.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/08/18.
//

import Foundation
import UIKit

class BlockerServer {
    var userSignInState:SignInState = .signedOut
    private var refreshToken:String = ""
    private var accessToken:String = ""
    private var userData:UserData = UserData(url: nil, name: "", email: "")
    static let shared = BlockerServer()
    private let host:String = Bundle.main.host!
    
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
}

// 로그인 & 토큰
extension BlockerServer {
    func reissueToken(completionHandler: @escaping (Bool, Int) -> Void) {
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
                    completionHandler(true, 200)
                } else if response.statusCode == 401 {
                    // 401 -> 리프레쉬 토큰 만료, 재로그인 시도 해야함
                    self.userSignInState = .signedOut
                    completionHandler(false, 401)
                } else if response.statusCode == 403 {
                    completionHandler(false, 403)
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
    
    func login(_ user: UserData, completionHandler: @escaping (Bool, Int) -> Void) {
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
                    completionHandler(true, 200)
                } else if response.statusCode == 201 {
                    // 201 -> 전자 서명 작성 뷰로 이동
                    // 전자 서명 작성 후 전자 서명 등록 API 호출해서 회원가입 진행
                    completionHandler(true, 201)
                    return
                }
            }
        }.resume()
    }
    
    func signOut() {
        self.userData = UserData(url: nil, name: "", email: "")
        self.userSignInState = .signedOut
        self.refreshToken = ""
        self.accessToken = ""
    }
}

// 전자 서명
extension BlockerServer {
    func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
      let data = NSMutableData()

      data.appendString("--\(boundary)\r\n")
      data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
      data.appendString("Content-Type: \(mimeType)\r\n\r\n")
      data.append(fileData)
      data.appendString("\r\n")

      return data as Data
    }
    
    func updateSignature(_ image: UIImage, completionHandler: @escaping (Bool, Int) -> Void) {
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: URL(string: "\(self.host)/signatures")!)
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
            print(response)
            // error 체크
            if let e = error {
                print(e.localizedDescription)
                return
            }

            // response의 상태코드 따라 분기 처리
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    completionHandler(true, 200)
                    // 토큰 교체 ->
                } else if response.statusCode == 201 { // 파일 안 보냄
                    completionHandler(false, 204)
                } else if response.statusCode == 401 { // 토큰 만료
                    completionHandler(false, 401)
                } else if response.statusCode == 403 { // 전자서명 저장 실패
                    completionHandler(false, 403)
                } else if response.statusCode == 500 { // INTERNAL SERVER ERROR
                    completionHandler(false, 500)
                }
            }

        }.resume()
    }
}

// 게시판 & 게시글
extension BlockerServer {
    // 게시글 불러오기
    func getBoardData(_ size: Int, _ page: Int, completionHandler: @escaping (Bool, Int, [BoardResponseData]) -> Void) {
        var request = URLRequest(url: URL(string: "\(self.host)/boards?size=\(size)&page=\(page)")!)
        request.httpMethod = "Get"
        
        // header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            // error 체크
            if let e = error {
                print(e.localizedDescription)
                return
            }
            
            // response의 상태코드 따라 분기 처리
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    let res = try? JSONDecoder().decode([BoardResponseData].self, from: data!)
                    completionHandler(true, 200, res ?? [])
                } else if response.statusCode == 401 {
                    completionHandler(false, 401, [])
                } else if response.statusCode == 403 {
                    completionHandler(false, 403, [])
                }
            }
        }.resume()
    }
    
    // 게시글 조회하기
    func getPostData(_ boardId:Int, completionHandler: @escaping (Bool, Int, PostResponseData?) -> Void) {
        var request = URLRequest(url: URL(string: "\(self.host)/boards/\(boardId)")!)
        request.httpMethod = "Get"
        
        // header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            // error 체크
            if let e = error {
                print(e.localizedDescription)
                return
            }
            // response의 상태코드 따라 분기 처리
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    let res = try? JSONDecoder().decode(PostResponseData.self, from: data!)
                    print(response)
                    completionHandler(true, 200, res)
                } else if response.statusCode == 401 {
                    completionHandler(false, 401, nil)
                } else if response.statusCode == 403 {
                    completionHandler(false, 403, nil)
                }
            }
        }.resume()
    }
    
    // 북마크 등록
    func addBookmark(_ boardId:Int, completionHandler: @escaping (Bool, Int) -> Void) {
        var request = URLRequest(url: URL(string: "\(self.host)/bookmarks")!)
        request.httpMethod = "POST"
        
        // header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        // body
        let body = [
            "boardId": "\(boardId)"
        ] as [String: Any]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Error creating JSON data")
        }
        
        URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            // error 체크
            if let e = error {
                print(e.localizedDescription)
                return
            }
            // response의 상태코드 따라 분기 처리
            if let response = response as? HTTPURLResponse {
                print(response)
                if response.statusCode == 200 {
                    completionHandler(true, 200)
                } else if response.statusCode == 401 {
                    completionHandler(false, 401)
                } else if response.statusCode == 403 {
                    completionHandler(false, 403)
                } else if response.statusCode == 409 {
                    completionHandler(false, 409)
                }
            }
        }.resume()
        
        
    }
    
    // 북마크 삭제
    func deleteBookmark(_ boardId:Int, completionHandler: @escaping (Bool, Int) -> Void) {
        var request = URLRequest(url: URL(string: "\(self.host)/bookmarks/\(boardId)")!)
        request.httpMethod = "DELETE"
        
        // header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        
        URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            // error 체크
            if let e = error {
                print(e.localizedDescription)
                return
            }
            // response의 상태코드 따라 분기 처리
            if let response = response as? HTTPURLResponse {
                print(response)
                if response.statusCode == 200 {
                    completionHandler(true, 200)
                } else if response.statusCode == 401 {
                    completionHandler(false, 401)
                } else if response.statusCode == 403 {
                    completionHandler(false, 403)
                }
            }
        }.resume()
        
    }
    
    // 게시글 작성
    func writePost(_ post:Post, completionHandler: @escaping (Bool, Int) -> Void) {
        var request = URLRequest(url: URL(string: "\(self.host)/boards")!)
        request.httpMethod = "POST"
        
        // header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        // body
        let body = [
            "content": post.content,
            "title": post.title,
            "info": post.info ?? nil,
            "representImage": post.representImage ?? nil,
            "contractId": post.contractId,
            "images": post.images
        ] as [String: Any]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Error creating JSON data")
        }
        
        URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            // error 체크
            if let e = error {
                print(e.localizedDescription)
                return
            }
            
            // response의 상태코드 따라 분기 처리
            if let response = response as? HTTPURLResponse {
                print(response)
                if response.statusCode == 200 {
                    completionHandler(true, 200)
                } else if response.statusCode == 401 {
                    completionHandler(false, 401)
                } else if response.statusCode == 403 {
                    completionHandler(false, 403)
                }
            }
        }.resume()
    }
    
    // 게시글 삭제
    func deletePost(_ boardId:Int, completionHandler: @escaping (Bool, Int) -> Void) {
        var request = URLRequest(url: URL(string: "\(self.host)/boards/\(boardId)")!)
        request.httpMethod = "DELETE"
        
        // header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            // error 체크
            if let e = error {
                print(e.localizedDescription)
                return
            }
            // response의 상태코드 따라 분기 처리
            if let response = response as? HTTPURLResponse {
                print(response)
                if response.statusCode == 200 {
                    completionHandler(true, 200)
                } else if response.statusCode == 401 {
                    completionHandler(false, 401)
                } else if response.statusCode == 403 {
                    completionHandler(false, 403)
                } else if response.statusCode == 404 {
                    completionHandler(false, 404)
                }
            }
        }.resume()
    }
    
    // 게시글 수정
    func patchPost(_ post:EditedPost, _ boardId:Int, completionHandler: @escaping (Bool, Int) -> Void) {
        var request = URLRequest(url: URL(string: "\(self.host)/boards/\(boardId)")!)
        request.httpMethod = "PATCH"
        
        // header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        // body
        let body = [
            "title": "\(post.title)",
            "content": "\(post.content)",
            "info": "\(post.info ?? "")",
            "representImage": "\(post.representImage ?? "")",
            "contractId": "\(post.contractId)",
            "deleteImageIds": "\(convertListToString(post.deleteImageIds.map { String($0) }))",
            "addImageAddresses": "\(convertListToString(post.addImageAddresses))"
        ] as [String: Any]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Error creating JSON data")
        }
        
        URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            // error 체크
            if let e = error {
                print(e.localizedDescription)
                return
            }
            // response의 상태코드 따라 분기 처리
            if let response = response as? HTTPURLResponse {
                print(response)
                if response.statusCode == 200 {
                    completionHandler(true, 200)
                } else if response.statusCode == 401 {
                    completionHandler(false, 401)
                } else if response.statusCode == 403 {
                    completionHandler(false, 403)
                } else if response.statusCode == 404 {
                    completionHandler(false, 404)
                }
            }
        }.resume()
    }
    
    func convertListToString(_ list: [String]) -> String {
        var res = "["
        for item in list {
            res += item
            res += ","
        }
        _ = res.popLast()
        return res + "]"
    }
    
}

// 이미지 저장
extension BlockerServer {
    func saveImage(_ image:UIImage, completionHandler: @escaping (Bool, Int, String) -> Void) {
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: URL(string: "\(self.host)/images")!)
        request.httpMethod = "POST"

        // header
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.accessToken)", forHTTPHeaderField: "Authorization")

        // body -> 이미지 파일
        let httpBody = NSMutableData()
        httpBody.append(convertFileData(fieldName: "image",
                                        fileName: "\(image.hash).png",
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
                if response.statusCode == 201 {
                    let res = try? JSONDecoder().decode(SaveImageResponseData.self, from: data!)
                    completionHandler(true, 201, res?.address ?? "fail")
                } else if response.statusCode == 401 { // 토큰 만료
                    completionHandler(false, 401, "fail")
                } else if response.statusCode == 403 { // 전자서명 저장 실패
                    completionHandler(false, 403, "fail")
                }
            }
        }.resume()
    }
}

// 미체결 계약서
extension BlockerServer {
    func writeContract(_ title:String, _ content:String, completionHandler: @escaping (Bool, Int) -> Void) {
        var request = URLRequest(url: URL(string: "\(self.host)/contracts")!)
        request.httpMethod = "POST"
        
        // header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        // body
        let body = [
            "title": "\(title)",
            "content": "\(content)"
        ] as [String: Any]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Error creating JSON data")
        }
        
        URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            // error 체크
            if let e = error {
                print(e.localizedDescription)
                return
            }
            // response의 상태코드 따라 분기 처리
            if let response = response as? HTTPURLResponse {
                print(response)
                if response.statusCode == 200 {
                    completionHandler(true, 200)
                } else if response.statusCode == 401 {
                    completionHandler(false, 401)
                } else if response.statusCode == 403 {
                    completionHandler(false, 403)
                }
            }
        }.resume()
    }
    
    func patchContract(_ contract:Contract, completionHandler: @escaping (Bool, Int) -> Void) {
        var request = URLRequest(url: URL(string: "\(self.host)/contracts/\(contract.contractId)")!)
        request.httpMethod = "PATCH"
        
        // header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        
        // body
        let body = [
            "title": "\(contract.title)",
            "content": "\(contract.content)"
        ] as [String: Any]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Error creating JSON data")
        }
        
        URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            // error 체크
            if let e = error {
                print(e.localizedDescription)
                return
            }
            // response의 상태코드 따라 분기 처리
            if let response = response as? HTTPURLResponse {
                print(response)
                if response.statusCode == 200 {
                    completionHandler(true, 200)
                } else if response.statusCode == 401 {
                    completionHandler(false, 401)
                } else if response.statusCode == 403 {
                    completionHandler(false, 403)
                }
            }
        }.resume()
    }
    
    func deleteContract(_ contractId:Int, completionHandler: @escaping (Bool, Int) -> Void) {
        var request = URLRequest(url: URL(string: "\(self.host)/contracts/\(contractId)")!)
        request.httpMethod = "DELETE"
        
        // header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            // error 체크
            if let e = error {
                print(e.localizedDescription)
                return
            }
            // response의 상태코드 따라 분기 처리
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    completionHandler(true, 200)
                } else if response.statusCode == 401 {
                    completionHandler(false, 401)
                } else if response.statusCode == 403 {
                    completionHandler(false, 403)
                }
            }
        }.resume()
    }
    
    func getContractData(_ contractId:Int, completionHandler: @escaping (Bool, Int, ContractResponseData?) -> Void) {
        var request = URLRequest(url: URL(string: "\(self.host)/contracts/\(contractId)")!)
        request.httpMethod = "GET"
        
        // header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            // error 체크
            if let e = error {
                print(e.localizedDescription)
                return
            }
            // response의 상태코드 따라 분기 처리
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                     let res = try? JSONDecoder().decode(ContractResponseData.self, from: data!)
                    completionHandler(true, 200, res)
                } else if response.statusCode == 401 {
                    completionHandler(false, 401, nil)
                } else if response.statusCode == 403 {
                    completionHandler(false, 403, nil)
                }
            }
        }.resume()
    }
    
    func getContractListData(_ contractType:ContractType, completionHandler: @escaping (Bool, Int, [ContractResponseData]) -> Void) {
        var request = URLRequest(url: URL(string: "\(self.host)/contracts?state=NOT_CONCLUDED")!)
        request.httpMethod = "GET"
        
        // header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            // error 체크
            if let e = error {
                print(e.localizedDescription)
                return
            }
            // response의 상태코드 따라 분기 처리
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    let res = try? JSONDecoder().decode([ContractResponseData].self, from: data!)
                    completionHandler(true, 200, res ?? [])
                } else if response.statusCode == 401 {
                    completionHandler(false, 401, [])
                } else if response.statusCode == 403 {
                    completionHandler(false, 403, [])
                }
            }
        }.resume()
    }
}
