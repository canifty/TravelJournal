import SwiftUI

struct FolderAddButton: View {
    @State var texFieldText: String = "" // State variable for the text field input
    @State var selectedImage: UIImage?
    var onAdd: (String, UIImage?) -> Void // closure to pass back the new text
    @Environment(\.dismiss) var dismiss // Environment variable to dismiss the sheet
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 143/255, green: 193/255, blue: 181/255).opacity(1), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                ).ignoresSafeArea()
                VStack {
                    // TextField for entering the folder name
                    TextField("Placeholder", text: $texFieldText)
                        .padding()
                        .background(Color.gray.opacity(0.4).cornerRadius(10))
                        .frame(maxWidth: 380)
                    // Include the AddImage view to upload images
                    AddImage(selectedImage: $selectedImage)
                        .padding()
                        .buttonBorderShape(.roundedRectangle)
                        .background(Color.gray.opacity(0.4).cornerRadius(10))
                    Spacer()
                }
                // Toolbar with buttons for navigation and actions
                .toolbar {
//                    ToolbarItem(placement: .principal) {
//                        Text("New Folder").font(.headline)
//                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Text("Cancel")
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            onAdd(texFieldText, selectedImage)  // Call the closure with the folder name and dismiss
                            dismiss()
                            // saveText()
                        } label: {
                            Text("Done").bold()
                        }
                    }
                }
            }
        }
    }
}
#Preview {
    FolderAddButton {_, _ in }
}
