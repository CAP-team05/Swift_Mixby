//
//  BartenderFace.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI
import WebKit

struct GIFView: UIViewRepresentable {
    private let name: String

    init(_ name: String) {
        self.name = name
    }

    func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()

        // WebView 설정
        webview.isOpaque = false
        webview.backgroundColor = .clear
        webview.scrollView.isScrollEnabled = false
        webview.scrollView.bounces = false

        if let url = Bundle.main.url(forResource: name, withExtension: "gif") {
            do {
                let data = try Data(contentsOf: url)
                webview.load(
                    data,
                    mimeType: "image/gif",
                    characterEncodingName: "UTF-8",
                    baseURL: url.deletingLastPathComponent()
                )
            } catch {
                print("Failed to load GIF: \(error.localizedDescription)")
            }
        } else {
            print("GIF file \(name).gif not found in bundle")
        }

        return webview
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // 업데이트 시 reload 호출
        uiView.reload()
    }
}
