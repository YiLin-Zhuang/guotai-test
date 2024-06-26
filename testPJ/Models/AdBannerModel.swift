//
//  AdBannerModel.swift
//  testPJ
//
//  Created by yilin on 2024/6/26.
//

import Foundation

// MARK: - AdBannerModel
struct AdBannerModel: baseResponse {
    var msgCode: String
    var msgContent: String
    let result: Result
    
    // MARK: - Result
    struct Result: Codable {
        let bannerList: [BannerList]
    }

    // MARK: - BannerList
    struct BannerList: Codable {
        let adSeqNo: Int
        let linkURL: String

        enum CodingKeys: String, CodingKey {
            case adSeqNo
            case linkURL = "linkUrl"
        }
    }
}


