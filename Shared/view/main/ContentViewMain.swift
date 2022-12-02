//
//  ContentViewMain.swift
//  basketballGameStatsTracker (iOS)
//
//  Created by 范志勇 on 2022/11/29.
//

import SwiftUI

struct ContentViewMain: View {
    @State var isActive : Bool = false

    var body: some View {
        NavigationView {
            //isActive: A binding to a Boolean value that indicates whether destination is currently presented.
            NavigationLink(
                destination: ContentView2(rootIsActive: self.$isActive),
                isActive: self.$isActive
            ) {
                Text("Hello, World!")
            }
            //If isDetailLink is false, the link navigates to the destination view within the primary column.
            //If you do not set the detail link behavior with this method, the behavior defaults to true.
            .isDetailLink(false) // 缺省为true
            .navigationBarTitle("Root")
        }
    }
}

struct ContentView2: View {
    
    @Binding var rootIsActive : Bool

    var body: some View {
        NavigationLink(destination: ContentView3(shouldPopToRootView: self.$rootIsActive)) {
            Text("Hello, World #2!")
        }
        .isDetailLink(false)
        .navigationBarTitle("Two")
    }
}

struct ContentView3: View {
    @Binding var shouldPopToRootView : Bool

    var body: some View {
        VStack {
            Text("Hello, World #3!")
            Button (action: { self.shouldPopToRootView = false } ){
                Text("Pop to root")
            }
        }.navigationBarTitle("Three")
    }
}

struct ContentViewMain_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewMain()
    }
}
