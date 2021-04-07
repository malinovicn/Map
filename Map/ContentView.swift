//
//  ContentView.swift
//  Map
//
//  Created by Nikola Malinovic on 17.03.21.
//

import SwiftUI
import Mapbox
import BottomSheet
import Resolver

public struct ContentView: View {
    @Injected(name: "MapApiService") static var api: MapApiBaseProtocol
    @ObservedObject var apiService = PublisherViewModel {
        api.getSimplePois()
    }
    @State var pointAnnotations: [MGLPointAnnotation] = []
    @State var markers: MapElements?
    @State var isPresented = false

    @State var annotation: MGLAnnotation?
//    init(annotation: Binding<MGLAnnotation?>) {
//        _annotation = annotation
//    }

    public var body: some View {
        ZStack {
            if apiService.output != nil, let centerCoordinate = pointAnnotations[2].coordinate {
                MapView(annotations: $pointAnnotations)
                    .centerCoordinate(.init(latitude:  centerCoordinate.latitude,
                                            longitude: centerCoordinate.longitude))
                    .zoomLevel(10)
                    .edgesIgnoringSafeArea(.top)
                    .edgesIgnoringSafeArea(.bottom)

            }
        }
        .bottomSheet(isPresented: $isPresented, height: UIScreen.main.bounds.height / 1.5) {
            if let title = annotation?.title, let subtitle = annotation?.subtitle {
                MarkerWebContentView(title: title!,
                                     description: annotation?.description ?? "",
                                     type: subtitle!)
            }
        }
        .onAppear {
            apiService.start()
        }
        .onTapGesture { // Just to show bottom sheet
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isPresented = true
            }
        }
        .onReceive(apiService.$output) { output in
            guard output != nil else { return }
            markers = output!
            if markers!.count > 7 {
                pointAnnotations = [
                    MGLPointAnnotation(
                        title: markers![1].title,
                        coordinate: .init(latitude: Double(markers![1].position[1]),
                                          longitude: Double(markers![1].position[0]))
                    ),
                    MGLPointAnnotation(
                        title: markers![2].title,
                        coordinate: .init(latitude: Double(markers![3].position[1]),
                                          longitude: Double(markers![3].position[0]))
                    ),
                    MGLPointAnnotation(
                        title: markers![2].title,
                        coordinate: .init(latitude: Double(markers![5].position[1]),
                                          longitude: Double(markers![5].position[0]))
                    ),
                    MGLPointAnnotation(
                        title: markers![2].title,
                        coordinate: .init(latitude: Double(markers![7].position[1]),
                                          longitude: Double(markers![7].position[0]))
                    )
                ]
            }
        }
        .overlay(LoadingOverlay(isLoading: $apiService.isLoading))
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
