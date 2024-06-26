//
//  HomeController.swift
//  testPJ
//
//  Created by yilin on 2024/6/26.
//

import Foundation
import UIKit

class HomeController {
    
    let viewModel: HomeViewModel
    fileprivate var isFirstTime = true
    
    init(viewModel: HomeViewModel = HomeViewModel()) {
        self.viewModel = viewModel
    }
    
    //MARK: - Func
    
    func start() {
        self.viewModel.loading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {  // 延遲顯示加載動畫
            Task {
                do {
                    let (usdSum, khrSum, notification, favoriteModel, adBannerModel) = try await self.fetchData(firstTime: self.isFirstTime)
                    self.isFirstTime = false
                    self.viewModel.loading = false
                    
                    DispatchQueue.main.async {
                        self.buildModel(usdSum: usdSum, khrSum: khrSum, notification: notification, Favorite: favoriteModel, AdBanner: adBannerModel)
                    }
                } catch {
                    self.viewModel.loading = false
                    print("start Error: \(error)")
                }
            }
        }
    }
    
    func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // 延遲顯示加載動畫
            Task {
                do {
                    let (usdSum, khrSum, notification, favoriteModel, adBannerModel) = try await self.fetchData(firstTime: self.isFirstTime)
                    
                    DispatchQueue.main.async {
                        self.viewModel.endRefreshing?()
                        self.buildModel(usdSum: usdSum, khrSum: khrSum, notification: notification, Favorite: favoriteModel, AdBanner: adBannerModel)
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.viewModel.endRefreshing?()
                        print("RefreshData Error: \(error)")
                    }
                }
            }
        }
    }
    
    func buildModel(usdSum: Double, khrSum: Double, notification: NotificationModel.Result, Favorite: FavoriteModel.Result, AdBanner: [UIImage]) {
        
        let favoriteViewModel = Favorite.favoriteList.map {
            FavoriteCellViewModel(title: $0.nickname, icon: UIImage(named: $0.transType) ?? UIImage())
        }
        
        self.viewModel.data = HomeModel(usdSum: usdSum,
                                        khrSum: khrSum,
                                        notification: NotificationViewModel(messages: notification.messages),
                                        favorite: favoriteViewModel,
                                        adBanner: AdBanner)
    }
    
    /// fetchData
    func fetchData(firstTime: Bool) async throws -> (Double, Double, NotificationModel.Result, FavoriteModel.Result, [UIImage]) {
        let usdAmount = try await fetchUsdAmount(firstTime: firstTime)
        let khrAmount = try await fetchKhrAmount(firstTime: firstTime)
        let amounts = (usdAmount, khrAmount)
        
        let notificationRequest: NotificationModel = try await APIManager.shared.request(Endpoint.notificationList(firstTime))
        let favoriteRequest: FavoriteModel = try await APIManager.shared.request(Endpoint.favoriteList(firstTime))
        let results = (notificationRequest, favoriteRequest)
        
        let banners: [UIImage]
        if firstTime {
            banners = []
        } else {
            let adBannerModel: AdBannerModel = try await APIManager.shared.request(Endpoint.adBanner)
            banners = try await downloadImages(models: adBannerModel.result)
        }
        
        return (amounts.0, amounts.1, results.0.result, results.1.result, banners)
    }
    
    /// downloadImages
    func downloadImages(models: AdBannerModel.Result) async throws -> [UIImage] {
        let urls = models.bannerList.compactMap { URL(string: $0.linkURL) }

        let images = await APIManager.shared.downloadImages(urls: urls)
        return images
    }
    
    /// fetchUsdAmount
    func fetchUsdAmount(firstTime: Bool) async throws -> Double {
        async let usdSavings: SavingsModel = APIManager.shared.request(Endpoint.usdSavings(firstTime))
        async let usdFixed: FixedDepositModel = APIManager.shared.request(Endpoint.usdFixed(firstTime))
        async let usdDigital: DigitalModel = APIManager.shared.request(Endpoint.usdDigital(firstTime))

        let results = try await (usdSavings, usdFixed, usdDigital)
        let totalSavings = results.0.result.savingsList.reduce(0) { $0 + $1.balance }
        let totalFixed = results.1.result.fixedDepositList.reduce(0) { $0 + $1.balance }
        let totalDigital = results.2.result.digitalList.reduce(0) { $0 + $1.balance }
        
        return totalSavings + totalFixed + totalDigital
    }
    
    /// fetchKhrAmount
    func fetchKhrAmount(firstTime: Bool) async throws -> Double {
        async let khrSavings: SavingsModel = APIManager.shared.request(Endpoint.khrSavings(firstTime))
        async let khrFixed: FixedDepositModel = APIManager.shared.request(Endpoint.khrFixed(firstTime))
        async let khrDigital: DigitalModel = APIManager.shared.request(Endpoint.khrDigital(firstTime))

        let results = try await (khrSavings, khrFixed, khrDigital)
        let totalSavings = results.0.result.savingsList.reduce(0) { $0 + $1.balance }
        let totalFixed = results.1.result.fixedDepositList.reduce(0) { $0 + $1.balance }
        let totalDigital = results.2.result.digitalList.reduce(0) { $0 + $1.balance }
        
        return totalSavings + totalFixed + totalDigital
    }
    
}

