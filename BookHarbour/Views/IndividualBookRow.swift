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
        AsyncImage(url: URL(fileURLWithPath: ebook.coverImgPath ?? "")){ image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
          } placeholder: {
              Color.black
              //replace this with a stand-in image later
          }
          .frame(width: 160, height: 256)
//        Button{
//            self.isShowingBookDetails = true
//            print("\(ebook.title ?? "No Title") was selected and it is \(isShowingBookDetails)")
//        } label: {
//            AsyncImage(url: URL(fileURLWithPath: ebook.coverImgPath ?? "")){ image in
//                image
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//              } placeholder: {
//                  Color.black
//                  //replace this with a stand-in image later
//              }
//              .frame(width: 160, height: 256)
//        }
//        .sheet(isPresented: $isShowingBookDetails)
//        {
//            BookDetailsModalView(ebook: ebook)
//                .zIndex(1)
//        }
    }
}

