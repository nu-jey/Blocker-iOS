//
//  BlockerResponseData.swift
//  Blocker-iOS
//
//  Created by 오예준 on 2023/08/18.
//

import Foundation

struct BoardResponseData:Codable {
    let boardId:Int!
    let title:String!
    let name:String!
    let content:String!
    let representImage:String!
    let view:Int!
    let bookmarkCount:Int!
    let createdAt:String!
    let modifiedAt:String!
}

struct PostResponseData:Codable {
    let boardId:Int
    let title:String
    let content:String
    let name:String
    let representImage:String?
    let view:Int
    let bookmarkCount:Int
    let createdAt:String
    let modifiedAt:String
    let images:[String]
    let info:String?
    let contractId:Int?
    let isWriter:Bool
    let isBookmark:Bool
}

struct BlockerPostImage:Codable {
    let imageId:Int
    let imageAddress:String
}

struct SaveImageResponseData:Codable {
    let address:String
}

struct ContractResponseData:Codable {
    let title:String
    let content:String
    let createdAt:String
    let modifiedAt:String
}

struct ContractListResponseData:Codable {
    let list:[ContractResponseData]
}
