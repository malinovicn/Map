//
//  URL+Parameters.swift
//  Map
//
//  Created by Nikola Malinovic on 25.03.21.
//

import Foundation

public extension URL {
    /// A dictionary of values that can be encoded in a URL query string
    typealias Parameters = [String: String]

    /// A computed array of strings that represent the query parameters in the URL
    var parameters: Parameters {
        get {
            Parameters(queryItems: URLComponents(url: self, resolvingAgainstBaseURL: true)?.queryItems ?? [])
        }
        set {
            var components = URLComponents(url: self, resolvingAgainstBaseURL: true)!
            components.queryItems = newValue.queryItems
            self = components.url ?? self
        }
    }

    /// Returns a new URL after merging new parameters into it (overwriting any existing parameters with the same name).
    func adding(parameters: URL.Parameters) -> Self {
        modifying(self) {
            $0.parameters.merge(parameters) { _, other in other }
        }
    }

    func with(fragment: String?) -> Self {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.fragment = fragment
        return components?.url ?? self
    }
}

extension URL: ExpressibleByStringLiteral {
    /// Allows URLs to be expressed simply with literal strings
    public init(stringLiteral string: StaticString) {
        guard let url = URL(string: "\(string)") else {
            preconditionFailure("Invalid literal URL string: \(string)")
        }
        self = url
    }
}

public extension URL.Parameters {
    /// Initializes from an array of `URLQueryItem`s, as used in `URLComponents`.
    /// Note that multiple items with the same name will be discarded.
    init(queryItems: [URLQueryItem]) {
        let sequence = queryItems.filter { $0.value != nil }.map { ($0.name, $0.value!) }
        self = Dictionary(sequence) { $1 } // in case of duplicate keys, only the last occurrence is stored
    }

    /// Returns an array of URLQueryItems, as used in URLComponents
    var queryItems: [URLQueryItem] {
        map { URLQueryItem(name: $0.key, value: $0.value) }.sorted { $1.name > $0.name }
    }

    /// Returns a query string representing these parameters, such as `a=1&b=2&c=Vikram%20Kriplaney`
    var queryString: String? {
        var components = URLComponents(string: "http://dummy")
        components?.queryItems = queryItems
        return components?.url?.query
    }
}
