//
//  ContentView.swift
//  PinchApp
//
//  Created by Mindstix on 16/05/22.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Property
    @State private var isAnimating : Bool = false
    @State private var imageScale : CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    @State private var isDrawerOpen : Bool = false
    
    let pages: [Page] = pagesData
    @State private var pageIndex: Int = 1
    
    
    // MARK: - Function
    func resetImageState() {
        return withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    func currentPage() -> String {
        return pages[pageIndex - 1].imageName
    }
    
    
    // MARK: - Content
    
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                Color.clear
                Image(currentPage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .scaleEffect(imageScale)
                
                // MARK: 1 - TAP GESTURE
                    .onTapGesture(count: 2) {
                        if imageScale == 1 {
                            withAnimation(.spring()) {
                                imageScale = 5
                            }
                        } else {
                            resetImageState()
                        }
                    }
                
                // MARK: 2 - DRAG GESTURE
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                withAnimation(.linear(duration: 1)) {
                                    imageOffset = value.translation
                                }
                            })
                        
                            .onEnded({ _ in
                                if imageScale <= 1 {
                                    resetImageState()
                                    
                                }
                            })
                    )
                
                // MARK: Magnification
                    .gesture(
                    MagnificationGesture()
                        .onChanged({ value in
                            withAnimation(.linear(duration: 1)) {
                                if imageScale >= 1 && imageScale <= 5 {
                                    imageScale = value
                                }else if imageScale > 5 {
                                    imageScale = 5
                                }
                            }
                        })
                    
                        .onEnded({ _ in
                            if imageScale > 5 {
                                imageScale = 5
                            } else if imageScale <= 1 {
                                resetImageState()
                            }
                        })
                    )
                
            } // : Zstack
            .navigationTitle("Pinch & zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                withAnimation(.linear(duration: 1)) {
                    isAnimating = true
                }
            }
            
            // MARK: Info pannel :
            .overlay(
                InfoPannelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30)
                ,alignment: .top
            )
            
            //MARK: Controls
            .overlay(
                Group {
                    HStack {
                        // Scale Down
                        Button {
                            withAnimation(.spring()) {
                                if imageScale > 1 {
                                    imageScale -= 1
                                    
                                    if imageScale <= 1 {
                                        resetImageState()
                                    }
                                }
                            }
                        } label: {
                            ControlImageView(icon: "minus.magnifyingglass")
                        }
                        
                        // Reset
                        Button {
                            resetImageState()
                        } label: {
                            ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        
                        // ScaleUp
                        Button {
                            withAnimation(.spring()) {
                                if imageScale < 5 {
                                    imageScale += 1
                                    
                                    if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                                
                                
                            }
                        } label: {
                            ControlImageView(icon: "plus.magnifyingglass")
                        }

            
                    } // Controls
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                }
                    .padding(.bottom, 30)
                ,alignment: .bottom
            )
            
            // MARK: DRAWER
            .overlay(
                HStack(spacing: 12) {
                    // MARK: DRAWER HANDLE
                    Image(systemName: isDrawerOpen ? "chevron.compact.left" : "chevron.compact.right")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .onTapGesture {
                            withAnimation(.easeOut) {
                                isDrawerOpen.toggle()
                            }
                        }
                        
                    
                    // MARK: THUMBNAILS
                    
                    ForEach(pages) { item in
                        Image(item.thumbanailName)
                            .resizable()
                            .scaledToFit()
                            .frame(width : 80)
                            .cornerRadius(9)
                            .shadow(radius: 4)
                            .opacity(isDrawerOpen ? 1 : 0)
                            .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                            .onTapGesture(count: 1) {
                                isAnimating = true
                                pageIndex = item.id
                            }
                    }
                    Spacer()
                    
                    
                    
                } // DRAWER
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                    .background(.ultraThinMaterial)
                    .opacity(isAnimating ? 1 : 0)
                    .frame(width : 260)
                    .padding(.top, UIScreen.main.bounds.height / 12)
                    .offset(x : isDrawerOpen ? 20 : 215)
                , alignment: .topTrailing
            )
            
        } // : Navigation
        .navigationViewStyle(.stack)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 13")
    }
}
