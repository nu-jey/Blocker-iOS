//
//  BlockerSever.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/08/18.
//

import Foundation
import UIKit

enum ApiError:Error {
    case BADREQUEST
    case UNAUTHORIZATION
    case FORBIDDEN
    case NOTFOUND
}

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
    
    func getOwnData() -> UserResponseData {
        return UserResponseData(email: self.userData.email, name: self.userData.name, picture: "")
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
    
    func getSignature(completionHandler: @escaping (Result<SaveImageResponseData, ApiError>) -> Void) {
        var request = URLRequest(url: URL(string: "\(self.host)/signatures")!)
        request.httpMethod = "GET"
        // header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.accessToken)", forHTTPHeaderField: "Authorization")
        
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
                    let res = try? JSONDecoder().decode(SaveImageResponseData.self, from: data!)
                    completionHandler(.success(res!))
                } else if response.statusCode == 400 {
                    completionHandler(.failure(.BADREQUEST))
                } else if response.statusCode == 401 {
                    completionHandler(.failure(.UNAUTHORIZATION))
                } else if response.statusCode == 403 {
                    completionHandler(.failure(.FORBIDDEN))
                } else {
                    completionHandler(.failure(.NOTFOUND))
                }
            }
        }.resume()
        
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
                                        fileName: "\(self.userData.email.hash)_signature.png",
                                        mimeType: "image/png",
                                        fileData: image.pngData()!,
                                        using: boundary))
        httpBody.appendString("--\(boundary)--")
        request.httpBody = httpBody as Data
        print(self.userData.email.hashValue)
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
//    func updateSignature(_ image: UIImage, completionHandler: @escaping (Bool, Int) -> Void) {
//        let imageData = image.pngData()!
//        var request = URLRequest(url: URL(string: "\(self.host)/signatures")!)
//        request.httpMethod = "PATCH"
//
//        let uniqString = UUID().uuidString
//        let contentType = "multipart/form-data; boundary=\(uniqString)"
//        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
//
//        var body = Data()
//        body.append("--\(uniqString)\r\n".data(using: .utf8)!)
//        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(image.hash)signature.png\"\r\n".data(using: .utf8)!)
//        body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
//        body.append(imageData)
//        body.append("\r\n".data(using: .utf8)!)
//        body.append("--\(uniqString)--\r\n".data(using: .utf8)!)
//
//        let session = URLSession(configuration: .default)
//        session.configuration.timeoutIntervalForRequest = TimeInterval(20)
//        session.configuration.timeoutIntervalForResource = TimeInterval(20)
//
//        let task = session.uploadTask(with: request, from: body) { (data, response, error) in
//            DispatchQueue.main.async {
//                if let response = response as? HTTPURLResponse {
//                    if response.statusCode == 200 {
//                        completionHandler(true, 200)
//                    } else if response.statusCode == 201 { // 파일 안 보냄
//                        completionHandler(false, 204)
//                    } else if response.statusCode == 401 { // 토큰 만료
//                        completionHandler(false, 401)
//                    } else if response.statusCode == 403 { // 전자서명 저장 실패
//                        completionHandler(false, 403)
//                    } else if response.statusCode == 500 { // INTERNAL SERVER ERROR
//                        completionHandler(false, 500)
//                    }
//                }
//            }
//        }
//
//        task.resume()
//    }
}

// 게시판 & 게시글
extension BlockerServer {
    // 게시글 불러오기
    func getBoardData(_ size: Int, _ page: Int, completionHandler: @escaping (Bool, Int, [BoardResponseData]) -> Void) {
        var request = URLRequest(url: URL(string: "\(self.host)/boards?size=\(10)&page=\(page)")!)
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
                    print(res)
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
            "info": post.info ?? "null",
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
            "info": "\(post.info ?? nil)",
            "representImage": "\(post.representImage ?? "")",
            "contractId": "\(post.contractId)",
            "deleteImageIds": "\(convertListToString(post.deleteImageIds.map { String($0) }))",
            "addImageAddresses": "\(convertListToString(post.addImageAddresses))"
        ] as [String: Any]
        
