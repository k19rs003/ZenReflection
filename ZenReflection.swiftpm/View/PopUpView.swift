import SwiftUI

struct PopUpView: View {
    @ObservedObject var notificationModel: NotificationModel
    @State private var showTimerView: Bool = false
    @Binding var showPopUpView: Bool
    @Binding var text: String

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if !notificationModel.zengo.isEmpty {
                    VStack {
                        Image("Zazen")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: geometry.size.height * 0.06)
                            .padding(.bottom, 32)
                        VStack {
                            ScrollView {
                                Text(text)
                                    .padding()
                                    .foregroundStyle(Color("Indigo"))
                                    .font(.system(.title2, design: .serif))
                                    .lineSpacing(8.0)
                            }
                            .scrollIndicators(.hidden)
                        }
                        .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.4)
                    }
                    .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.6)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.white, Color("LightPink")]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                    )
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .opacity(showPopUpView ? 1.0 : 0.0)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

#Preview {
    PopUpView(notificationModel: NotificationModel(), showPopUpView: .constant(true), text: .constant("text"))
}


struct ModalSheetView: View {
    @ObservedObject var notificationModel: NotificationModel
    @ObservedObject var timerModel: TimerModel
    @State private var showTimerView: Bool = false
    @State private var selectedIndex: Int? = 1 // 選択されているチェックボックスを保存
    @Binding var showPopUpView: Bool
    @Binding var isModalSheet: Bool

    let minutes = [1, 5, 15, 45]

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Text("Choose your session time")
                    .foregroundStyle(Color("Indigo"))
                    .font(.system(size: 28, design: .serif))
                    .bold()
                HStack {
                    ForEach(minutes, id: \.self) { minutes in
                        Button {
                            selectedIndex = minutes
                        } label: {
                            VStack {
                                Text(String(minutes))
                                    .font(.system(size: 28, design: .serif))
                                    .bold()
                                Text("min")
                                    .font(.system(size: 16, design: .serif))
                            }
                            .frame(width: geometry.size.width * 0.2, height: geometry.size.width * 0.18)
                            .foregroundStyle((selectedIndex != minutes) ? .gray : Color("Indigo"))
                            .overlay(
                                Circle()
                                    .stroke((selectedIndex != minutes) ? .gray : Color("Indigo"), lineWidth: 3)
                            )
                        }
                    }
                }
                Spacer()
                Button {
                    if let remainingSeconds = selectedIndex {
                        timerModel.remainingSeconds = remainingSeconds * 60 // 秒数に変更
                    } else {
                        timerModel.remainingSeconds = 60
                    }
                    showTimerView = true
                } label: {
                    Text("Start Session")
                        .bold()
                        .font(.system(size: 20, design: .serif))
                        .padding()
                        .frame(width: geometry.size.width * 0.85, height: 64)
                        .foregroundColor(.white)
                        .background(Color("Indigo"))
                        .cornerRadius(16)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal)
            //            .opacity(showPopUpView ? 1.0 : 0.0)
            .fullScreenCover(isPresented: $showTimerView) {
                TimerView(notificationModel: notificationModel, timerModel: timerModel, isModalSheet: $isModalSheet)
            }
        }
    }
}

#Preview {
    ModalSheetView(notificationModel: NotificationModel(), timerModel: TimerModel(), showPopUpView: .constant(true), isModalSheet: .constant(false))
}



