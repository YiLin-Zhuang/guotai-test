//
//  APIManager.swift
//  testPJ
//
//  Created by yilin on 2024/6/26.
//

import Foundation
import UIKit

public protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}

class APIManager {
    static let shared = APIManager()
    private let decoder = JSONDecoder()
    private let session = URLSession.shared

    enum APIError: Error {
        case invalidURL
        case unacceptableStatusCode(Int)
        case decodingError(Error)
        case networkError(Error)
        case customError(message: String)
    }

    // MARK: - Request for Decodable types
    func request<T: Decodable>(_ endpoint: URLRequestConvertible) async throws -> T {
        do {
            let (data, response) = try await session.data(for: endpoint.asURLRequest())
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw APIError.unacceptableStatusCode((response as? HTTPURLResponse)?.statusCode ?? 0)
            }
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                return decodedData
            } catch {
                throw APIError.decodingError(error)
            }
        } catch {
            throw APIError.networkError(error)
        }
    }

    // MARK: - Download files
    func download(_ url: URL) async throws -> URL {
        let (downloadedData, response) = try await session.download(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.unacceptableStatusCode((response as? HTTPURLResponse)?.statusCode ?? 0)
        }
        return downloadedData
    }

    func downloadImages(urls: [URL]) async -> [UIImage] {
        await withTaskGroup(of: UIImage?.self, body: { group in
            var images: [UIImage] = []

            for url in urls {
                group.addTask {
                    return await self.downloadImage(url: url)
                }
            }

            for await result in group {
                if let image = result {
                    images.append(image)
                }
            }

            return images
        })
    }

    private func downloadImage(url: URL) async -> UIImage? {
        do {
            let (data, _) = try await session.data(from: url)
            return UIImage(data: data)
        } catch {
            return nil
        }
    }
}