        //        do {
        //            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        //        } catch {
        //            print("Error creating JSON data")
        //        }
        //
        //        URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
        //            // error 체크
        //            if let e = error {
        //                print(e.localizedDescription)
        //                return
        //            }
        //            // response의 상태코드 따라 분기 처리
        //            if let response = response as? HTTPURLResponse {
        //                print(response)
        //                if response.statusCode == 200 {
        //                    completionHandler(true, 200)
        //                } else if response.statusCode == 401 {
        //                    completionHandler(false, 401)
        //                } else if response.statusCode == 403 {
        //                    completionHandler(false, 403)
        //                } else if response.statusCode == 404 {
        //                    completionHandler(false, 404)
        //                }
        //            }
        //        }.resume()
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
    func writeContract(_ title:String, _ content:String, completionHandler: @escaping (Result<Int, ApiError>) -> Void)  {
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
                if response.statusCode == 200 {
                    completionHandler(.success(200))
                } else if response.statusCode == 400 {
                    completionHandler(.failure(.BADREQUEST))
                } else if response.statusCode == 401 {
                    completionHandler(.failure(.UNAUTHORIZATION))
                } else if response.statusCode == 403 {
                    completionHandler(.failure(.FORBIDDEN))
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
    
    func deleteContract(_ contractId:Int, completionHandler: @escaping (Result<Int, ApiError>) -> Void) {
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
                    completionHandler(.success(200))
                } else if response.statusCode == 400 {
                    completionHandler(.failure(.BADREQUEST))
                } else if response.statusCode == 401 {
                    completionHandler(.failure(.UNAUTHORIZATION))
                } else if response.statusCode == 403 {
                    completionHandler(.failure(.FORBIDDEN))
                }
            }
        }.resume()
    }
    
    func getContractData(_ contractId:Int, completionHandler: @escaping (Bool, Int, ContractResponseData?) -> Void) {
        var request = URLRequest(url: URL(string: "\(self.host)/contracts/not-proceed/\(contractId)")!)
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
        var request = URLRequest(url: URL(string: "\(self.host)/contracts?state=\(contractType.rawValue)")!)
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

// 미체결 계약서
extension BlockerServer {
    func searchUser(_ keyword:String, completionHandler: @escaping (Bool, Int, [UserResponseData]) -> Void) {
        var request = URLRequest(url: URL(string: "\(self.host)/users/search?keyword=\(keyword)")!)
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
                    let res = try? JSONDecoder().decode([UserResponseData].self, from: data!)
                    print(res)
                    completionHandler(true, 200, res ?? [])
                } else if response.statusCode == 401 {
                    completionHandler(false, 401, [])
                }
            }
        }.resume()
    }
    
    func proceedContract(_ contractId:Int, _ contractors:[String], completionHandler: @escaping (Bool, Int) -> Void) {
        var request = URLRequest(url: URL(string: "\(self.host)/agreement-signs")!)
        request.httpMethod = "POST"
        
        // header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        // body
        let body = [
            "contractId": contractId,
            "contractors": contractors
        ] as [String: Any]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Error creating JSON data")
        }
        
        URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            
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
    
    func deleteContractAndPost(_ contractId: Int, completionHandler: @escaping (Result<Int, ApiError>) -> Void) {
        var request = URLRequest(url: URL(string: "\(self.host)/contracts/with-boards/\(contractId)")!)
        request.httpMethod = "Delete"
        
        // header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.accessToken)", forHTTPHeaderField: "Authorization")

        URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    completionHandler(.success(200))
                } else if response.statusCode == 401 {
                    completionHandler(.failure(.UNAUTHORIZATION))
                } else if response.statusCode == 403 {
                    completionHandler(.failure(.FORBIDDEN))
                }
            }
        }.resume()
    }
}

// 진행 중 계약서
extension BlockerServer {
    func signOnContract(_ contractId:Int, completionHandler: @escaping (Bool, Int) -> Void) {
        var request = URLRequest(url: URL(string: "\(self.host)/agreement-signs/contract/\(contractId)")!)
        request.httpMethod = "PATCH"
        
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
    
    func cancelSigningContract(_ contractId:Int, completionHandler: @escaping (Bool, Int) -> Void) {
        var request = URLRequest(url: URL(string: "\(self.host)/agreement-signs/contract/\(contractId)")!)
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
                } else if response.statusCode == 400 { // 진행 중 계약서가 아님
                    completionHandler(false, 400)
                } else if response.statusCode == 401 { // 토큰 만료
                    completionHandler(false, 401)
                } else if response.statusCode == 403 {
                    completionHandler(false, 403)
                } else if response.statusCode == 404 { //
                    completionHandler(false, 404)
                }
            }
            
        }.resume()
    }
    
    func getSigningContractData(contractId:Int, completionHandler: @escaping (Bool, Int, SigningContractResponseData?) -> Void) {
        var request = URLRequest(url: URL(string: "\(self.host)/contracts/proceed/\(contractId)")!)
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
                    let res = try? JSONDecoder().decode(SigningContractResponseData.self, from: data!)
                    completionHandler(true, 200, res)
                } else if response.statusCode == 401 { // 토큰 만료
                    completionHandler(false, 401, nil)
                } else if response.statusCode == 403 {
                    completionHandler(false, 403, nil)
                }
            }
        }.resume()
    }
    
}

