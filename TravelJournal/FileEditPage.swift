import SwiftUI
import UIKit

struct FileEditPage: View {
    @State private var userInput = ""
    @State private var isShowingCamera = false
    @State private var isShowingPhotoLibrary = false
    @State private var selectedImages: [UIImage] = [] // Array di immagini
    @State private var isFavorite = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding(.leading)
                
                Spacer()
                
                Button("Done") {
                    saveData()
                    presentationMode.wrappedValue.dismiss()
                }
                .padding(.trailing)
            }
            .padding(.top)
            
            Text("Naples")
                .font(.largeTitle)
                .bold()
                .padding(.vertical)
            
            TextEditor(text: $userInput)
                .frame(height: 150)
                .padding()
            
            // Mostra tutte le immagini selezionate
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
            
            // Barra inferiore con pulsanti
            HStack(spacing: 50) {
                // Pulsante cuore
                Button(action: {
                    isFavorite.toggle() // Cambia lo stato del cuore
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 24))
                        .foregroundColor(isFavorite ? .red : .primary)
                }
                Button(action: {
                        print("Suono premuto")
                                    })
                { Image(systemName: "waveform")
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
                
                // Pulsante fotocamera
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
    
    // Modifica ImagePicker per supportare array di immagini
    struct ImagePicker: UIViewControllerRepresentable {
        var sourceType: UIImagePickerController.SourceType
        @Binding var selectedImages: [UIImage] // Cambiato per supportare un array di immagini
        
        class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            let parent: ImagePicker
            
            init(parent: ImagePicker) {
                self.parent = parent
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                if let image = info[.originalImage] as? UIImage {
                    parent.selectedImages.append(image) // Aggiungi l'immagine all'array
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
    
    func saveData() {
        // Logica per salvare i dati
        print("Dati salvati: \(userInput)")
        print("Immagini selezionate: \(selectedImages.count)")
    }
    
    struct FileEditPage_Previews: PreviewProvider {
        static var previews: some View {
            FileEditPage()
        }
    }
}
