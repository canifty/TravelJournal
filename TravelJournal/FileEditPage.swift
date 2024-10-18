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
    @State var userInput = ""
    @State var isShowingCamera = false
    @State var isShowingPhotoLibrary = false
    @State var selectedImages: [IdentifiableImage] = [] // Array of IdentifiableImage
    @State var fullScreenImage: IdentifiableImage? = nil // To track the full-screen image
    @State private var startDate: Date = Date() // Data di inizio iniziale
    @State private var endDate: Date = Calendar.current.date(byAdding: .day, value: 7, to: Date())! // Data di fine iniziale
    @Environment(\.presentationMode) var presentationMode
    
    var onSave: (String, UIImage?) -> Void // Closure to handle save action
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 143/255, green: 193/255, blue: 181/255).opacity(1), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                ).ignoresSafeArea() // Set the background to green
                
                VStack {
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
                    
                    // TextEditor for user input
                    TextEditor(text: $userInput)
                        .frame(height: 150)
                        .padding()
                        .background(Color.green.opacity(0.2).cornerRadius(10))
                    
                    // Vista personalizzata per la selezione dell'intervallo di date
                    DateSelectionView(startDate: $startDate, endDate: $endDate)
                    
                    // MoodButton from external file
                    MoodButton()
                    
                }
                .padding()
            }
            .toolbar {
                // Leading cancel button
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                // Trailing create button
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
                
                // Photo Library button
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
                
                // Camera button
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        isShowingCamera = true
                    } label: {
                        Image(systemName: "camera")
                            .font(.system(size: 24))
                            .foregroundColor(.primary)
                    }
                    .sheet(isPresented: $isShowingCamera) {
                        ImagePicker(sourceType: .camera, selectedImages: $selectedImages) // Show camera
                    }
                }
            }
        }
        
        // Full-screen image view (if an image is selected for full-screen view)
        .fullScreenCover(item: $fullScreenImage) { identifiableImage in
            FullScreenImageView(image: identifiableImage.image) {
                fullScreenImage = nil // Close the full screen
            }
        }
    }
    
    // DateSelectionView per la selezione dell'intervallo di date con un solo DatePicker
    struct DateSelectionView: View {
        @Binding var startDate: Date
        @Binding var endDate: Date
        @State private var isDatePickerVisible = false
        @State private var selectingStartDate = true // Controlla se si sta selezionando la data di inizio

        var body: some View {
            VStack {
                // Pulsante per aprire il foglio modale per selezionare le date
                Button(action: {
                    isDatePickerVisible.toggle()
                    selectingStartDate = true // Imposta la selezione iniziale sulla data di inizio
                }) {
                    HStack {
                        Text("Select Date Range:")
                            .foregroundColor(.primary)
                        Spacer()
                        Text("\(startDate, formatter: dateFormatter) - \(endDate, formatter: dateFormatter)")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.green.opacity(0.2).cornerRadius(10))
                }
                .sheet(isPresented: $isDatePickerVisible) {
                    VStack {
                        Text(selectingStartDate ? "Select Start Date" : "Select End Date")
                            .font(.headline)
                            .padding()

                        // DatePicker singolo per selezionare la data
                        DatePicker("", selection: selectingStartDate ? $startDate : $endDate, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding()

                        // Pulsante per alternare tra la selezione della data di inizio e di fine
                        Button(selectingStartDate ? "Next: Select End Date" : "Finish") {
                            if selectingStartDate {
                                selectingStartDate = false // Passa alla selezione della data di fine
                            } else {
                                isDatePickerVisible = false // Chiudi il foglio modale dopo aver selezionato la data di fine
                            }
                        }
                        .padding()
                    }
                    .presentationDetents([.fraction(0.5), .medium]) // Imposta un'altezza intermedia per il foglio modale
                }
            }
        }

        // Formatter per la data
        private var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter
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

struct FileEditPage_Previews: PreviewProvider {
    static var previews: some View {
        FileEditPage { _, _ in }
    }
}
