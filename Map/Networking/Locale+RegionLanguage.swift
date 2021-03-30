//
//  Locale+RegionLanguage.swift
//  Map
//
//  Created by Nikola Malinovic on 30.03.21.
//

import Foundation

public extension Locale {
    static var regionLanguage: String {
        let currentLocale = "\(Locale.current)"
        return currentLocale.replacingOccurrences(of: "_", with: "-")
    }
}
