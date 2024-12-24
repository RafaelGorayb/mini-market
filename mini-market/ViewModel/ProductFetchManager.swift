//
//  ProductFetchManager.swift
//  mini-market
//
//  Created by Rafael Gorayb Correa on 12/12/24.
//
import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseDatabase
import Combine

class ProductFetchManager: ObservableObject {
    @Published var items: [Item] = []
    
    private var db = Firestore.firestore()
    
    func fetchProducts(from storeID: String) {
        db.collection("Stores")
            .document(storeID)
            .collection("Products")
            .getDocuments { [weak self] (querySnapshot, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Erro ao buscar produtos: \(error.localizedDescription)")
                    return
                }
                
                // Convertendo documentos em objetos do tipo Item
                self.items = querySnapshot?.documents.compactMap { doc -> Item? in
                    // Tentar decodificar usando o Firestore Decodable
                    // Assumindo que a sua estrutura no Firestore é compatível com o modelo
                    // e que você possui os mesmos nomes de campos
                    return try? doc.data(as: Item.self)
                } ?? []
            }
    }
}
