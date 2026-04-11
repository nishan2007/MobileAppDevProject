//
//  CreatePostView.swift
//  SimpleSocial
//
//  Created by Nishan Narain on 4/8/26.
//

import SwiftUI
import PhotosUI

struct CreatePostView: View {
    let currentUserName: String

    @State private var caption: String = ""
    @State private var selectedCategory: FeedCategory = .travel
    @State private var showingSuccessMessage = false
    @State private var errorMessage: String? = nil
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImageData: Data?

    private func publishPost() {
        errorMessage = nil

        Task {
            do {
                _ = try await PostService.shared.createPost(
                    username: currentUserName,
                    category: selectedCategory,
                    caption: caption,
                    imageData: selectedImageData
                )
                NotificationCenter.default.post(name: .didCreatePost, object: nil)
                caption = ""
                selectedImageData = nil
                selectedPhotoItem = nil
                showingSuccessMessage = true

                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showingSuccessMessage = false
                }
            } catch let error as PostServiceError {
                errorMessage = error.errorDescription
                print("Error saving post: \(error)")
            } catch {
                errorMessage = "Something went wrong. Try again"
                print("Error saving post: \(error)")
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        Text("Create a Post")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("Pick a category, add an image if you want, and share something with the community.")
                            .foregroundStyle(.secondary)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.headline)

                            Picker("Category", selection: $selectedCategory) {
                                ForEach(FeedCategory.allCases.filter { $0 != .all }) { category in
                                    Text(category.rawValue).tag(category)
                                }
                            }
                            .pickerStyle(.segmented)
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Image")
                                .font(.headline)

                            PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                                HStack {
                                    Image(systemName: "photo")
                                    Text(selectedImageData == nil ? "Choose Image" : "Change Image")
                                }
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                            }

                            if let selectedImageData,
                               let uiImage = UIImage(data: selectedImageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Caption")
                                .font(.headline)

                            TextField("What's on your mind?", text: $caption, axis: .vertical)
                                .lineLimit(5...8)
                                .padding()
                                .background(Color(.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }

                        Button(action: publishPost) {
                            Text("Publish Post")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .disabled(caption.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .opacity(caption.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.55 : 1)

                        if showingSuccessMessage {
                            Text("Post published successfully.")
                                .font(.footnote)
                                .foregroundStyle(.green)
                        }

                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .font(.footnote)
                                .foregroundStyle(.red)
                        }

                        Spacer()
                    }
                    .padding(24)
                }
            }
            .navigationTitle("Create")
        }
        .task(id: selectedPhotoItem) {
            guard let selectedPhotoItem else { return }

            do {
                selectedImageData = try await selectedPhotoItem.loadTransferable(type: Data.self)
            } catch {
                errorMessage = "Unable to load the selected image."
                print("Image loading failed: \(error)")
            }
        }
    }
}

extension Notification.Name {
    static let didCreatePost = Notification.Name("didCreatePost")
}

#Preview {
    CreatePostView(currentUserName: "Nishan")
}
