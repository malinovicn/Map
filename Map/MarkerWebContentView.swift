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
struct MarkerContent_Previews: PreviewProvider {
    static var previews: some View {
        MarkerWebContentView(title: "This is the Title",
                             description: "<p>Hier können Fahrkarten für die Region des Mitteldeutschen Verkehrsverbundes erworben werden.<br></p> <br> <table class=\"table\"> <tbody><tr> <td>Einzelfahrkarte</td> </tr> <tr> <td>4-Fahrtenkarte </td> </tr> <tr> <td>Tageskarte </td> </tr> <tr> <td>Wochenkarte </td> </tr> <tr> <td>Monatskarte</td> </tr> <tr><td>Extrakarte</td> </tr></tbody></table> <br> <p>Hier können Sie ebenfalls Tickets kaufen:</p> <ul> <li>im <a href=\"https://havag.com/service-center\"; target=\"_blank\">HAVAG-SERVICE-CENTER</a> <ul> <li>Rolltreppe</li> <li>Neustadt </li> </ul> </li><li>bei unseren <a href=\"https://havag.com/vertriebspartner\"; target=\"_blank\">Basishändlern und unserem Premiumhändler</a> </li> <li>im Internet im <a href=\"https://ticket-shop.havag.com/\"; target=\"_blank\">Ticket-Shop</a> und <a href=\"https://abo.havag.com/Privatabo/?pk_campaign=HAVAG%20Abo\"; target=\"_blank\">ABO-Shop</a> der HAVAG</li> <li>im Internet bei <a href=\"https://app.myeasygo.de/?width=1803&;amp;height=973\" target=\"_blank\">easy.GO</a></li> </ul>",
                             type: "This is the Type")    }
}
#endif
