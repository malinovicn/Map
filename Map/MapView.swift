//
//  MapView.swift
//  Map
//
//  Created by Nikola Malinovic on 17.03.21.
//

import SwiftUI
import Mapbox

extension MGLPointAnnotation {
    convenience init(title: String, coordinate: CLLocationCoordinate2D) {
        self.init()
        self.title = title
        self.coordinate = coordinate
    }
}

struct MapView: UIViewRepresentable {
    @Binding var annotations: [MGLPointAnnotation]

    private let mapView: MGLMapView = MGLMapView(frame: .zero, styleURL: MGLStyle.streetsStyleURL)

    // MARK: - Configuring UIViewRepresentable protocol

    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MGLMapView {
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MGLMapView, context: UIViewRepresentableContext<MapView>) {
        updateAnnotations()
    }

    func makeCoordinator() -> MapView.Coordinator {
        Coordinator(self)
    }

    // MARK: - Configuring MGLMapView

    func styleURL(_ styleURL: URL) -> MapView {
        mapView.styleURL = styleURL
        return self
    }

    func centerCoordinate(_ centerCoordinate: CLLocationCoordinate2D) -> MapView {
        mapView.centerCoordinate = centerCoordinate
        return self
    }

    func zoomLevel(_ zoomLevel: Double) -> MapView {
        mapView.zoomLevel = zoomLevel
        return self
    }

    private func updateAnnotations() {
        if let currentAnnotations = mapView.annotations {
            mapView.removeAnnotations(currentAnnotations)
        }
        mapView.addAnnotations(annotations)
    }

    private func setMarkerContentViewModel(annotation: MGLAnnotation, isPresented: Bool) {
        _ = MarkerContentViewModel(annotation: annotation, isPresented: true)
    }

    // MARK: - Implementing MGLMapViewDelegate

    final class Coordinator: NSObject, MGLMapViewDelegate {
        var mapView: MapView

        init(_ control: MapView) {
            self.mapView = control
        }

        func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
            debugPrint("didSelect annotationWithCoordinate: \(annotation.coordinate)")
            self.mapView.setMarkerContentViewModel(annotation: annotation, isPresented: true)
        }

        func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {}

        func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
            return nil
        }

        func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
            return true
        }
    }
}

class MapViewModel: ObservableObject {
    @Published var annotation: MGLAnnotation?
    @Published var isPresented: Bool?

    init(annotation: MGLAnnotation?, isPresented: Bool?) {
        self.annotation = annotation
        self.isPresented = isPresented
    }
}
