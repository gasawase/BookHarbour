import SwiftUI

struct TestingView: View {
    @State private var isMenuVisible = true
    

    var body: some View {
        ZStack {
            Color.black
            Group(){
                Button(action: {
                    withAnimation {
                        isMenuVisible.toggle()
                    }
                }) {
                    Image(systemName: "ellipsis.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.gray)
                .clipShape(Circle())
                .shadow(radius: 5)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                if isMenuVisible{
                    Group(){
                        VStack {
                            Button(action: {
                                //                            appState.showReaderView.toggle()
                            }, label: {
                                Image(systemName: "arrowshape.turn.up.backward")
                            })
                            .padding()
                            //.cornerRadius(4)
                            .clipShape(RoundedRectangle(cornerRadius: 25.0))
                            .background(Color.white)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                }

            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TestingView()
    }
}
