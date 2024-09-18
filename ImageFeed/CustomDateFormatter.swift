//
//  CustomDateFormatter.swift
//  ImageFeed
//
//  Created by Mac on 17.09.2024.
//

import Foundation

final class CustomDateFormatter {
    static let shared = CustomDateFormatter()
    private init() {}
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    lazy var iso8601DateFormatter = ISO8601DateFormatter()
}
