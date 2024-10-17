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
    @State var texFieldText: String = "" // Title
    @State var userInput = ""             // Text input
    @State var isShowingCamera = false
    @State var isShowingPhotoLibrary = false
    @State var selectedImages: [IdentifiableImage] = [] // Array of IdentifiableImage
    @State var fullScreenImage: IdentifiableImage? = nil // Full-screen image
    @Environment(\.presentationMode) var presentationMode
    
    // Closure to handle save action, now passing title, text, and image
    var onSave: (String, String, UIImage?) -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 143/255, green: 193/255, blue: 181/255).opacity(1), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                ).ignoresSafeArea()
                
                VStack {
                    // Title
                    TextField("Title", text: $texFieldText)
                        .font(.largeTitle)
                        .bold()
                        .padding(.vertical)
                    
                    // Display selected images
                    if !selectedImages.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(selectedImages) { identifiableImage in
                                    Image(uiImage: identifiableImage.image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .onTapGesture {
                                            fullScreenImage = identifiableImage
                                        }
                                        .onLongPressGesture {
                                            withAnimation {
                                                selectedImages.removeAll { $0.id == identifiableImage.id }
                                            }
                                        }
                                }
                            }
                            .padding()
                        }
                    }
                    
                    // Text input
                    TextEditor(text: $userInput)
                        .frame(height: 250)
                        .padding()
                        .background(Color.green.opacity(0.2).cornerRadius(10))
                    Spacer()

                }
                .padding()
                
                MoodButton()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Create") {
                        let selectedImage = selectedImages.first?.image
                        onSave(texFieldText, userInput, selectedImage) // Pass title, text, and image
                        presentationMode.wrappedValue.dismiss()
                    }
                    .bold()
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        isShowingPhotoLibrary = true
                    } label: {
                        Image(systemName: "photo.on.rectangle")
                            .font(.title2)
                            .foregroundStyle(Color(red: 88/255, green: 154/255, blue: 141/255))
                    }
                    .sheet(isPresented: $isShowingPhotoLibrary) {
                        ImagePicker(sourceType: .photoLibrary, selectedImages: $selectedImages)
                    }
                    
                    // Spacer to push the MoodButton to the center
                   
                    Button {
                        isShowingCamera = true
                    } label: {
                        Image(systemName: "camera")
                            .font(.title2)
                            .foregroundStyle(Color(red: 88/255, green: 154/255, blue: 141/255))
                    }
                    .sheet(isPresented: $isShowingCamera) {
                        ImagePicker(sourceType: .camera, selectedImages: $selectedImages)
                    }
                }
            }
        }
        .fullScreenCover(item: $fullScreenImage) { identifiableImage in
            FullScreenImageView(image: identifiableImage.image) {
                fullScreenImage = nil
            }
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

struct FileEditPage_Previews: PreviewProvider {
    static var previews: some View {
        FileEditPage {_, _, _ in }
    }
}