// 체결 계약서
extension BlockerServer {
    func getSignedContractData(_ contractId: Int, completionHandler: @escaping (Result<SignedContractResponseData,ApiError>) -> Void) {
        var request = URLRequest(url: URL(string: "\(self.host)/contracts/conclude/\(contractId)")!)
        request.httpMethod = "GET"
        
        // header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    let res = try? JSONDecoder().decode(SignedContractResponseData.self, from: data!)
                    completionHandler(.success(res!))
                } else if response.statusCode == 400 {
                    completionHandler(.failure(.BADREQUEST))
                } else if response.statusCode == 401 {
                    completionHandler(.failure(.UNAUTHORIZATION))
                } else if response.statusCode == 403 {
                    completionHandler(.failure(.FORBIDDEN))
                } else {
                    completionHandler(.failure(.NOTFOUND))
                }
            }
        }.resume()
    }
    func cancelSignedContract(_ contractId: Int, completionHandler: @escaping (Result<Int,ApiError>) -> Void) {
        var request = URLRequest(url: URL(string: "\(self.host)/cancel-signs/contract/\(contractId)")!)
        request.httpMethod = "POST"
        
        // header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    completionHandler(.success(200))
                } else if response.statusCode == 400 {
                    completionHandler(.failure(.BADREQUEST))
                } else if response.statusCode == 401 {
                    completionHandler(.failure(.UNAUTHORIZATION))
                } else if response.statusCode == 403 {
                    completionHandler(.failure(.FORBIDDEN))
                } else {
                    completionHandler(.failure(.NOTFOUND))
                }
            }
        }.resume()
    }
}

// 마이페이지
extension BlockerServer {
    func getMyPost(completionHandler: @escaping (Result<[BoardResponseData], ApiError>) -> Void) {
        var request = URLRequest(url: URL(string: "\(self.host)/boards/my-boards")!)
        request.httpMethod = "GET"
        
        // header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    let res = try? JSONDecoder().decode([BoardResponseData].self, from: data!)
                    completionHandler(.success(res ?? []))
                } else if response.statusCode == 400 {
                    completionHandler(.failure(.BADREQUEST))
                } else if response.statusCode == 401 {
                    completionHandler(.failure(.UNAUTHORIZATION))
                } else if response.statusCode == 403 {
                    completionHandler(.failure(.FORBIDDEN))
                } else {
                    completionHandler(.failure(.NOTFOUND))
                }
            }
        }.resume()
    }
    
    func getBookmark(completionHandler: @escaping (Result<[BoardResponseData], ApiError>) -> Void) {
        var request = URLRequest(url: URL(string: "\(self.host)/bookmarks/boards")!)
        request.httpMethod = "GET"
        
        // header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    let res = try? JSONDecoder().decode([BoardResponseData].self, from: data!)
                    completionHandler(.success(res ?? []))
                } else if response.statusCode == 400 {
                    completionHandler(.failure(.BADREQUEST))
                } else if response.statusCode == 401 {
                    completionHandler(.failure(.UNAUTHORIZATION))
                } else if response.statusCode == 403 {
                    completionHandler(.failure(.FORBIDDEN))
                } else {
                    completionHandler(.failure(.NOTFOUND))
                }
            }
        }.resume()
    }
}

// 파기 계약서
extension BlockerServer {
    func signOnCancelContract(_ contractId:Int, completionHandler: @escaping (Result<Int, ApiError>) -> Void) {
        var request = URLRequest(url: URL(string: "\(self.host)/cancel-signs/contract/\(contractId)")!)
        request.httpMethod = "PATCH"
        
        // header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    let res = try? JSONDecoder().decode([BoardResponseData].self, from: data!)
                    completionHandler(.success(200))
                } else if response.statusCode == 400 {
                    completionHandler(.failure(.BADREQUEST))
                } else if response.statusCode == 401 {
                    completionHandler(.failure(.UNAUTHORIZATION))
                } else if response.statusCode == 403 {
                    completionHandler(.failure(.FORBIDDEN))
                } else {
                    completionHandler(.failure(.NOTFOUND))
                }
            }
        }.resume()
    }
    
    func getCancelContractListData(_ contractType: CancelContractType, completionHandler: @escaping (Result<[ContractResponseData], ApiError>) -> Void) {
        var request = URLRequest(url: URL(string: "\(self.host)/cancel-contracts?state=\(contractType.rawValue)")!)
        request.httpMethod = "GET"
        
        // header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    let res = try? JSONDecoder().decode([ContractResponseData].self, from: data!)
                    completionHandler(.success(res!))
                } else if response.statusCode == 400 {
                    completionHandler(.failure(.BADREQUEST))
                } else if response.statusCode == 401 {
                    completionHandler(.failure(.UNAUTHORIZATION))
                } else if response.statusCode == 403 {
                    completionHandler(.failure(.FORBIDDEN))
                } else {
                    completionHandler(.failure(.NOTFOUND))
                }
            }
        }.resume()
    }
    
    func getCancelContractData(_ contractType: CancelContractType, _ contractId: Int, completionHandler: @escaping (Result<[CancelContractResponseData], ApiError>) -> Void) {
        
        var request = URLRequest(url: URL(string: "\(self.host)/cancel-contracts/\(contractType.rawValue.lowercased())/\(contractId)")!)
        request.httpMethod = "GET"
        
        // header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    let res = try? JSONDecoder().decode([CancelContractResponseData].self, from: data!)
                    completionHandler(.success(res!))
                } else if response.statusCode == 400 {
                    completionHandler(.failure(.BADREQUEST))
                } else if response.statusCode == 401 {
                    completionHandler(.failure(.UNAUTHORIZATION))
                } else if response.statusCode == 403 {
                    completionHandler(.failure(.FORBIDDEN))
                } else {
                    completionHandler(.failure(.NOTFOUND))
                }
            }
        }.resume()
    }
}
