//
//  BottomInput.swift
//  animations-swift
//
//  Created by João Damazio on 16/06/24.
//

import SwiftUI

struct BottomInput: View {
    @State var input = ""

    var body: some View {
        HStack {
            Image(systemName: "plus")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 18, height: 18)
            
            TextField(
                "Share with not dot...",
                text: $input
            )
            .padding(.horizontal, 5)
            .disabled(true)
            
            Image(systemName: "mic")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 18, height: 18)
        }
        .padding(16)
        .background {
            Color.gray.opacity(0.3)
        }
        .clipShape(.rect(cornerRadius: 18))
        .padding(.horizontal, 16)
    }
}

#Preview {
    BottomInput()
}
