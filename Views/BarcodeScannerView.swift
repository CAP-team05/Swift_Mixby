import SwiftUI
import AVFoundation

struct BarcodeScannerView: View {
    @State private var scannedCode: String = ""
    @State private var showError: Bool = false
    
    @Binding var scannedCodes: [String]
    
    var body: some View {
        ZStack {
            if !showError {
                BarcodeScannerRepresentable { code in
                    addScannedCode(code) // 새로운 바코드 추가
                }
                .cornerRadius(10)
                .frame(height: 200)
            }
            
            Spacer()
            .alert(isPresented: $showError) {
                Alert(
                    title: Text("존재하지 않습니다."),
                    message: Text("\(scannedCode)에 해당하는 상품을 찾을 수 없습니다."),
                    dismissButton: .default(Text("확인"), action: {
                        showError = false // 상태 변수 리셋
                    })
                )
            }
        }
        .padding()
        .background(.clear)
    }
    
    private func addScannedCode(_ code: String) {
        // 중복 없이 추가
        scannedCode = code
        
        if isDrinkExist(barcode: scannedCode) {
            if scannedCodes.contains(scannedCode) {
                print("duplicated")
            } else {
                scannedCodes.append(code)
                print("does exist & not duplicated")
            }
        } else {
            showError = true
            print("does not exist")
        }
    }
}

struct BarcodeScannerRepresentable: UIViewRepresentable {
    var onBarcodeDetected: (String) -> Void

    func makeCoordinator() -> Coordinator {
        return Coordinator(onBarcodeDetected: onBarcodeDetected)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        context.coordinator.setupCaptureSession(for: view)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        private let onBarcodeDetected: (String) -> Void
        private let captureSession = AVCaptureSession()

        init(onBarcodeDetected: @escaping (String) -> Void) {
            self.onBarcodeDetected = onBarcodeDetected
        }

        func setupCaptureSession(for view: UIView) {
            requestCameraPermission()
            
            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
                print("Unable to access camera")
                return
            }
            
            do {
                let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
                if captureSession.canAddInput(videoInput) {
                    captureSession.addInput(videoInput)
                }
                
                let metadataOutput = AVCaptureMetadataOutput()
                if captureSession.canAddOutput(metadataOutput) {
                    captureSession.addOutput(metadataOutput)
                    metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                    metadataOutput.metadataObjectTypes = [.ean8, .ean13, .qr]
                }

                let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer.videoGravity = .resizeAspectFill
                DispatchQueue.main.async {
                    previewLayer.frame = view.layer.bounds
                    view.layer.addSublayer(previewLayer)
                }

                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    self?.captureSession.startRunning()
                }
            } catch {
                print("Error setting up camera: \(error)")
            }
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
                  let stringValue = metadataObject.stringValue else {
                return
            }

            // 바코드를 인식한 후에도 세션을 멈추지 않고 계속 작동
            DispatchQueue.main.async {
                self.onBarcodeDetected(stringValue)
            }
        }

        func requestCameraPermission() {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                break
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if !granted {
                        print("Camera access denied")
                    }
                }
            case .denied, .restricted:
                print("Camera access denied or restricted")
            default:
                break
            }
        }
    }
}
