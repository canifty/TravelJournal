//
//  AddImage.swift
//  TravelJournal
//
//  Created by Can Dindar on 12/10/24.
//
import PhotosUI
import SwiftUI

struct AddImage: View {
    @State var pickerItem: PhotosPickerItem? // State variable for the selected item from the Photos picker
    @Binding var selectedImage: UIImage? // Binding variable to hold and add the selected image to a another view
    
    var body: some View {
        VStack {
            // PhotosPicker to allow the user to select an image
            PhotosPicker( selection: $pickerItem, matching: .images) {
                Label("Select a Cover", systemImage: "photo") }
            .padding()
            // Display the selected image if it exists
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 280, height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        // When the selected item changes, load the image
        .onChange(of: pickerItem) {
            Task {
                if let data = try? await pickerItem?.loadTransferable(type: Data.self) {
                    let uiImage = UIImage(data: data)
                    selectedImage = uiImage
                }
            }
        }
    }
}
#Preview {
    AddImage(selectedImage: .constant(nil))
}
