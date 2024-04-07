import SwiftUI

struct TopView: View {
    @ObservedObject var notificationModel = NotificationModel()
    @ObservedObject var timerModel = TimerModel()
    @State private var isModalSheet = false
    @State private var isPopUpView = false
    @State private var text: String = ""

    let whatIsZazen = "Zen is about finding yourself (finding out who you really are), as well as finding truth - not worshipping others, but believing in yourself, knowing “who you really are,” being yourself, living in your own way."
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ZStack(alignment: .topTrailing) {
                    Image("Background")
                        .resizable()
                        .ignoresSafeArea()
                    VStack {
                        Spacer()
                        Image("Top1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 0.98)
                        Text("Zen Reflection")
                            .foregroundStyle(Color("Indigo"))
                            .font(.system(size: 50, design: .serif))
                        Image("Top2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 0.98)
                        Spacer()
                        Button {
                            isModalSheet = true
                        } label: {
                            Label(title: {
                                Text("Start")
                                    .foregroundStyle(Color("Indigo"))
                                    .font(.system(size: 40, design: .serif))
                            }, icon: {
                                Image(systemName: "clock.fill")
                                    .foregroundStyle(Color("Indigo"))
                                    .fontWeight(.bold)
                                    .font(.system(size: 30, design: .serif))
                            })
                            .frame(width: geometry.size.width * 0.98, height: 72)
                            .background(
                                Image("WritingBrush")
                                    .resizable()
                            )
                            .cornerRadius(4.0)
                        }
                        Spacer()
                        HStack() {
                            Button {
    //                            notificationModel.speechSynthesizer()
                                text = whatIsZazen
                                isPopUpView = true
//                                print("text: \(text)")
                            } label: {
                                Label(title: {
                                    Text("What is Zen?")
                                        .foregroundStyle(Color("Indigo"))
                                        .font(.system(size: 16, design: .serif))
                                }, icon: {
                                    Image("Zazen")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                })
                                .frame(width: geometry.size.width * 0.9, height: 50, alignment: .trailing)
                            }
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    NavigationLink {
                        ZengoListView(notificationModel: notificationModel, text: $text)
                    } label: {
                        Image("Book")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 48, height: 48)
                            .padding(.trailing)
                    }
                    HStack {
                        NavigationLink {
                            CalenderView()
                        } label: {
                            Image("Calender")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 48, height: 48)
                                .padding(.trailing)
                        }
                        Spacer()
                    }
                    .padding(.leading)
                    // CheckInViewが選択された時に背景をグレーにするためのView
                    VStack {
                        EmptyView()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(isModalSheet ? .black.opacity(0.5) : .clear)
                    .background(isPopUpView ? .black.opacity(0.5) : .clear)
                    .onTapGesture {
                        isModalSheet = false
                        isPopUpView = false
                    }
                    .sheet(isPresented: $isModalSheet) {
                        ModalSheetView(notificationModel: notificationModel, timerModel: timerModel, showPopUpView: $isModalSheet, isModalSheet: $isModalSheet)
                            .presentationDetents([.fraction(0.3)])
//                            .background(
//                                Image("Background")
//                                    .resizable()
//                            )
                            .background(
                                LinearGradient(gradient: Gradient(colors: [.white, Color("LightPink")]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                            )
                            
                    }
                    PopUpView(notificationModel: notificationModel, showPopUpView: $isPopUpView, text: $text)

                }
                .onAppear {
                    notificationModel.loadZengoJson()
                    for index in 0 ..< notificationModel.zengo.count {
                        let flag = UserDefaults.standard.integer(forKey: notificationModel.zengo[index].title)
                        notificationModel.zengo[index].flag = flag
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

#Preview {
    TopView()
}
