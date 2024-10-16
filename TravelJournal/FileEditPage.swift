import SwiftUI
import UIKit
import PhotosUI

// Wrapper to make UIImage Identifiable
struct IdentifiableImage: Identifiable, Hashable {
    let id = UUID() // Unique ID for each image
    let image: UIImage
    
    // Conform to Hashable to allow usage in ForEach
    static func == (lhs: IdentifiableImage, rhs: IdentifiableImage) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct FileEditPage: View {
    @State var texFieldText: String = ""
    @State private var userInput = ""
    @State private var isShowingCamera = false
    @State private var isShowingPhotoLibrary = false
    @State private var selectedImages: [IdentifiableImage] = [] // Array of IdentifiableImage
    @State private var fullScreenImage: IdentifiableImage? = nil // To track the full-screen image
    @Environment(\.presentationMode) var presentationMode
    
    var onSave: (String, UIImage?) -> Void // Closure to handle save action

    var body: some View {
        NavigationStack {
            
            // Title
            TextField("Title", text: $texFieldText)
                .font(.largeTitle)
                .bold()
                .padding(.vertical)
            
            // Show all selected images with frames and scaling behavior
            if !selectedImages.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(selectedImages) { identifiableImage in
                            Image(uiImage: identifiableImage.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100) // Default size
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue, lineWidth: 2)
                                )
                                .shadow(radius: 5)
                                .onTapGesture {
                                    // Enlarge the image on tap
                                    fullScreenImage = identifiableImage
                                }
                                .onLongPressGesture {
                                    // Remove the image on long press with animation
                                    withAnimation {
                                        if let index = selectedImages.firstIndex(of: identifiableImage) {
                                            selectedImages.remove(at: index)
                                        }
                                    }
                                }
                                .transition(.scale)  // Smooth transition
                        }
                    }
                    .padding()
                }
            }

            // Text Editor for user input
            TextEditor(text: $userInput)
                .frame(height: 150)
                .padding()

            // Integrating MoodButton
            MoodsButton()
                .frame(maxWidth: .infinity) // Centra il bottone orizzontalmente
                        .padding(.bottom, -135)
            Spacer()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel").bold()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            // Call onSave closure when user clicks Done
                            let selectedImage = selectedImages.first?.image // Use the first selected image
                            onSave(userInput, selectedImage) // Pass back the input and image
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Create").bold()
                        }
                    }
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            isShowingPhotoLibrary = true
                        } label: {
                            Image(systemName: "photo.on.rectangle")
                                .font(.system(size: 24))
                                .foregroundColor(.primary)
                        }
                        .sheet(isPresented: $isShowingPhotoLibrary) {
                            ImagePicker(sourceType: .photoLibrary, selectedImages: $selectedImages)
                        }
                    }
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            isShowingCamera = true
                        } label: {
                            Image(systemName: "camera")
                                .font(.system(size: 24))
                                .foregroundColor(.primary)
                        }
                        .sheet(isPresented: $isShowingCamera) {
                            ImagePicker(sourceType: .camera, selectedImages: $selectedImages) // Mostra la fotocamera
                        }
                    }
                }
            .padding(.bottom, 40)
        }
        .padding()
        
        // Full-screen image view (if an image is selected for full-screen view)
        .fullScreenCover(item: $fullScreenImage) { identifiableImage in
            FullScreenImageView(image: identifiableImage.image) {
                fullScreenImage = nil // Close the full screen
            }
        }
    }
    
    // ImagePicker modified to support an array of IdentifiableImage
    struct ImagePicker: UIViewControllerRepresentable {
        var sourceType: UIImagePickerController.SourceType
        @Binding var selectedImages: [IdentifiableImage] // Changed to support an array of IdentifiableImage
        
        class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            let parent: ImagePicker
            
            init(parent: ImagePicker) {
                self.parent = parent
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                if let image = info[.originalImage] as? UIImage {
                    parent.selectedImages.append(IdentifiableImage(image: image)) // Add the image to the array as IdentifiableImage
                }
                picker.dismiss(animated: true)
            }
            
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                picker.dismiss(animated: true)
            }
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(parent: self)
        }
        
        func makeUIViewController(context: Context) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.delegate = context.coordinator
            return picker
        }
        
        func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    }
    
    // Full-screen image view
    struct FullScreenImageView: View {
        let image: UIImage
        var onDismiss: () -> Void
        
        var body: some View {
            ZStack(alignment: .topTrailing) {
                Color.black.edgesIgnoringSafeArea(.all)
                
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                
                Button(action: onDismiss) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .padding()
                }
            }
        }
    }
}

// MoodButton Code integrated
struct MoodsButton: View {
    @State private var isExpanded = false  // To toggle the bubble expansion
    @State private var selectedEmotion: String?  // To store the selected emotion
    @State private var showFeedback = false  // To show feedback after selection
    
    // Emotion options
    let emotions = ["😊", "😴", "😡", "🤔", "😢"]
    
    var body: some View {
        VStack {
            Spacer()
            
            // Show feedback after emotion selection
            if let emotion = selectedEmotion {
                Text("\(emotion)")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(10)
                    .transition(.scale)
            }
            
            Spacer()
            
            // The floating mood bubble button
            ZStack {
                // Background bubbles for emotion options
                if isExpanded {
                    ForEach(0..<emotions.count, id: \.self) { index in
                        EmotionsBubbleView(emotion: emotions[index], offset: indexOffset(index: index))
                            .onTapGesture {
                                withAnimation {
                                    selectedEmotion = emotions[index]
                                    isExpanded = false  // Collapse after selection
                                    showFeedback = true
                                }
                            }
                    }
                }
                
                // Main mood button
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
struct EmotionsBubbleView: View {
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

struct FileEditPage_Previews: PreviewProvider {
    static var previews: some View {
        FileEditPage { _, _ in }
    }
}
