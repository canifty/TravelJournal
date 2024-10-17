//
//  ContentView.swift
//  TravelJournal
//
//  Created by Can Dindar on 12/10/24.
//

import SwiftUI

struct ContentView: View {
    @State var showFolderSheet: Bool = false // State variable to control the display of the sheet for adding folders
    @State var dataArray: [(String, UIImage?)] = [] // Array to store folder names and their corresponding images
    @State var selectedFolder: (String, UIImage?)? = nil // To store the selected folder
    @State private var colorChange = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 143/255, green: 193/255, blue: 181/255).opacity(1), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                ).ignoresSafeArea()
                VStack {
                    // list to show folders with image and text
                    List(dataArray, id: \.0) { data in
                        ZStack {
                            if let image = data.1 {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame( height: 150)
                                    .clipped()
                                    .cornerRadius(10)
                                    .blur(radius: 2)
                            } else {
                                Rectangle()
                                    .foregroundStyle(.gray.opacity(0.4))
                                    .cornerRadius(10)
                            }
                            Text(data.0)
                                .font(.title)
                                .foregroundStyle(.white).bold()
                                .padding()
                                .cornerRadius(10)
                        }
                        .onTapGesture {
                            selectedFolder = data  // Set the selected folder
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .padding()
                    Spacer()
                    // Text to guide the user to add a new folder, visible only when no folders exist
                    if dataArray.isEmpty {
                        Text("Create your first folder")
                            .font(.headline)
                            .foregroundStyle(.gray)
                            .padding()
                    }
                    
                    // Button to show the sheet for adding a new folder
                    Button {
                        showFolderSheet.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }.font(.system(size: 70))
                        .foregroundStyle(Color(red: 88/255, green: 154/255, blue: 141/255))
                }
            }
            .navigationTitle("My Journeys")
            // Navigate to new view when a folder is selected
            .navigationDestination(isPresented: .constant(selectedFolder != nil), destination: {
                if let selectedFolder = selectedFolder {
                    FolderDetailView(folder: selectedFolder)
                }
            })
        }
        // Show the FolderAddButton sheet to allow users to add a folder
        .sheet(isPresented: $showFolderSheet) {
            FolderAddButton { newText, newImage in
                if !newText.isEmpty {
                    // Append the new folder and its image to the dataArray
                    dataArray.append((newText, newImage))
                }
            }
        }
    }
}
#Preview {
    ContentView()
}
