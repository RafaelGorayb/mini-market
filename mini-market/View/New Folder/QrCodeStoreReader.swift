import SwiftUI
import SwiftData
import AVFoundation
import UIKit

struct QrCodeStoreReader: View {
    @Binding var scannedCode: String?
    @State private var isPresentingScanner = false
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 20) {
                Spacer()
                Image("qrcodescan")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .padding()
                
                Text("Para acessar os itens de uma loja, leia o QR code da porta do estabelecimento")
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundColor(.gray)
                
                Button(action: {
                    isPresentingScanner = true
                }) {
                    Text("Ler Qr Code")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .background(orange1)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)
                .sheet(isPresented: $isPresentingScanner) {
                    QRCodeScannerView(scannedCode: $scannedCode)
                }
                Spacer()
            }
            .padding()
        }
    }
}

struct QRCodeScannerView: UIViewControllerRepresentable {
    @Binding var scannedCode: String?
    
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: QRCodeScannerView
        
        init(parent: QRCodeScannerView) {
            self.parent = parent
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject, let stringValue = readableObject.stringValue else { return }
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                parent.scannedCode = stringValue
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return viewController }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return viewController
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            return viewController
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            return viewController
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewController.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

#Preview {
    QrCodeStoreReader(scannedCode: .constant(nil))
}
