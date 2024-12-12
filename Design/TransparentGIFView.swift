//
//  TransparentGIFView.swift
//  mixby2
//
//  Created by Anthony on 12/11/24.
//

import SwiftUIan
import UIKit

struct TransparentGIFView: UIViewRepresentable {
    let gifName: String

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let gifView = UIImageView()
        gifView.translatesAutoresizingMaskIntoConstraints = false
        gifView.contentMode = .scaleAspectFit
        gifView.backgroundColor = .clear // 배경 투명

        if let gifPath = Bundle.main.path(forResource: gifName, ofType: "gif"),
           let gifData = try? Data(contentsOf: URL(fileURLWithPath: gifPath)),
           let source = CGImageSourceCreateWithData(gifData as CFData, nil) {
            var images: [UIImage] = []
            var duration: Double = 0.0

            let frameCount = CGImageSourceGetCount(source)
            for i in 0..<frameCount {
                if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                    let frameDuration = gifFrameDuration(for: source, index: i)
                    duration += frameDuration
                    images.append(UIImage(cgImage: cgImage))
                }
            }

            gifView.animationImages = images
            gifView.animationDuration = duration
            gifView.startAnimating()
        }

        view.addSubview(gifView)

        NSLayoutConstraint.activate([
            gifView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gifView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gifView.topAnchor.constraint(equalTo: view.topAnchor),
            gifView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    private func gifFrameDuration(for source: CGImageSource, index: Int) -> Double {
        var frameDuration = 0.1
        if let properties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [CFString: Any],
           let gifProperties = properties[kCGImagePropertyGIFDictionary] as? [CFString: Any],
           let delayTime = gifProperties[kCGImagePropertyGIFUnclampedDelayTime] as? Double {
            frameDuration = delayTime
        }
        return max(frameDuration, 0.02) // 최소 프레임 지속시간 설정
    }
}
