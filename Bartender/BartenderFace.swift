//
//  BartenderFace.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI
import WebKit

struct BartenderFace: UIViewRepresentable {
    private let name: String
    init(_ name: String) {
        self.name = name
    }
    func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()
        let url = Bundle.main.url(forResource: name, withExtension: "gif")!
        let data = try! Data(contentsOf: url)
        webview.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: url.deletingLastPathComponent())
        webview.isOpaque = false
        webview.backgroundColor = .clear
        return webview
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }
}
