import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var products: ProductFetchManager
    @State private var searchText = ""
    
    var filteredItems: [Item] {
        if searchText.isEmpty {
            return []
        } else {
            return products.items.filter { item in
                item.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Buscar produtos...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Results List
                List(filteredItems) { item in
                    NavigationLink {
                        DetailedItemMarketList(item: item, namespace: Namespace().wrappedValue)
                    } label: {
                        HStack {
                            Image(item.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                            
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text("\(item.price_info.price_perHour.formatted(.currency(code: "BRL")))/h")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                
                if searchText.isEmpty {
                    ContentUnavailableView("Buscar Produtos", 
                        systemImage: "magnifyingglass",
                        description: Text("Digite para começar a buscar")
                    )
                } else if filteredItems.isEmpty {
                    ContentUnavailableView("Nenhum Resultado", 
                        systemImage: "magnifyingglass",
                        description: Text("Tente buscar com outros termos")
                    )
                }
            }
            .navigationTitle("Buscar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
    }
}
