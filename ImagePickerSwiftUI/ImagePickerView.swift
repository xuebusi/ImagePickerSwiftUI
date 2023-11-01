//
//  ImagePickerView.swift
//  HelloSwiftUI
//
//  Created by shiyanjun on 2023/11/1.
//
import SwiftUI
import PhotosUI

// 使用ImagePicker的SwiftUI视图。
struct ImagePickerView: View {
    // 存储选择的图片
    @State var selectedImage: UIImage?
    // 控制是否显示图片选择器
    @State var showingImagePicker: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            // 如果有选择的图片，则显示它。
            if let selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
            }
            
            // 点击按钮显示图片选择器。
            Button {
                showingImagePicker.toggle()
            } label: {
                Text("选择图片")
                    .padding()
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(.purple)
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal)
        // 使用sheet方法显示ImagePicker。
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $selectedImage)
        }
    }
}

struct ImagePickerView_previews: PreviewProvider {
    static var previews: some View {
        ImagePickerView()
            .preferredColorScheme(.dark)
    }
}

// 使用UIKit中的PHPickerViewController来创建一个SwiftUI视图，以便用户可以选择图片。
struct ImagePicker: UIViewControllerRepresentable {
    
    // 绑定的UIImage，用于存储用户选择的图片。
    @Binding var image: UIImage?
    
    // Coordinator类，用于处理PHPickerViewController的代理方法。
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        
        // ImagePicker的引用，以便我们可以更新其绑定的图片。
        var parent: ImagePicker
        
        // 初始化方法。
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        // 当用户完成图片选择后的代理方法。
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            // 关闭图片选择器
            picker.dismiss(animated: true)
            
            // 从结果中获取第一个itemProvider
            guard let provider = results.first?.itemProvider else { return }
            
            // 如果itemProvider可以加载UIImage，则进行加载
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, error in
                    if let error = error {
                        print("Image loading error: \(error.localizedDescription)")
                        return
                    }
                    // 将加载的图片赋值给绑定的image属性。
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
    
    // 创建并返回一个PHPickerViewController
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        // 只允许选择图片
        config.filter = .images
        let imagePicker = PHPickerViewController(configuration: config)
        // 设置代理为Coordinator
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    // 更新UIViewController的方法，但在这里我们不需要任何操作。
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    // 创建并返回Coordinator的实例。
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
