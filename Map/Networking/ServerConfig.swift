//
//  ServerConfig.swift
//  Map
//
//  Created by Nikola Malinovic on 30.03.21.
//

import Foundation

/// Configuration for the tenant connection to the Server.
public protocol ServerConfig {
    /// Returns a URL from the stage host.
    var baseURL: URL { get }

    /// Returns a combination of the stage host and api path.
    var apiBase: URL { get }

    /// Returns the host bank url.
    var stageHost: URL { get }

    /// Returns the api base path.
    var apiPath: String { get }
}

/// Contains default values for the ServerConfig.
public struct DefaultServerConfig: ServerConfig {

    public init() {}

    public var baseURL: URL {
        stageHost
    }

    public var apiBase: URL {
        stageHost.appendingPathComponent(apiPath)
    }

    public var stageHost: URL {
        "https://xxx"
    }

    public var apiPath: String {
        "api/v1"
    }
}
