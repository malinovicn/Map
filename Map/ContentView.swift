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

struct ContentView: View {
    @Injected(name: "MapApiService") static var api: MapApiBaseProtocol
//    @ObservedObject var apiService = PublisherViewModel<MapElement, Error> { _ in
//
//    }

    @State var isPresented = false

    @State var annotations: [MGLPointAnnotation] = [
        MGLPointAnnotation(title: "Mapbox", coordinate: .init(latitude: 37.791434, longitude: -122.396267))
    ]

    var body: some View {
        ZStack {
            MapView(annotations: $annotations)
                .centerCoordinate(.init(latitude: 37.791293, longitude: -122.396324))
                .zoomLevel(16)
                .edgesIgnoringSafeArea(.top)
                .edgesIgnoringSafeArea(.bottom)
                .onTapGesture {
                    isPresented = true
                }
        }
        .bottomSheet(isPresented: $isPresented, height: UIScreen.main.bounds.height / 1.5) {
//            List(20..<40) {
//                Text("\($0)")
//            }
//            .listStyle(PlainListStyle())
            MarkerContentView()
        }
        .navigationTitle("Bottom sheet")
        .navigationBarItems(trailing: Button(action: { isPresented = false }) {
            Text("Show")
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
