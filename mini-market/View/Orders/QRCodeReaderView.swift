//
//  QRCodeReaderView.swift
//  mini-market
//
//  Created by Rafael Gorayb Correa on 24/11/24.
//

import SwiftUI

struct QRCodeReaderView: View {
    @EnvironmentObject var orderManager: OrderManager
    @Environment(\.presentationMode) var presentationMode
    var order: Order

    @State private var isFirstScan = true
    @State private var message: String = "Aponte a câmera para o QR Code"
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var scannedCode: String? = nil
    @State private var scanningError: QRCodeScannerError? = nil

    var body: some View {
        ZStack {
            QRCodeOrderScannerView(code: $scannedCode, error: $scanningError)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text(message)
                    .font(.headline)
                    .padding()
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(10)
                    .padding(.top, 50)

                Spacer()
            }
        }
        .onChange(of: scannedCode) { newCode in
            if newCode != nil {
                handleScan()
            }
        }
        .onChange(of: scanningError) { error in
            if let error = error {
                message = error.localizedDescription
            }
        }
        .navigationBarTitle("Ler QRCode", displayMode: .inline)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Status Atualizado"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                self.presentationMode.wrappedValue.dismiss()
            })
        }
    }

    func handleScan() {
        DispatchQueue.main.async {
            var newStatus: OrderStatus

            switch order.status {
            case .pending:
                newStatus = .ongoing
            case .ongoing:
                newStatus = .returned
            default:
                newStatus = order.status
            }

            if newStatus != order.status {
                orderManager.updateOrderStatus(order: order, to: newStatus)
                alertMessage = "O status do pedido foi atualizado para '\(newStatus.rawValue)'."
                showAlert = true
            } else {
                message = "Este pedido não pode ser atualizado."
            }

            // Reset scannedCode to allow for future scans if needed
            scannedCode = nil
        }
    }
}





