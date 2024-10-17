import SwiftUI

struct MoodButton: View {
    @State private var isExpanded = false  // To toggle the bubble expansion
    @State private var selectedEmotion: String?  // To store the selected emotion
    @State private var shakeEmojis: [Bool] = [true, true, true, true, true]  // Track shaking state for each emoji
    @State private var showMoodText = true  // Track visibility of the "Choose Your Mood" text
    
    // Emotion options
    let emotions = ["😊", "😴", "😡", "🤔", "😢"]
    
    var body: some View {
        VStack {
            Spacer()
            
            // Show the "Choose Your Mood" text if no emotion is selected
            if showMoodText {
                Text("Choose Your Mood")
//                    .font(.subheadline)
                    .padding(.bottom)
                    .foregroundStyle(.gray)
                    .transition(.opacity)  // Add transition for smooth disappearance
            }

            // The floating mood bubble button or selected emoji
            VStack {
                // Background bubbles for emotion options
                if isExpanded {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<emotions.count, id: \.self) { index in
                                EmotionBubbleView(emotion: emotions[index], isShaking: $shakeEmojis[index])
                                    .onTapGesture {
                                        withAnimation {
                                            selectedEmotion = emotions[index]
                                            isExpanded = false  // Collapse after selection
                                            shakeEmojis[index] = false // Stop shaking for the selected emoji
                                            showMoodText = false // Hide the text after selection
                                        }
                                    }
                            }
                        }
                        .padding()
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
        }
    }
}

// View for the emotion bubble
struct EmotionBubbleView: View {
    var emotion: String
    @Binding var isShaking: Bool  // Binding to control the shaking state
    
    var body: some View {
        Text(emotion)
            .font(.largeTitle)
            .padding()
            .background(Color.pink.opacity(0.8))
            .clipShape(Circle())
            .shadow(radius: 5)
            .offset(x: isShaking ? -5 : 5)  // Shake effect by changing horizontal offset
            .animation(isShaking ? Animation.linear(duration: 0.1).repeatForever(autoreverses: true) : .default) // Repeat shaking animation
    }
}

struct MoodButton_Previews: PreviewProvider {
    static var previews: some View {
        MoodButton()
    }
}
