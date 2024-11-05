import SwiftUI

struct CategoriesCarrousel: View {
    @Binding var selectedCategory: Item_Category?

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Categorias")
                    .font(.system(size: 24 , weight: .semibold))
                Spacer()
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20){
                    ForEach(Item_Category.allCases, id: \.self) { category in
                        carrouselCategoryItem(category: category)
                            .onTapGesture {
                                withAnimation {
                                    selectedCategory = category
                                }
                            }
                    }
                }
            }
        }
        .background(.clear)
    }
    
    @ViewBuilder
    func carrouselCategoryItem(category: Item_Category) -> some View {
        let isSelected = selectedCategory == category

        VStack(spacing: 10) {
            Image(systemName: "hammer.fill") // Troque o ícone conforme necessário
                .resizable()
                .scaledToFit()
                .foregroundStyle(isSelected ? .white : .gray)
                .frame(height: 25)
                
            Text(category.rawValue)
                .font(.system(size: 10, weight: .regular))
                .lineLimit(1)
                .foregroundColor(isSelected ? .white : .gray.opacity(0.75))
        }
        .frame(width: isSelected ? 75 : 65, height: isSelected ? 75 : 65)
        .background(isSelected ? Color.orange : Color.gray.opacity(0.08))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.orange : Color.black.opacity(0.2), lineWidth: 1)
        }
        .scaleEffect(isSelected ? 1.1 : 1.0) // Leve aumento de escala ao ser selecionado
        .animation(.linear(duration: 0.1), value: isSelected)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}


#Preview {
    @Previewable @State var selectedCategory: Item_Category? = nil
    CategoriesCarrousel(selectedCategory: $selectedCategory)
}
