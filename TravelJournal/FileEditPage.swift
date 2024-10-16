import SwiftUI
import UIKit

struct FileEditPage: View {
    @State private var userInput = ""
    @State private var isShowingCamera = false
    @State private var isShowingPhotoLibrary = false
    @State private var selectedImages: [UIImage] = [] // Array of images
    @State private var isFavorite = false
    @Environment(\.presentationMode) var presentationMode
    
    var onSave: (String, UIImage?) -> Void // Closure to handle save action

    var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding(.leading)
                
                Spacer()
                
                Button("Done") {
                    // Call onSave closure when user clicks Done
                    let selectedImage = selectedImages.first // Use the first selected image
                    onSave(userInput, selectedImage) // Pass back the input and image
                    presentationMode.wrappedValue.dismiss()
                }
                .padding(.trailing)
            }
            .padding(.top)
            
            Text("Naples")
                .font(.largeTitle)
                .bold()
                .padding(.vertical)
            
            TextEditor( text: $userInput)
                .frame(height: 150)
                .padding()
            
            // Show all selected images
            if !selectedImages.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(selectedImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                }
            }
            
            Spacer()
            
            // Bottom bar with buttons
            HStack(spacing: 50) {
                // Heart button
                Button(action: {
                    isFavorite.toggle()
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 24))
                        .foregroundColor(isFavorite ? .red : .primary)
                }

                Button(action: {
                   
                }) {
                    Image(systemName: "waveform")
                        .font(.system(size: 24))
                        .foregroundColor(.primary)
                }
                
                Button(action: {
                    isShowingPhotoLibrary = true
                }) {
                    Image(systemName: "photo.on.rectangle")
                        .font(.system(size: 24))
                        .foregroundColor(.primary)
                }
                .sheet(isPresented: $isShowingPhotoLibrary) {
                    ImagePicker(sourceType: .photoLibrary, selectedImages: $selectedImages)
                }
                
                // Camera button
                Button(action: {
                    isShowingCamera = true
                }) {
                    Image(systemName: "camera")
                        .font(.system(size: 24))
                        .foregroundColor(.primary)
                }
                .sheet(isPresented: $isShowingCamera) {
                    ImagePicker(sourceType: .camera, selectedImages: $selectedImages)
                }
            }
            .padding(.bottom, 40)
        }
        .padding()
    }
    
    // ImagePicker modified to support an array of images
    struct ImagePicker: UIViewControllerRepresentable {
        var sourceType: UIImagePickerController.SourceType
        @Binding var selectedImages: [UIImage] // Changed to support an array of images
        
        class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            let parent: ImagePicker
            
            init(parent: ImagePicker) {
                self.parent = parent
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                if let image = info[.originalImage] as? UIImage {
                    parent.selectedImages.append(image) // Add the image to the array
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
    
    
}

struct FileEditPage_Previews: PreviewProvider {
    static var previews: some View {
        FileEditPage { _, _ in }
    }
}
