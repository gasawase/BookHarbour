//
//  IndividualBookRow.swift
//  BookHarbour
//
//  Created by Summer Gasaway on 1/2/24.
//

import SwiftUI

struct IndividualBookRow: View {
    @EnvironmentObject var currentBook: CurrentBook
    @State var isShowingBookDetails : Bool = false
    @Binding var isShowingReader : Bool
    
    var ebook : Ebooks
    
    var body: some View {
        
        //let newCoverURL = URL(string: ebook.coverImgPath ?? "")
        //Text(newCoverURL?.absoluteString ?? "")
        Button{
            print("\(ebook.title ?? "No Title") was selected")
            self.isShowingBookDetails.toggle()
        } label: {
            AsyncImage(url: URL(fileURLWithPath: ebook.coverImgPath ?? "")){ image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
              } placeholder: {
                  Color.black
                  //replace this with a stand-in image later
              }
              .frame(width: 160, height: 256)
        }
        .sheet(isPresented: $isShowingBookDetails)
        {
            BookDetailsModalView(ebook: ebook)
        }
        
//        if isShowingBookDetails{
//            ReaderView()
//        }
    }
}

