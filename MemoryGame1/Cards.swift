//
//  Cards.swift
//  MemoryGame1
//
//  Created by Cristian De Francesco on 10/26/24.
//

import SwiftUI

struct Cards: View {
    let card: Card
    
    var body: some View {
        ZStack {
            if card.isFaceUp || card.isMatched {
                Text(card.content)
                    .font(.largeTitle)
                    .frame(width: 75, height: 125)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 5)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue)
                    .frame(width: 75, height: 125)
            }
        }
        .rotation3DEffect(
            Angle(degrees: card.isFaceUp ? 0 : 180),
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(.easeInOut(duration: 0.5), value: card.isFaceUp)
        .opacity(card.isMatched ? 0 : 1)
    }
}


#Preview {
    Cards(card: Card(content: "🍎", isFaceUp: true))
}
