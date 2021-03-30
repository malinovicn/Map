//
//  LoadingOverlay.swift
//  Map
//
//  Created by Nikola Malinovic on 30.03.21.
//

import SwiftUI

/// A view that can be overlaid on views to show loading activity
public struct LoadingOverlay: View {
    @Binding var isLoading: Bool
    var text = "Loading"

    public init(isLoading: Binding<Bool>) {
        _isLoading = isLoading
    }

    public init(isLoading: Binding<Bool>, text: String) {
        _isLoading = isLoading
        self.text = text
    }

    public var body: some View {
        ZStack {
            if isLoading {
                BlurEffect(style: .systemUltraThinMaterial)
                    .edgesIgnoringSafeArea(.all)
                Spinner(text: text)
            }
        }.transition(.opacity).animation(.default)
    }
}

#if DEBUG
    struct LoadingOverlayDemo: View {
        @State private var isLoading = false
        let colors = [Color.black, .white, .gray, .red, .green, .blue, .orange, .yellow, .pink, .purple]

        let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

        var body: some View {
            List {
                ForEach(1..<20) { index in
                    HStack {
                        Image(systemName: "play.circle")
                        Text("\(index). Live Preview to see me in action!")
                    }.listRowBackground(self.colors[index % self.colors.count])
                }
            }
            .overlay(LoadingOverlay(isLoading: $isLoading))
            .onReceive(timer) { _ in
                self.isLoading.toggle()
            }
        }
    }

    struct LoadingOverlay_Previews: PreviewProvider {
        static var previews: some View {
            LoadingOverlayDemo()
        }
    }
#endif
