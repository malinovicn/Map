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

    class Annotation: NSObject, MGLAnnotation {
        var coordinate: CLLocationCoordinate2D
        var title: String?
        var subtitle: String?

        init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
            self.coordinate = coordinate
            self.title = title
            self.subtitle = subtitle
        }
    }


    @ObservedObject var viewModel = MarkerContentViewModel(
        annotation: Annotation(
            coordinate: CLLocationCoordinate2D(
                latitude: CLLocationDegrees(0.0), longitude: CLLocationDegrees(0.0)), title: "", subtitle: ""
        ),
        isPresented: false
    )

    @State var annotations: [MGLPointAnnotation] = []

    public var body: some View {
        ZStack {
            if apiService.output != nil, let centerCoordinate = annotations[2].coordinate {
                MapView(annotations: $annotations)
                    .centerCoordinate(.init(latitude:  centerCoordinate.latitude,
                                            longitude: centerCoordinate.longitude))
                    .zoomLevel(10)
                    .edgesIgnoringSafeArea(.top)
                    .edgesIgnoringSafeArea(.bottom)

            }
        }
        .bottomSheet(isPresented: $viewModel.isPresented, height: UIScreen.main.bounds.height / 1.5) {
            if let title = viewModel.annotation.title, let subtitle = viewModel.annotation.subtitle {
                MarkerWebContentView(title: title!,
                                     description: viewModel.annotation.description,
                                     type: subtitle!)
            }
        }
        .onAppear {
            apiService.start()
        }
        .onTapGesture {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                viewModel.isPresented = true
            }
        }
        .onReceive(apiService.$output) { output in
            guard output != nil else { return }
            viewModel.markers = output!
            annotations = [
                MGLPointAnnotation(
                    title: viewModel.markers?[1].title ?? "",
                    coordinate: .init(latitude: Double(viewModel.markers?[1].position[1] ?? 0.0),
                                      longitude: Double(viewModel.markers?[1].position[0] ?? 0.0))
                ),
                MGLPointAnnotation(
                    title: viewModel.markers?[2].title ?? "",
                    coordinate: .init(latitude: Double(viewModel.markers?[3].position[1] ?? 0.0),
                                      longitude: Double(viewModel.markers?[3].position[0] ?? 0.0))
                ),
                MGLPointAnnotation(
                    title: viewModel.markers?[2].title ?? "",
                    coordinate: .init(latitude: Double(viewModel.markers?[5].position[1] ?? 0.0),
                                      longitude: Double(viewModel.markers?[5].position[0] ?? 0.0))
                ),
                MGLPointAnnotation(
                    title: viewModel.markers?[2].title ?? "",
                    coordinate: .init(latitude: Double(viewModel.markers?[7].position[1] ?? 0.0),
                                      longitude: Double(viewModel.markers?[7].position[0] ?? 0.0))
                )
            ]
        }
        .overlay(LoadingOverlay(isLoading: $apiService.isLoading))
    }
}

#if DEBUG
//struct ContentView_Previews: PreviewProvider {
//    static var mapViewModel = MapViewModel(annotation: <#T##MGLAnnotation#>)
//    static var previews: some View {
//        ContentView(mapViewModel: mapViewModel)
//    }
//}
#endif
