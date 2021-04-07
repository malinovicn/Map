//
//  Injection.swift
//  Map
//
//  Created by Nikola Malinovic on 05.04.21.
//

import Resolver

extension Resolver: ResolverRegistering {
    /// Resolver will automatically call registerAllServices, and that function will do calls to each
    /// of your OWN registration functions.
    public static func registerAllServices() {
        register { DefaultServerConfig() as ServerConfig }.scope(.cached)
        register(name: "MapApiService") { MapApi() as MapApiBaseProtocol }.scope(.application)
    }
}
