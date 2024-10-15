//
//  PencilButton.swift
//  TravelJournal
//
//  Created by Silvia Esposito on 14/10/24.
//

import SwiftUI
struct FileEditPage: View {
        @State private var isFavorite = false // Stato per il cuore

        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                // Riga di pulsanti con icone
                HStack(spacing: 50) {
                    // Pulsante cuore
                    Button(action: {
                        isFavorite.toggle()
                    }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 24))
                            .foregroundColor(isFavorite ? .red : .primary)
                    }

                    // Pulsante suono
                    Button(action: {
                        print("Suono premuto")
                    }) {
                        Image(systemName: "waveform")
                            .font(.system(size: 24))
                            .foregroundColor(.primary)
                    }

                    // Pulsante immagine
                    Button(action: {
                        print("Immagine premuta")
                    }) {
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 24))
                            .foregroundColor(.primary)
                    }

                    // Pulsante fotocamera
                    Button(action: {
                        print("Fotocamera premuta")
                    }) {
                        Image(systemName: "camera")
                            .font(.system(size: 24))
                            .foregroundColor(.primary)
                    }

                    // Pulsante matita
                    Button(action: {
                        print("Modifica premuta")
                    }) {
                        Image(systemName: "pencil")
                            .font(.system(size: 24))
                            .foregroundColor(.primary)
                    }
                }
                .padding(.top)

                // Titolo
                Text("Naples")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)

                // Descrizione
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ultricies dapibus congue. Duis lacinia vulputate ligula, vitae volutpat orci tincidunt et.")
                    .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
    }

    struct JournalEdit_Previews: PreviewProvider {
        static var previews: some View {
            FileEditPage()
        }
    }

