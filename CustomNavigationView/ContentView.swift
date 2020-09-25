//
//  ContentView.swift
//  CustomNavigationView
//
//  Created by Sarah Alsharif on 9/12/20.
//  Copyright © 2020 Sarah Alsharif. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CustomNavigationView(destination: FirstView(), isRoot: true, isLast: false, color: .blue){
            Text("This is the Root View")
        }
    }
}

struct FirstView : View {
    var body: some View {
        CustomNavigationView(destination: SecondView(), isRoot: false, isLast: false, color: .red){
            Text("This is the First View")
        }
    }
}

struct SecondView : View {
    var body: some View {
        CustomNavigationView(destination: LastView(), isRoot: false, isLast: false, color: .green){
            Text("This is the Second View")
        }
    }
}

struct LastView : View {
    var body: some View {
        CustomNavigationView(destination: EmptyView(), isRoot: false, isLast: true, color: .yellow){
            Text("This is the Last View")
        }
    }
}

struct CustomNavigationView<Content: View, Destination : View>: View {
    let destination : Destination
    let isRoot : Bool
    let isLast : Bool
    let color : Color
    let content: Content
    @State var active = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    init(destination: Destination, isRoot : Bool, isLast : Bool,color : Color, @ViewBuilder content: () -> Content) {
        self.destination = destination
        self.isRoot = isRoot
        self.isLast = isLast
        self.color = color
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                Color.white
                VStack {
                    ZStack(alignment: .top) {
                        WaveShape()
                            .fill(color.opacity(0.3))
                        HStack {
                            Image(systemName: "arrow.left")
                                .frame(width: 30)
                                .onTapGesture(count: 1, perform: {
                                    self.mode.wrappedValue.dismiss()
                                }).opacity(isRoot ? 0 : 1)
                            Spacer()
                            Image(systemName: "command")
                                .frame(width: 30)
                            Spacer()
                            Image(systemName: "arrow.right")
                                .frame(width: 30)
                                .onTapGesture(count: 1, perform: {
                                    self.active.toggle()
                                })
                                .opacity(isLast ? 0 : 1)
                            NavigationLink(
                                destination: destination.navigationBarHidden(true)
                                    .navigationBarHidden(true),
                                isActive: self.$active,
                                label: {
                                    //no label
                                })
                        }
                        .padding([.leading,.trailing], 8)
                        .padding(.top, geometry.safeAreaInsets.top + 8)
                        .frame(width: geometry.size.width)
                        .font(.system(size: 22))
                        
                    }
                    .frame(width: geometry.size.width, height: 60 + geometry.safeAreaInsets.top)
                    .edgesIgnoringSafeArea(.top)
                    
                    Spacer()
                    self.content
                        .padding()
                        .background(color.opacity(0.3))
                        .cornerRadius(20)
                    Spacer()
                }
            }.navigationBarHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



struct WaveShape : Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addCurve(to: CGPoint(x: rect.minX, y: rect.maxY),
                      control1: CGPoint(x: rect.maxX * 0.75, y: rect.maxY * 0.5),
                      control2: CGPoint(x: rect.maxX * 0.35, y: rect.maxY * 2))
        return path
    }
}


extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}


