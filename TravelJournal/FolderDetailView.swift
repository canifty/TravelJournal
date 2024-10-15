import SwiftUI

struct FolderDetailView: View {
    var folder: (String, UIImage?) // The folder (name and optional image)
    
    var body: some View {
        VStack {
            Text(folder.0) // Folder name
                .font(.largeTitle)
                .bold()
                .padding()
            
            if let image = folder.1 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    
                    .cornerRadius(10)
            } else {
                Rectangle()
                    .frame(width: 350 , height: 200)
                    .foregroundColor(.gray.opacity(0.4))
                    .cornerRadius(20)
            }
            
            
            
            Spacer()
        }
        .navigationTitle("Folder Details")
    }
}

#Preview {
    FolderDetailView(folder: ("My Folder", nil))
}
