import SwiftUI

struct FolderDetailView: View {
    var folder: (String, UIImage?) // The folder (name and optional image)
    @State var showFileEditPage = false // Toggle to show FileEditPage
    @State var selectedFile: (String, String, UIImage?)? = nil // Store selected file for editing
    @State var dataArray: [(String, String, UIImage?)] = [] // Array to store title, text, and image
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 143/255, green: 193/255, blue: 181/255).opacity(1), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Check if there are files to display
                if dataArray.isEmpty {
                    Text("Create your first file")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(dataArray.indices, id: \.self) { index in
                        let file = dataArray[index]
                        VStack {
                            // Organized frame for each file (title, text, image)
                            VStack(alignment: .leading, spacing: 10) {
                                // Optional image
                                if let image = file.2 {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 150)
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                        )
                                }
                                
                                // Title
                                Text(file.0)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                // Text preview with a two-line limit
                                Text(file.1)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .lineLimit(2) // Limit text to 2 lines
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                        }
                        .listRowBackground(Color.clear) // Remove default row background
                        .listRowSeparator(.hidden) // Hide separators between rows
                        .onTapGesture {
                            // Set the selected file for editing
                            selectedFile = dataArray[index]
                            showFileEditPage.toggle()
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .padding(.horizontal) // Add some horizontal padding for neatness
                }
                
                // Button to create a new file
                Button {
                    selectedFile = nil // Clear selected file for new creation
                    showFileEditPage.toggle()
                } label: {
                    Label("Add File", systemImage: "plus.circle.fill")
                        .font(.title)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(red: 88/255, green: 154/255, blue: 141/255))
                        .cornerRadius(10)
                        .shadow(radius: 4)
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("\(folder.0)").font(.headline)
                    }
                }
            }
        }
        .sheet(isPresented: $showFileEditPage) {
            if let fileToEdit = selectedFile {
                // Edit existing file
                FileEditPage(texFieldText: fileToEdit.0, userInput: fileToEdit.1, selectedImages: fileToEdit.2 != nil ? [IdentifiableImage(image: fileToEdit.2!)] : []) { updatedTitle, updatedText, updatedImage in
                    if let index = dataArray.firstIndex(where: { $0.0 == fileToEdit.0 }) {
                        dataArray[index] = (updatedTitle, updatedText, updatedImage)
                    }
                }
            } else {
                // Create new file
                FileEditPage { newTitle, newText, newImage in
                    dataArray.append((newTitle, newText, newImage))
                }
            }
        }
    }
}

#Preview {
    FolderDetailView(folder: ("My Folder", nil))
}
