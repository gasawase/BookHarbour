//
//  IndividualBookRow.swift
//  BookHarbour
//
//  Created by Summer Gasaway on 1/2/24.
//

import SwiftUI

struct IndividualBookRow: View {
    @EnvironmentObject var currentBook: CurrentBook
    @Binding var isShowingReader : Bool
    
    @ObservedObject var ebook : Ebooks
    
    var body: some View {
        ZStack {
            AsyncImage(url: URL(fileURLWithPath: ebook.coverImgPath ?? "")){ image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Color.black
                //replace this with a stand-in image later
            }
            .frame(width: 160, height: 256)
            
            Rectangle()
                .fill(Color.black.opacity(0.4))
                .frame(width: 160, height: 20)
                .offset(y: 128)
                .blur(radius: 10)
        }
        .shadow(radius: 5) // Add shadow effect
    }
}


