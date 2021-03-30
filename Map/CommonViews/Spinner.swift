//
//  Spinner.swift
//  Map
//
//  Created by Nikola Malinovic on 30.03.21.
//

import SwiftUI

public struct Spinner: View {
    let text: String?
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State private var counter = 0

    public init(text: String? = nil) {
        self.text = text
    }

    public var body: some View {
        HStack(spacing: 0) {
            ActivityIndicator()
            if text != nil {
                Group {
                    Text(verbatim: " ")
                    Text(text!)
                    Text(verbatim: ".").opacity(counter < 1 ? 0 : 1)
                    Text(verbatim: ".").opacity(counter < 2 ? 0 : 1)
                    Text(verbatim: ".").opacity(counter < 3 ? 0 : 1)
                }
                .animation(.easeInOut(duration: 0.5))
                .onReceive(timer) { _ in
                        self.counter += 1
                        self.counter %= 4
                }
            }
        }.transition(.opacity)
    }
}

struct ActivityIndicator: UIViewRepresentable {
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .medium)
        view.startAnimating()
        return view
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {}
}

#if DEBUG
struct Spinner_Previews: PreviewProvider {
    static var previews: some View {
        Spinner(text: "Loading")
    }
}
#endif
