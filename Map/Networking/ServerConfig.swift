//
//  ServerConfig.swift
//  Map
//
//  Created by Nikola Malinovic on 30.03.21.
//

import Foundation

/// Configuration for the tenant connection to the Server.
public protocol ServerConfig {
    /// Returns a URL from the host.
    var baseURL: URL { get }

    /// Returns the api base path.
    var host: URL { get }
}

/// Contains default values for the ServerConfig.
public struct DefaultServerConfig: ServerConfig {

    public init() {}

    public var baseURL: URL {
        host
    }

    public var host: URL {
        "https://midgard.netzmap.com/"
    }
}
