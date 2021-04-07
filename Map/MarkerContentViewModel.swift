//
//  MarkerContentViewModel.swift
//  Map
//
//  Created by Nikola Malinovic on 05.04.21.
//

import Foundation
import Mapbox

class MarkerContentViewModel: ObservableObject {
    @Published var markers: MapElements?
    @Published var annotation: MGLAnnotation
    @Published var isPresented = false

    init(annotation: MGLAnnotation, isPresented: Bool) {
        self.annotation = annotation
        self.isPresented = isPresented
    }

    /*
    @Published var icon: Icon
    @Published var title: String
    @Published var subtitle: String?
    @Published var description: String
    @Published var position: [Double]
    @Published var type: TypePoi
    @Published var states: [PoiState]?

    init(markers: MapElements?,
         icon: Icon,
         title: String,
         subtitle: String?,
         description: String,
         position: [Double],
         type: TypePoi,
         states: [PoiState]?) {
        self.markers = markers
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.description = description
        self.position = position
        self.type = type
        self.states = states
    }
 */
}
