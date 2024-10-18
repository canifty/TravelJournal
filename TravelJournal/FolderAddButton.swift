import SwiftUI

struct FolderAddButton: View {
    @State var texFieldText: String = "" // State variable for the text field input
    @State var selectedImage: UIImage?
    var onAdd: (String, UIImage?) -> Void // Closure to pass back the new text
    @Environment(\.dismiss) var dismiss // Environment variable to dismiss the sheet
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 143/255, green: 193/255, blue: 181/255).opacity(1), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                ).ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // TextField for entering the folder name
                    TextField("Folder Name", text: $texFieldText)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    
                    // Include the AddImage view to upload images
                    AddImage(selectedImage: $selectedImage)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    
                    Spacer()
                }
                .padding()
                
                // Toolbar with buttons for navigation and actions
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Create") {
                            onAdd(texFieldText, selectedImage)  // Call the closure with the folder name and dismiss
                            dismiss()
                        }
                        .bold()
                        .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

#Preview {
    FolderAddButton { _, _ in }
}
