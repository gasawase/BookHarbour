//
//  MiscAdditionalFunctionality.swift
//  BookHarbour
//
//  Created by Summer Gasaway on 1/6/24.
//

import Foundation
import SwiftUI
import UIKit
import SwiftSoup

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        // Update the view controller if needed
    }
}

struct MiscAdditionalFunctionality {
    // Function to parse HTML and create NSAttributedString
    func parseHTML(_ html: String) throws -> NSAttributedString {
        let document = try SwiftSoup.parse(html)
        let bodyElement = try document.body()

        // Convert HTML to NSAttributedString
        let attrString = try NSAttributedString(data: bodyElement?.html().data(using: .utf8) ?? Data(),
                                               options: [.documentType: NSAttributedString.DocumentType.html,
                                                         .characterEncoding: String.Encoding.utf8.rawValue],
                                               documentAttributes: nil)

        return attrString
    }
}
