//
//  SideMenuView.swift
//  mini-market
//
//  Created by Rafael Gorayb Correa on 28/11/24.
//

// SideMenuView.swift

import SwiftUI

struct SideMenuView: View {
    @Binding var isMenuOpen: Bool

    var body: some View {
        ScrollView{
                VStack(alignment: .leading){
                    Button(action: {
                        // Ação para o primeiro item do menu
                    }) {
                        Text("Item do Menu 1")
                            .padding()
                    }
                    Button(action: {
                        // Ação para o segundo item do menu
                    }) {
                        Text("Item do Menu 2")
                            .padding()
                    }
                    Spacer()
                }
        }
        .frame(width: 250)
        .background(Color.white)

    }
}

#Preview {
    SideMenuView(isMenuOpen: .constant(true))
}
