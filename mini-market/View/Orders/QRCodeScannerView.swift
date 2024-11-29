//
//  QRCodeScannerView.swift
//  mini-market
//
//  Created by Rafael Gorayb Correa on 24/11/24.
//

import Foundation
import SwiftUI
import AVFoundation

import SwiftUI
import AVFoundation

struct QRCodeOrderScannerView: UIViewRepresentable {
    @Binding var code: String?
    @Binding var error: QRCodeScannerError?

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()

        let session = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            DispatchQueue.main.async {
                self.error = .noCameraAvailable
            }
            return view
        }

        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            DispatchQueue.main.async {
                self.error = .initializationError(error.localizedDescription)
            }
            return view
        }

        if session.canAddInput(videoInput) {
            session.addInput(videoInput)
        } else {
            DispatchQueue.main.async {
                self.error = .initializationError("Cannot add input")
            }
            return view
        }

        let metadataOutput = AVCaptureMetadataOutput()
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            DispatchQueue.main.async {
                self.error = .initializationError("Cannot add output")
            }
            return view
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = UIScreen.main.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        session.startRunning()

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: QRCodeOrderScannerView
        var isScanning = true

        init(parent: QRCodeOrderScannerView) {
            self.parent = parent
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if isScanning, let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject, let code = metadataObject.stringValue {
                isScanning = false
                DispatchQueue.main.async {
                    self.parent.code = code
                }
            }
        }
    }
}


enum QRCodeScannerError: Error, Equatable {
    case noCameraAvailable
    case initializationError(_ message: String)

    var localizedDescription: String {
        switch self {
        case .noCameraAvailable:
            return "Não foi possível acessar a câmera."
        case .initializationError(let message):
            return message
        }
    }
}


