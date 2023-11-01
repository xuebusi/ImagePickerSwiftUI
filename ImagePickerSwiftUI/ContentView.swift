//
//  ContentView.swift
//  ImagePickerSwiftUI
//
//  Created by shiyanjun on 2023/11/1.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ImagePickerView()
            .preferredColorScheme(.dark)
    }
}

struct ContentView_previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
