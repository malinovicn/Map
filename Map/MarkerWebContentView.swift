//
//  MarkerContent.swift
//  Map
//
//  Created by Nikola Malinovic on 05.04.21.
//

import SwiftUI
import WebKit

struct MarkerWebContentView: View {
    @State var title = ""
    @State var description = ""
    @State var type = ""

    init(title: String, description: String, type: String) {
        self.title = title
        self.description = description
        self.type = type
    }

    var body: some View {
        NavigationView {
            VStack {
                WebView(text: $description)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .padding()
                Spacer()
                HStack {
                    if !type.isEmpty {
                        Text("--- \(type) ---")
                    }
                    Spacer()
                }
            }
            .navigationBarTitle(title, displayMode: .inline)
        }
    }
}

struct WebView: UIViewRepresentable {
  @Binding var text: String
   
  func makeUIView(context: Context) -> WKWebView {
    return WKWebView()
  }
   
  func updateUIView(_ uiView: WKWebView, context: Context) {
    uiView.loadHTMLString(text, baseURL: nil)
  }
}

#if DEBUG
//struct MarkerContent_Previews: PreviewProvider {
//    static var previews: some View {
//        MarkerWebContentView(title: "", description: "", type: "")
//    }
//}
#endif
