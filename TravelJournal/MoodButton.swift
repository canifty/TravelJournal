import SwiftUI

struct MoodButton: View {
    @State private var isExpanded = false  // To toggle the bubble expansion
    @State private var selectedEmotion: String?  // To store the selected emotion
    
    // Emotion options
    let emotions = ["😊", "😴", "😡", "🤔", "😢"]
    
    var body: some View {
        VStack {
            Spacer()
            
            // The floating mood bubble button or selected emoji
            ZStack {
                // Background bubbles for emotion options
                if isExpanded {
                    ForEach(0..<emotions.count, id: \.self) { index in
                        EmotionBubbleView(emotion: emotions[index], offset: indexOffset(index: index))
                            .onTapGesture {
                                withAnimation {
                                    selectedEmotion = emotions[index]
                                    isExpanded = false  // Collapse after selection
                                }
                            }
                    }
                }
                
                // Main mood button or selected emoji
                if let emotion = selectedEmotion {
                    // Show selected emotion
                    Text(emotion)
                        .font(.largeTitle)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .onTapGesture {
                            withAnimation {
                                isExpanded.toggle()  // Toggle expand/collapse
                            }
                        }
                } else {
                    // Show rainbow button if no emotion is selected
                    Button(action: {
                        withAnimation {
                            isExpanded.toggle()  // Toggle expand/collapse
                        }
                    }) {
                        Text("🌈")
                            .font(.largeTitle)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                }
            }
            .padding(.bottom, 40)  // Position above the bottom edge
        }
    }
    
    // Function to calculate the offset for each bubble based on its index
    func indexOffset(index: Int) -> CGSize {
        let angle = Double(index) * (360 / Double(emotions.count))  // Spread bubbles in a circle
        let xOffset = 80 * cos(angle * .pi / 180)
        let yOffset = 80 * sin(angle * .pi / 180)
        return CGSize(width: xOffset, height: yOffset)
    }
}

// View for the emotion bubble
struct EmotionBubbleView: View {
    var emotion: String
    var offset: CGSize
    
    var body: some View {
        Text(emotion)
            .font(.largeTitle)
            .padding()
            .background(Color.pink.opacity(0.8))
            .clipShape(Circle())
            .shadow(radius: 5)
            .offset(offset)  // Position bubbles around the main button
            .animation(.spring())  // Bouncing effect
    }
}

struct MoodButton_Previews: PreviewProvider {
    static var previews: some View {
        MoodButton()
    }
}
