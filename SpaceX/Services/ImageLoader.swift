//
//  ImageLoader.swift
//  SpaceX
//
//  Created by Nikita Nikolaichik on 07.03.2023.
//

import UIKit

final class ImageLoader {
    
    public static let shared = ImageLoader()
    
    private let cache = NSCache<NSString, NSData>()
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Public Methods
    
    public func image(for url: URL, handler: @escaping(_ image: UIImage?) -> Void) {
        if let data = cache.object(forKey: url.absoluteString as NSString) {
            DispatchQueue.main.async {
                handler(UIImage(data: data as Data))
            }
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    handler(UIImage(data: data))
                }
            } else {
                handler(nil)
            }
        }
        task.resume()
    }
}
