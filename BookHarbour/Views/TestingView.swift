//import SwiftUI
//
//struct TestingView: View {
//    let numberOfBooks = 200 // Set the total number of books
//    let booksPerRow = 10 // Set the number of books per row
//    let spacingBetweenBooks: CGFloat = 0
//    let verticalSpacingBetweenRows: CGFloat = 300
//
//    var body: some View {
//        ScrollView {
//            Spacer(minLength: 20)
//            Text("Library Title")
//                .font(.largeTitle)
//            LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 0, maximum: 75)), count: booksPerRow), spacing: 100) {
//                ForEach(0..<numberOfBooks) { bookIndex in
//                    BookView(bookNumber: bookIndex + 1)
//                }
//            }
//            .padding(20)
//        }
//    }
//}
//
//struct BookView: View {
//    let bookNumber: Int
//
//    var body: some View {
//        RoundedRectangle(cornerRadius: 10)
//            .frame(width: 80, height: 256)
//            .foregroundColor(Color.blue)
//            .overlay(
//                Text("Book \(bookNumber)")
//                    .foregroundColor(Color.white)
//            )
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestingView()
//    }
//}

import SwiftUI

struct Book: View {
    @Binding var offset: CGSize
    @Binding var isSnapped: Bool
    @State private var rotation: Angle = .degrees(0)

    var body: some View {
//        Image("bookCoverImage")
//            .resizable()
        Rectangle()
            .fill(Color.pink)
            .frame(width: 80, height: 256)
            .offset(x: offset.width, y: offset.height)
            .rotationEffect(rotation)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        offset = value.translation
                        isSnapped = false
                    }
                    .onEnded { _ in
                        let closestPosition = calculateClosestPosition(bookOffset: offset)
                        offset = closestPosition
                        isSnapped = true
                    }
            )
            .gesture(
                RotationGesture()
                    .onChanged { angle in
                        rotation = angle
                    }
            )
    }

    func calculateClosestPosition(bookOffset: CGSize) -> CGSize {
        // Implement logic to calculate the closest slot on the bookshelf
        // You might want to use the bookOffset and the positions of the slots to determine the closest one

        // For simplicity, let's assume you have a dynamic number of slots based on the number of books
        let numberOfBooks = 5
        let bookWidth: CGFloat = 80
        let spacing: CGFloat = 20

        let positions = (0..<numberOfBooks).map { index in
            CGSize(width: CGFloat(index) * (bookWidth + spacing), height: 0)
        }

        let distances = positions.map { distance(from: bookOffset, to: $0) }
        let closestIndex = distances.firstIndex(of: distances.min()!)!
        
        return positions[closestIndex]
    }

    func distance(from point1: CGSize, to point2: CGSize) -> CGFloat {
        let deltaX = point1.width - point2.width
        let deltaY = point1.height - point2.height
        return sqrt(deltaX * deltaX + deltaY * deltaY)
    }
}

struct Bookshelf: View {
    var numberOfBooks: Int = 5
    var booksPerRow : Int = 3

    var body: some View {
        HStack(spacing: 20) {
            ForEach(0..<numberOfBooks) { _ in
                // Design your bookshelf slots or layout here
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 80, height: 256)
            }
        }
    }
}

struct TestingView: View {
    @State private var bookOffset: CGSize = .zero
    @State private var isSnapped: Bool = false

    var body: some View {
        VStack {
            Bookshelf(numberOfBooks: 5)
                .overlay(
                    Book(offset: $bookOffset, isSnapped: $isSnapped)
                )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TestingView()
    }
}
