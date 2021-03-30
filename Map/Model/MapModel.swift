//
//  MapModel.swift
//  Map
//
//  Created by Nikola Malinovic on 20.03.21.
//

import Foundation

// MARK: - MapElement
struct MapElement: Codable {
    let id: Int
    let icon: Icon
    let title: String
    let titleEn: TitleEn?
    let subtitle, subtitleEn: String?
    let mapDescription: String
    let descriptionEn: String?
    let position: [Double]
    let createdAt, updatedAt: String
    let type: TypeEnum
    let useableText: UseableText?
    let states: [MapState]?

    enum CodingKeys: String, CodingKey {
        case id, icon, title
        case titleEn = "title_en"
        case subtitle
        case subtitleEn = "subtitle_en"
        case mapDescription = "description"
        case descriptionEn = "description_en"
        case position
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case type
        case useableText = "useable_text"
        case states
    }
}

enum Icon: String, Codable {
    case aschebehälter = "Aschebehälter"
    case bikeRide = "bike-ride"
    case bwgErlebnishaus = "bwg-erlebnishaus"
    case carsharingCarSmall = "carsharing-car-small"
    case carsharingStationKeyCar = "carsharing-station-key-car"
    case eTankstelle = "e-tankstelle"
    case parkRide = "park-ride"
    case premiumhaendler = "premiumhaendler"
    case serviceCenter = "service-center"
    case swhTestzentrum = "swh-testzentrum"
    case taxi = "taxi"
    case ticketautomat = "ticketautomat"
}

enum MapState: String, Codable {
    case available = "available"
    case occupied = "occupied"
}

enum TitleEn: String, Codable {
    case empty = ""
    case ticketMachine = "ticket machine"
}

enum TypeEnum: String, Codable {
    case flinksterPoi = "FlinksterPoi"
    case jezVehiclePoi = "JezVehiclePoi"
    case simplePoi = "SimplePoi"
    case volterraPoi = "VolterraPoi"
}

enum UseableText: String, Codable {
    case frei0 = "Frei: 0"
    case frei1 = "Frei: 1"
    case frei2 = "Frei: 2"
    case frei3 = "Frei: 3"
    case frei5 = "Frei: 5"
    case verfügbar0 = "Verfügbar: 0"
    case verfügbar1 = "Verfügbar: 1"
    case verfügbar2 = "Verfügbar: 2"
}

typealias Map = [MapElement]
