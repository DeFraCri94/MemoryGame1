import SwiftUI

struct Card: Identifiable {
    let id = UUID()
    let content: String
    var isFaceUp = false
    var isMatched = false
}

struct ContentView: View {
    @ObservedObject var viewModel = MemoryGameViewModel()
    
    var body: some View {
        VStack {
            Button("Reset Game") {
                viewModel.resetGame()
            }
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(20)
            .padding(.top, 70)
            
            Spacer()
            
            ScrollView { 
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
                    ForEach(viewModel.cards) { card in
                        Cards(card: card)
                            .onTapGesture {
                                viewModel.choose(card)
                            }
                            .padding(20)
                    }
                }
            }
            .padding()
        }
    }
}

class MemoryGameViewModel: ObservableObject {
    @Published var cards: [Card] = []
    @Published var selectedCards: [Card] = []
    
    init() {
        resetGame()
    }
    
    func choose(_ card: Card) {
        guard let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
              !cards[chosenIndex].isFaceUp,
              !cards[chosenIndex].isMatched else { return }
        
        cards[chosenIndex].isFaceUp = true
        selectedCards.append(cards[chosenIndex])
        
        if selectedCards.count == 2 {
            checkForMatch()
        }
    }
    
    private func checkForMatch() {
        let firstCard = selectedCards[0]
        let secondCard = selectedCards[1]
        
        if firstCard.content == secondCard.content {
            cards = cards.map { card in
                if card.id == firstCard.id || card.id == secondCard.id {
                    var matchedCard = card
                    matchedCard.isMatched = true
                    return matchedCard
                }
                return card
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.cards = self.cards.map { card in
                    if card.id == firstCard.id || card.id == secondCard.id {
                        var unmatchedCard = card
                        unmatchedCard.isFaceUp = false
                        return unmatchedCard
                    }
                    return card
                }
            }
        }
        
        selectedCards.removeAll()
    }
    
    func resetGame() {
        let cardContents = ["🍎", "🍌", "🍒", "🍉", "🍇", "🍋", "🍓", "🍑"]
        let pairedCards = (cardContents + cardContents).map { Card(content: $0) }
        cards = pairedCards.shuffled()
        
        selectedCards.removeAll()
    }
}

#Preview {
    ContentView()
}

