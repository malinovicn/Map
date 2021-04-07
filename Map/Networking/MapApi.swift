//
//  MapApi.swift
//  Map
//
//  Created by Nikola Malinovic on 30.03.21.
//

import Combine
import Security
import Resolver

protocol MapApiBaseProtocol {
    /// Server configuration for a specific tenant.
    var serverConfig: ServerConfig { get }

    func getSimplePois() -> AnyPublisher<MapElements, Error>
}

public struct MapApi: MapApiBaseProtocol {
    @Injected public var serverConfig: ServerConfig
    public let session: URLSession

    public init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Accept-Language": Locale.regionLanguage]
        session = URLSession(configuration: configuration, delegate: nil, delegateQueue: .main)
    }

    func getSimplePois() -> AnyPublisher<MapElements, Error> {
        serverConfig
            .baseURL
            .request(.get, path: "features.json")
            .adding(parameters: ["app_mode" : "swh-mein-halle-mobil"])
            .publisher(session: session)
    }
}
