import SwiftUI

struct DetailedItemMarketList: View {
    @EnvironmentObject var cartManager: CartManager
    var item: Item
    var namespace: Namespace.ID // Namespace para a transição
    
    @State private var isShowingAddToCart = false
    @State private var showConfirmationAlert = false
    
    var body: some View {
        ScrollView {
            Image(item.image)
                .resizable()
                .scaledToFit()
                .frame(height: 350)
                
            HStack {
                VStack(alignment: .leading, spacing: 15) {
                    Text(item.name)
                        .font(.system(size: 20, weight: .medium))
                       
                    HStack {
                        ForEach(0..<item.rating, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 20)
                                .foregroundColor(.yellow)
                        }
                    }
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(item.price_info.price_perHour.formatted(.currency(code: "BRL")))/h")
                                .font(.system(size: 18, weight: .bold))
                            Text("Ou \(item.price_info.price_perHour.formatted(.currency(code: "BRL")))/h")
                                .font(.system(size: 10, weight: .light))
                        }
                        Spacer()
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.green).opacity(0.1)
                            Text("Disponível")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(.green)
                                .padding(5)
                        }
                        .frame(width: 70)
                    }
                    .padding()
                    .frame(height: 60)
                    .background(Color.gray.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Text("Sobre").fontWeight(.bold)
                        .padding(.top)
                    Text(item.description)
                        .font(.system(size: 15, weight: .regular))
                    Spacer()
                    
                    // Botão para apresentar a folha
                    Button(action: {
                        isShowingAddToCart = true
                    }, label: {
                        Text("Adicionar ao carrinho")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(orange1)
                            .cornerRadius(10)
                    })
                    .padding(.top, 20)
                    // Apresentação da folha
                    .sheet(isPresented: $isShowingAddToCart) {
                        AddToCartView(item: item, isPresented: $isShowingAddToCart, showConfirmationAlert: $showConfirmationAlert)
                            .environmentObject(cartManager) // Certifique-se de que o cartManager está disponível
                    }
                    // Popup de confirmação
                    .alert(isPresented: $showConfirmationAlert) {
                        Alert(
                            title: Text("Item adicionado"),
                            message: Text("O item foi adicionado ao seu carrinho."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
                Spacer()
            }
            .padding([.leading, .trailing])
        }
        .navigationTitle("Detalhes do Item")
    }
    
}


#Preview {
    @Previewable @Namespace var previewNamespace // Cria um namespace para o preview
    DetailedItemMarketList(item: items[0], namespace: previewNamespace) // Passa o namespace criado para o preview
}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b, a: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b, a) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17, 255)
        case 6: // RGB (24-bit)
            (r, g, b, a) = (int >> 16, int >> 8 & 0xFF, int & 0xFF, 255)
        case 8: // ARGB (32-bit)
            (r, g, b, a) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF, int >> 24)
        default:
            (r, g, b, a) = (0, 0, 0, 255)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// Agora você pode usar a cor personalizada assim:
let orange1 = Color(hex: "#F16A26")
