import SwiftUI

class TestingEbook : ObservableObject {
    @Published var title = "Default Title"
    @Published var author = "Default author"
    @Published var synopsis = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent lobortis, massa et tristique sodales, tellus erat iaculis mauris, vitae pulvinar diam urna eu magna. Integer efficitur, lectus eget imperdiet maximus, urna eros faucibus ante, at sodales nulla elit sed urna. Vestibulum tempus ornare lectus at fringilla. Fusce scelerisque et elit ut venenatis. Praesent dapibus dui est, ac placerat sem pretium nec. Maecenas auctor molestie scelerisque. Pellentesque tincidunt lacus sed ex convallis blandit. Donec vestibulum nisl mauris, quis fringilla ante malesuada vitae. Pellentesque vulputate volutpat sapien, et facilisis metus sodales in. Ut laoreet facilisis facilisis. \n Nulla sodales tortor a dictum posuere. Phasellus sit amet magna risus. Fusce non dui ultrices, gravida magna id, venenatis lorem. In interdum et tortor sed viverra. Cras sagittis vehicula viverra. Curabitur commodo nulla ut nisl venenatis convallis. Cras eget sem tempus, fringilla erat sit amet, vehicula metus. Maecenas sed enim at neque pulvinar finibus vel vel purus. Nam ut magna sit amet eros consequat porta. Fusce finibus et turpis non malesuada. Aliquam semper euismod iaculis. Donec nec turpis commodo, volutpat eros ut, viverra neque. Integer quis lacinia nisl. Donec congue purus eget neque fermentum aliquam. Ut iaculis varius lacus."
}

struct TestingView : View{
    @State var selectedTag = ""
    
    var tempArr : [String] = ["","First Tag", "Second Tag", "Third Tag", "Fourth Tag", "Fifth Tag", "Sixth Tag", "Seventh Tag"]
  
    var body : some View{
        Picker("Select a tag",selection: $selectedTag) {
            ForEach(tempArr, id: \.self)
            {
                Text($0)
            }
        }
        .pickerStyle(.menu)

    }
            

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TestingView()
    }
}
