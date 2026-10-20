
import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var photo: UIImage?
    @State private var prompt = ""
    @State private var format = "Paysage 16:9"
    @State private var status = "Choisis une image pour commencer."

    var body: some View {
        NavigationStack {
            Form {
                Section("Image de départ") {
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images
                    ) {
                        Label("Choisir une photo", systemImage: "photo")
                    }

                    if let photo {
                        Image(uiImage: photo)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }

                Section("Décris ta vidéo") {
                    TextField(
                        "Ex. : anime les personnages et fais-les sourire",
                        text: $prompt,
                        axis: .vertical
                    )
                    .lineLimit(3...6)

                    Picker("Format", selection: $format) {
                        Text("Paysage 16:9").tag("Paysage 16:9")
                        Text("Portrait 9:16").tag("Portrait 9:16")
                        Text("Carré 1:1").tag("Carré 1:1")
                    }
                }

                Section {
                    Button {
                        status = "Interface prête. Le moteur IA reste à connecter."
                    } label: {
                        Label("Préparer ma vidéo", systemImage: "film")
                    }
                    .disabled(photo == nil || prompt.isEmpty)

                    Text(status)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("VideoIA")
            .task(id: selectedItem) {
                guard let selectedItem else { return }
                if let data = try? await selectedItem.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    photo = image
                }
            }
        }
    }
}
