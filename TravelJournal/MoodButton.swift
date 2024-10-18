import SwiftUI

struct MoodButton: View {
    @State private var isExpanded = false  // To toggle the bubble expansion
    @State private var selectedImage: String?  // To store the selected emotion
    @State private var vibrateImages: [Bool] = [false, false, false, false, false]  // Track vibration state for each emoji
    @State private var showMoodText = true
    // Emotion options
    let images = ["1.l", "2.u", "3.m", "4.i"]
    var body: some View {
        VStack {
            Spacer()
            if showMoodText {
                           Text("Choose Your Mood")
                    .font(.subheadline)
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
                            ForEach(0..<images.count, id: \.self) { index in
                                EmotionBubbleView(imageName: images[index], isVibrating: $vibrateImages[index])
                                    .onTapGesture {
                                        withAnimation {
                                            selectedImage = images[index]
                                            isExpanded = false  // Collapse after selection
                                        }
                                    }
                                    .onAppear {
                                        vibrateImages[index] = true // Start vibration when the emoji appears
                                        // Stop vibrating after a short duration
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            vibrateImages[index] = false
                                        }
                                    }
                            }
                        }
                        .padding()
                    }
                }
                
                // Main mood button or selected emoji
                if let selected = selectedImage {
                    // Show selected emotion
                    Image(selected)
                        .resizable()
                        .frame(width: 50, height: 50)
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
    var imageName: String
    @Binding var isVibrating: Bool  // Binding to control the vibration state

    var body: some View {
        Image(imageName)
            
            .resizable()
            .frame(width: 50, height: 50)
            .font(.largeTitle)
            .padding()
            .background(Color.yellow.opacity(0.8))
            .clipShape(Circle())
            .shadow(radius: 5)
            .scaleEffect(isVibrating ? 1.1 : 1.0) // Scale effect for vibration
            .animation(isVibrating ? Animation.default.repeatForever(autoreverses: true) : .default) // Repeat animation for vibration
            .animation(.spring())  // Bouncing effect
    }
}

struct MoodButton_Previews: PreviewProvider {
    static var previews: some View {
        MoodButton()
    }
}
