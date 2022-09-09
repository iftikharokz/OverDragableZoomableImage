//
//  ContentView.swift
//  NewTestProj
//
//  Created by Theappmedia on 9/5/22.
//

import SwiftUI
//import SSSwiftUIGIFView
import AVKit
import SDWebImageSwiftUI

struct ContentView: View {
    @State var sound : String = ""
    @State var sourceType: UIImagePickerController.SourceType?
    @State private var selectedImage: Image?
    @State private var isImagePickerDisplay = false
    @State var audioPlayer: AVAudioPlayer!
    @State private var currentAmount = 0.0
    @State private var finalAmount = 1.0
    let imgArr = ["1","2","image"]
    let gifArr = ["gif","santa"]
    @State private var point : CGPoint = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2.5)
    @State var new :[UIImage] = []
    @State var gif = "santa"
    @State var showButtonView = false
    var body: some View {
        ZStack{
            VStack{
                ScrollView(.horizontal){
                    HStack{
                        ForEach(imgArr,id:\.self) { iG in
                            Image(iG)
                                .resizable()
                                .frame(width: 80, height: 100)
                                .onTapGesture {
                                    selectedImage = Image(iG)
                                }
                        }
                    }
                }
                ZStack{
                    selectedImage?
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width-5, height: UIScreen.main.bounds.height*0.6, alignment: .center)
                        .onTapGesture {
                            print(gif)
                        }
                    AnimatedImage(name: gif+".gif")
                        .resizable()
                        .frame(width: 200,height: 300,alignment: .center)
                        .position(point)
                        .scaleEffect(finalAmount+currentAmount)
                        .frame(width: UIScreen.main.bounds.width-5, height: UIScreen.main.bounds.height*0.6, alignment: .center)
                        .clipped()
                        .gesture(
                            MagnificationGesture()
                                .onChanged { amount in
                                    currentAmount = amount - 1
                                }
                                .onEnded { amount in
                                    finalAmount += currentAmount
                                    currentAmount = 0
                                }
                                .simultaneously(with:
                                                    DragGesture()
                                                    .onChanged {value in
                                                        if value.location.x < UIScreen.main.bounds.width*0.15*finalAmount/3{
                                                            point.x = UIScreen.main.bounds.width*0.16*finalAmount/3
                                                        }else{
                                                            if value.location.x>UIScreen.main.bounds.width*0.85*3/finalAmount{
                                                                point.x = UIScreen.main.bounds.width*0.85*2/finalAmount
                                                            }else{
                                                                point.x = value.location.x
                                                            }
                                                        }
                                                        if value.location.y < 20*finalAmount/2{
                                                            point.y = 50*finalAmount/2
                                                        }else{
                                                            print(UIScreen.main.bounds.width*0.95)
                                                            if value.location.y>UIScreen.main.bounds.height*0.57*1/finalAmount{
                                                                point.y = UIScreen.main.bounds.height*0.55*1/finalAmount
                                                            }else{
                                                                point.y = value.location.y
                                                            }
                                                        }
                                                    }
                                               )
                        )
                }
                
                HStack{
                    VStack(spacing:0){
                        Button {
                            showButtonView = true
                        } label: {
                            Text("Camera")
                                .fontWeight(.bold)
                                .frame(width: 80, height: 90)
                                .background(Color.cyan)
                        }
                    }
                    .foregroundColor(.white)
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(gifArr,id:\.self) { giff in
                               AnimatedImage(name: giff+".gif")
                                    .resizable()
                                    .frame(width: 80, height: 90)
                                    .onTapGesture {
                                        gif = giff
                                        print("Gif is Pressed")
    //                                    print(gif)
                                    }
                            }
                        }
                    }
                }
            }
            .onAppear(perform: {
                self.sound = Bundle.main.path(forResource: "audio", ofType: "mp3")!
                self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
                self.audioPlayer.play()
                self.audioPlayer.numberOfLoops = 30
            })
            .onChange(of: selectedImage, perform: { newValue in
                self.audioPlayer.stop()
                self.sound = Bundle.main.path(forResource: "audio", ofType: "mp3")!
                self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
                self.audioPlayer.play()
                self.audioPlayer.numberOfLoops = 30
            })
            .sheet(isPresented: self.$isImagePickerDisplay) {
                if sourceType == .photoLibrary{
                    SUImagePickerView(sound: $sound, cc: $showButtonView, sourceType: .photoLibrary, image: $selectedImage, isPresented: $isImagePickerDisplay, player: $audioPlayer)
                }else{
                    SUImagePickerView(sound: $sound, cc: $showButtonView, sourceType: .camera, image: $selectedImage, isPresented: $isImagePickerDisplay, player: $audioPlayer)
                }
            }
            .padding()
            .navigationBarHidden(true)
            .onDisappear {
                self.audioPlayer.stop()
            }
            if showButtonView{
                HStack{
                    Button {
                        sourceType = .camera
                        isImagePickerDisplay.toggle()
                    } label: {
                        Text("Camera")
                            .fontWeight(.bold)
                            .frame(width: 80, height: 45)
                            .background(Color.cyan)
                    }
                    .onAppear {
                        self.audioPlayer.stop()
                    }
                    Button {
                        sourceType = .photoLibrary
                        isImagePickerDisplay.toggle()
                    } label: {
                        Text("Gallery")
                            .fontWeight(.bold)
                            .frame(width: 80, height: 45)
                            .background(Color.brown)
                    }
                }
                .frame(width: 250, height: 300)
                .background(Color.gray)
                .foregroundColor(.white)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




















//import SwiftUI
////import SSSwiftUIGIFView
//import AVKit
//import SDWebImageSwiftUI
//
//struct ContentView: View {
//    @State var sourceType: UIImagePickerController.SourceType?
//    @State private var selectedImage: Image?
//    @State private var isImagePickerDisplay = false
//    @State var audioPlayer: AVAudioPlayer!
//    @State private var currentAmount = 0.0
//    @State private var finalAmount = 1.0
//    let imgArr = ["1","2","image"]
//    let gifArr = ["gif","santa"]
//    @State private var point : CGPoint = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2.5)
//    @State var new :[UIImage] = []
//    @State var gif = "santa"
//    var body: some View {
//        VStack{
//            ScrollView(.horizontal){
//                HStack{
//                    ForEach(imgArr,id:\.self) { iG in
//                        Image(iG)
//                            .resizable()
//                            .frame(width: 80, height: 100)
//                            .onTapGesture {
//                                selectedImage = Image(iG)
//                            }
//                    }
//                }
//            }
//            ZStack{
//                selectedImage?
//                    .resizable()
//                    .frame(width: UIScreen.main.bounds.width-5, height: UIScreen.main.bounds.height*0.6, alignment: .center)
//                    .onTapGesture {
//                        print(gif)
//                    }
//                AnimatedImage(name: gif+".gif")
//                    .resizable()
//                    .frame(width: 200,height: 300,alignment: .center)
//                    .position(point)
//                    .scaleEffect(finalAmount+currentAmount)
//                    .frame(width: UIScreen.main.bounds.width-5, height: UIScreen.main.bounds.height*0.6, alignment: .center)
//                    .clipped()
//                    .gesture(
//                        MagnificationGesture()
//                            .onChanged { amount in
//                                currentAmount = amount - 1
//                            }
//                            .onEnded { amount in
//                                finalAmount += currentAmount
//                                currentAmount = 0
//                            }
//                            .simultaneously(with:
//                                                DragGesture()
//                                                .onChanged {value in
//                                                    if value.location.x < UIScreen.main.bounds.width*0.15*finalAmount/3{
//                                                        point.x = UIScreen.main.bounds.width*0.16*finalAmount/3
//                                                    }else{
//                                                        if value.location.x>UIScreen.main.bounds.width*0.85*3/finalAmount{
//                                                            point.x = UIScreen.main.bounds.width*0.85*2/finalAmount
//                                                        }else{
//                                                            point.x = value.location.x
//                                                        }
//                                                    }
//                                                    if value.location.y < 20*finalAmount/2{
//                                                        point.y = 50*finalAmount/2
//                                                    }else{
//                                                        print(UIScreen.main.bounds.width*0.95)
//                                                        if value.location.y>UIScreen.main.bounds.height*0.57*1/finalAmount{
//                                                            point.y = UIScreen.main.bounds.height*0.55*1/finalAmount
//                                                        }else{
//                                                            point.y = value.location.y
//                                                        }
//                                                    }
//                                                }
//                                           )
//                    )
//            }
//
//            HStack{
//                VStack(spacing:0){
//                    Button {
//                        sourceType = .camera
//                        isImagePickerDisplay.toggle()
//                    } label: {
//                        Text("Camera")
//                            .fontWeight(.bold)
//                            .frame(width: 80, height: 45)
//                            .background(Color.cyan)
//                    }
//                    Button {
//                        sourceType = .photoLibrary
//                        isImagePickerDisplay.toggle()
//                    } label: {
//                        Text("Gallery")
//                            .fontWeight(.bold)
//                            .frame(width: 80, height: 45)
//                            .background(Color.brown)
//                    }
//                }
//                .foregroundColor(.white)
//                ScrollView(.horizontal){
//                    HStack{
//                        ForEach(gifArr,id:\.self) { giff in
//                           AnimatedImage(name: giff+".gif")
//                                .resizable()
//                                .frame(width: 80, height: 90)
//                                .onTapGesture {
//                                    gif = giff
//                                    print("Gif is Pressed")
////                                    print(gif)
//                                }
//                        }
//                    }
//                }
//            }
//        }
//        .sheet(isPresented: self.$isImagePickerDisplay) {
//            if sourceType == .photoLibrary{
//                SUImagePickerView(sourceType: .photoLibrary, image: $selectedImage, isPresented: $isImagePickerDisplay)
//            }else{
//                SUImagePickerView(sourceType: .camera, image: $selectedImage, isPresented: $isImagePickerDisplay)
//            }
//        }
//        .padding()
//        .navigationBarHidden(true)
//        .onAppear {
//            let sound = Bundle.main.path(forResource: "audio", ofType: "mp3")
//            self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
//            //            self.audioPlayer.play()
//            self.audioPlayer.numberOfLoops = 30
//        }
//        .onDisappear {
//            self.audioPlayer.stop()
//        }
//    }
//}




























//drawImage(image: UIImage(named: "image")!,image2: UIImage(named: "02")!, bgSize: CGRect(x: 0, y: 0, width: (image1?.size.width)!, height: (image1?.size.height)!), overlaySize: CGRect(x: offset.width, y: offset.height,width:imgSize.width , height:imgSize.height))




//func drawImage(image:UIImage,image2:UIImage, bgSize:CGRect,overlaySize:CGRect) -> UIImage {
//    let canvasBg = CGSize(width: bgSize.width, height: bgSize.height)
//    let canvasOverlay = CGSize(width: overlaySize.width, height: overlaySize.height)
//    UIGraphicsBeginImageContextWithOptions(canvasBg, false, 1.0)
//    image.draw(in: CGRect(x: 0, y: 0, width: canvasBg.width, height: canvasBg.height))
//    image2.draw(in: overlaySize)
//    let renderImage = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//    return renderImage!
//}



//            ZStack{
//
//                Image(uiImage: image1!)
//                    .resizable()
//                    .scaledToFit()
//                    .position(x: UIScreen.main.bounds.width*0.5, y: UIScreen.main.bounds.height*0.5)
//                Image(uiImage: image2!)
//                    .resizable()
////                    .scaleEffect(finalAmount+currentAmount)
////                    .offset(offset)
//                    .frame(width: imgSize.width, height: imgSize.height)
//                    .position(point)
//                    .gesture(
//                        MagnificationGesture()
//                            .onChanged { amount in
//                                currentAmount = amount - 1
//                                imgSize = CGSize(width: imgSize.width*currentAmount, height: imgSize.height*currentAmount)
//                            }
//                            .onEnded { amount in
//                                finalAmount += currentAmount
//                                currentAmount = 0
//                                imgSize = CGSize(width: imgSize.width*finalAmount, height: imgSize.height*finalAmount)
//                                if imgSize.height<70{
//                                    imgSize =  CGSize(width: 65, height: 80)
//                                }
//                                if imgSize.height > UIScreen.main.bounds.height*0.8{
//                                    imgSize =  CGSize(width: 400, height: 500)
//                                }
//                            }
//                            .simultaneously(with:
//                                                DragGesture()
//                                                .onChanged { value in
//                                                    offset = value.translation
//                                                    point = value.location
//                                                }
//                                                .onEnded { val in
//                                                    withAnimation {
//                                                        point = val.location
//                                                        offset = val.translation
//                                                        isDragging = false
//                                                    }
//                                                }
//                                           )
//
//                    )
//            }
//            VStack{
//                Text("Frame:\(imgSize.width),\(imgSize.height)")
//                    .fontWeight(.bold)
//                    .font(.title3)
//                Text("Offset:\(point)" as String)
//                    .fontWeight(.bold)
//                    .font(.title3)
//                Button {
//                    image = drawImage(image: image2!, inImage: image1!, atPoint: point)
//                    openImageView.toggle()
//                } label: {
//                    Text("Draw")
//                        .padding()
//                        .background(Color.yellow)
//                }
//            }
//            .foregroundColor(.cyan)


//func drawImage(image foreGroundImage:UIImage, inImage backgroundImage:UIImage, atPoint point:CGPoint) -> UIImage {
//    UIGraphicsBeginImageContextWithOptions(backgroundImage.size, false, 0.0)
//    backgroundImage.draw(in: CGRect.init(x: 0, y: 0, width: backgroundImage.size.width, height: backgroundImage.size.height))
//    foreGroundImage.draw(in: CGRect.init(x: point.x, y: point.y, width: foreGroundImage.size.width, height: foreGroundImage.size.height))
//    let newImage = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//    return newImage!
//}
