import SwiftUI

struct FolderDetailView: View {
    var folder: (String, UIImage?) // The folder (name and optional image)
    @State var showFileEditPage = false // State variable to toggle FileEditPage sheet
    @State var dataArray: [(String, UIImage?)] = [] // Array to store folder names and their corresponding images
    
    var body: some View {
            VStack {
                Spacer()
                
                if dataArray.isEmpty {
                    Text("Create your first file")
                        .font(.headline)
                        .foregroundStyle(.gray)
                        .padding()
                } else {
                    List(dataArray, id: \.0) { file in
                        VStack {
                            if let image = file.1 {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame( height: 150)
                                    .clipped()
                                    .cornerRadius(10)
                            }
                            Text(file.0)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
                Button {
                    showFileEditPage.toggle()
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
                .font(.system(size: 70))
                .padding()
                
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("\(folder.0)").font(.headline)
                    }
                }
            }
            .sheet(isPresented: $showFileEditPage) {
                FileEditPage { newFileName, newImage in
                    dataArray.append((newFileName, newImage)) // Append new file to dataArray
                }
            }
    }
}
#Preview {
    FolderDetailView(folder: ("My Folder", nil))
}
