//
//  CameraAndGalleryAccess.swift
//  NewTestProj
//
//  Created by Theappmedia on 9/8/22.
//

import UIKit
import SwiftUI
import AVKit

struct SUImagePickerView: UIViewControllerRepresentable {
    @Binding var sound : String
    @Binding var cc : Bool
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var image: Image?
    @Binding var isPresented: Bool
    @Binding var player : AVAudioPlayer!
    
    func makeCoordinator() -> ImagePickerViewCoordinator {
        print("from makeCoordinator")
        return ImagePickerViewCoordinator(sound: $sound, player: $player, image: $image, isPresented: $isPresented)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = sourceType
        pickerController.delegate = context.coordinator
        print("from makeUIViewController")
        return pickerController
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Nothing to update here
        print("from updateUIViewController")
        cc = false
    }

}

class ImagePickerViewCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @Binding var sound : String
    @Binding var player : AVAudioPlayer!
    @Binding var image: Image?
    @Binding var isPresented: Bool
    
    init(sound :Binding<String> ,player:Binding<AVAudioPlayer?>, image: Binding<Image?>, isPresented: Binding<Bool>) {
        self._sound = sound
        self._player = player
        self._image = image
        self._isPresented = isPresented
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.image = Image(uiImage: image)
        }
        self.isPresented = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.isPresented = false
        self.player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
        self.player.play()
        self.player.numberOfLoops = 30
    }
    
}
