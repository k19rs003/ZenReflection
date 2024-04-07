import SwiftUI

struct ZengoListView: View {
    @ObservedObject var notificationModel: NotificationModel
    @Environment(\.dismiss) private var dismiss
    @State private var showPopUpView = false
    @State private var isChecked = false
    @Binding var text: String
    let images = ["Branch", "Tower", "Wave", "Carp", "Dragon", "Fuji"]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("Background")
                    .resizable()
                    .ignoresSafeArea()
                VStack {
                    ScrollView {
                        LazyVStack {
                            ForEach(0 ..< notificationModel.zengo.count + (notificationModel.zengo.count/6), id: \.self) { index in
                                if index % 6 == 0, index != 0 {
                                    HStack {
                                        Image(images[(index / 3) % 6])
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 72)
                                        Image(images[((index / 3) % 6) + 1])
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 72)
                                    }
                                    .frame(width: geometry.size.width * 0.85, height: 64, alignment: .trailing)
                                } else {
                                    Button {
                                        self.text = notificationModel.zengo[index - (index/6)].detail
                                        //                                    print("text: \(text)")
                                        if notificationModel.zengo[index - (index/6)].flag == 1 {
                                            showPopUpView = true
                                        }
                                    } label: {
                                        VStack(spacing: 10) {
                                            HStack {
                                                if notificationModel.zengo[index - (index/6)].flag == 1 {
                                                    VStack(alignment: .leading) {
                                                        Text(notificationModel.zengo[index - (index/6)].title)
                                                            .foregroundStyle(.white)
                                                            .font(.system(size: 24, design: .serif))
                                                        Text(notificationModel.zengo[index - (index/6)].kana)
                                                            .foregroundStyle(.white)
                                                            .font(.system(size: 14, design: .serif))
                                                    }
                                                    Spacer()
                                                    Image(systemName: "chevron.right")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 16, height: 16)
                                                } else {
                                                    Text("???")
                                                        .foregroundStyle(.white)
                                                        .font(.system(size: 32, design: .serif))
                                                        .kerning(16)
                                                }
                                            }
                                            .backgroundStyle(.blue)
                                        }
                                    }
                                    .frame(width: geometry.size.width * 0.75, height: 64)
                                }
                                Rectangle()
                                    .frame(width: geometry.size.width * 0.85, height: 2)
                                    .foregroundColor(Color("Indigo"))
                            }
                        }
                    }
                    .foregroundStyle(.white)
                    .scrollIndicators(.hidden)
                }
                .frame(width:  geometry.size.width, height: geometry.size.height * 0.9)
                VStack {
                    EmptyView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(showPopUpView ? .black.opacity(0.01) : .clear)
                .onTapGesture {
                    showPopUpView = false
                }
                PopUpView(notificationModel: notificationModel, showPopUpView: $showPopUpView, text: $text)
            }
            .onAppear {
                for index in 0 ..< notificationModel.zengo.count {
                    let flag = UserDefaults.standard.integer(forKey: notificationModel.zengo[index].title)
                    notificationModel.zengo[index].flag = flag
                }
                print(notificationModel.zengo)
            }
            .onDisappear {
                text = ""
            }
        }
    }
}

#Preview {
    ZengoListView(notificationModel: NotificationModel(), text: .constant("text"))
}
