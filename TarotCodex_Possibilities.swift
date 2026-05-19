import SwiftUI

/*
    WELCOME TO THE TAROT CODEX POSSIBILITIES FILE!
    
    As you progress through your "100 Days of Swift," you can refer back 
    to this file for ideas on how to make your app "beautiful but functional."
    
    To use these: You can copy and paste these "structs" or "extensions" 
    directly into your ContentView.swift or new Swift files in Xcode.
*/

// MARK: - 1. THE DATA MODEL
// This is how you represent a "Card" in code.
// You'll learn about 'Identifiable' and 'Codable' around Day 10-12.
struct TarotCard: Identifiable, Codable {
    var id = UUID()        // Gives every card a unique ID
    let name: String       // e.g., "The Fool"
    let meaning: String    // e.g., "New beginnings"
    let imageName: String  // The name of the image in your Assets
    let suite: String      // Major, Cups, Swords, etc.
}

// MARK: - 2. THE MAGICAL GLOW EFFECT
// This is a "View Extension." It's like giving Xcode a new super-power.
// You can call .mysticalGlow() on any button, text, or image.
extension View {
    func mysticalGlow(color: Color = .purple) -> some View {
        self.shadow(color: color.opacity(0.6), radius: 10)
            .shadow(color: color.opacity(0.4), radius: 20)
            .shadow(color: color.opacity(0.2), radius: 30)
    }
}

// MARK: - 3. THE INTERACTIVE CARD VIEW
// This is a "Component." You can use it to show a card that flips.
struct TarotCardView: View {
    let card: TarotCard
    @State private var isFlipped = false // Tracks if the card is face up
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                // THE BACK OF THE CARD
                // Shown when 'isFlipped' is false
                RoundedRectangle(cornerRadius: 25)
                    .fill(LinearGradient(
                        colors: [.black, .indigo, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 260, height: 420)
                    .overlay(
                        Image(systemName: "moon.stars.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.yellow)
                            .mysticalGlow(color: .yellow)
                    )
                    // This creates the "border"
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white.opacity(0.2), lineWidth: 2)
                    )
                    .opacity(isFlipped ? 0 : 1)
                
                // THE FRONT OF THE CARD
                // Shown when 'isFlipped' is true
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white)
                    .frame(width: 260, height: 420)
                    .overlay(
                        VStack {
                            Text(card.name)
                                .font(.title)
                                .bold()
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            // Placeholder for your high-res TaionWC images
                            // Image(card.imageName)
                            //    .resizable()
                            //    .aspectRatio(contentMode: .fit)
                            
                            Spacer()
                            
                            Text(card.meaning)
                                .font(.subheadline)
                                .italic()
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                        }
                        .padding(30)
                    )
                    .opacity(isFlipped ? 1 : 0)
                    // We rotate the front 180 degrees initially so it 
                    // looks right when it flips over
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            }
            // THE FLIP ANIMATION
            // This rotates the whole "ZStack" (Front and Back)
            .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
            .onTapGesture {
                // .spring() makes the animation feel "bouncy" and premium
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    isFlipped.toggle()
                }
            }
            
            // FEEDBACK TEXT
            Text(isFlipped ? "Tap to hide secrets" : "Tap to reveal the Codex")
                .font(.caption)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
                .kerning(2) // Adds space between letters for a "chic" look
        }
    }
}

// MARK: - PREVIEW AREA
// This lets you see the code working in the Xcode "Canvas"
struct TarotCodex_Possibilities_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCard = TarotCard(
            name: "The Magician",
            meaning: "Manifestation and Resourcefulness",
            imageName: "m01",
            suite: "Major"
        )
        
        TarotCardView(card: sampleCard)
            .preferredColorScheme(.dark) // Witchcraft apps look best in Dark Mode!
    }
}
