import AVFoundation
import SwiftUI

struct TimerView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var notificationModel: NotificationModel
    @ObservedObject var timerModel: TimerModel
    @State private var backgroundNumber: Int = 1
    @State private var zengoNumber: Int  = 0
    @State private var isPlay: Bool = true
    @State private var showDetail: Bool = false
    @State private var player: AVPlayer?
    @State private var date = DateFormatter().string(from: Date())
    @State private var array = [Int]()
    @Binding var isModalSheet: Bool
    
    let dateFormatter = DateFormatter()
    let startTime : CMTime = CMTimeMake(value: 1, timescale: 1)
    private let endPublisher = NotificationCenter.default.publisher(for: NSNotification.Name.AVPlayerItemDidPlayToEndTime)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("Background\(backgroundNumber)")
                    .resizable()
                    .ignoresSafeArea()
                if !notificationModel.zengo.isEmpty {
                    VStack(spacing: 8) {
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .padding()
                            }
                            Spacer()
                            Button {
                                timerModel.isPlaying.toggle()
                            } label: {
                                Image(systemName: timerModel.isPlaying ? "speaker.slash" : "speaker.wave.2")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            }
                            .onChange(of: timerModel.isPlaying) { playing in
                                if playing {
                                    player?.volume = 1.0
                                } else {
                                    player?.volume = 0.0
                                }
                            }
                        }
                        .opacity(isPlay ? 1.0 : 0.0)
                        Text(notificationModel.zengo[zengoNumber].title)
                            .foregroundStyle(.white)
                            .font(.system(size: 50, design: .serif))
                            .opacity(timerModel.remainingSeconds == 0 ? 0 : 1)
                            .animation(.easeInOut(duration: 0.8), value: timerModel.showZengoDetail)
                        Text(notificationModel.zengo[zengoNumber].kana)
                            .foregroundStyle(.white)
                            .font(.system(size: 25, design: .serif))
                            .opacity(timerModel.remainingSeconds == 0 ? 0 : 1)
                            .animation(.easeInOut(duration: 0.8), value: timerModel.showZengoDetail)
                        Button {
                            timerModel.showZengoDetail.toggle()
                        } label: {
                            Image(systemName: timerModel.showZengoDetail ? "chevron.down" : "chevron.up")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding()
                        }
                        .padding(.bottom)
                        .opacity(timerModel.remainingSeconds == 0 ? 0 : 1)
                        ScrollView {
                            Text(notificationModel.zengo[zengoNumber].detail)
                                .padding()
                                .foregroundStyle(.white)
                                .font(.system(size: 20, design: .serif))
                                .lineSpacing(8.0)
                        }
                        .frame(width:  geometry.size.width * 0.9, height: geometry.size.height * 0.6)
                        .background(.ultraThinMaterial)
                        .cornerRadius(8.0)
                        .opacity(timerModel.showZengoDetail || timerModel.remainingSeconds == 0 ? 0 : 1)
                        .animation(.easeInOut(duration: 0.8), value: timerModel.showZengoDetail)
                        .scrollIndicators(.hidden)
                        Spacer()
                        Text("\(timeString(timerModel.remainingSeconds))")
                            .foregroundStyle(.white)
                            .onChange(of: timerModel.remainingSeconds) { remainSeconds in
                                if remainSeconds == 0 {
                                    isPlay = false
                                    player?.pause()
                                    UserDefaults.standard.set(1, forKey: notificationModel.zengo[zengoNumber].title)
                                    print("\(notificationModel.zengo[zengoNumber].title)既読済み")
                                    
                                    var calender = UserDefaults.standard.stringArray(forKey: "calender") ?? []
                                    if !calender.contains(date) {
                                        calender.append(date)
                                        UserDefaults.standard.set(calender, forKey: "calender")
                                    }
                                    print(calender)
                                }
                            }
                            .onReceive(endPublisher) { _ in
                                player?.seek(to: CMTimeMakeWithSeconds(0, preferredTimescale: Int32(NSEC_PER_SEC)), toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                                player?.play()
                            }
                    }
                    .frame(width:  geometry.size.width * 0.9, height: geometry.size.height, alignment: .top)
                }
                if timerModel.remainingSeconds == 0 {
                    Text("Your reflection \n session is complete.")
                        .foregroundStyle(.white)
                        .font(.system(size: 32, design: .serif))
                        .multilineTextAlignment(.center)
                        .animation(.easeInOut(duration: 0.8), value: timerModel.remainingSeconds)
                    HStack {
                        Image("Flower")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                        Spacer()
                        Image("Flower")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                    }
                    .frame(width:  geometry.size.width * 0.9)
                    .offset(y: 128)
                    .animation(.easeInOut(duration: 0.8), value: timerModel.remainingSeconds)
                    VStack {
                        EmptyView()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.black.opacity(0.05))
                    .onTapGesture {
                        isModalSheet = false
                    }
                }
            }
            .onAppear {
//                notificationModel.loadZengoJson()
                
                let allReading = notificationModel.zengo.allSatisfy({ $0.flag == 1 })
                
                if allReading {
                    zengoNumber = Int.random(in: 0..<notificationModel.zengo.count)
                } else {
                    for index in 0 ..< notificationModel.zengo.count {
                        // 見たことがない部分だけを表示
                        if notificationModel.zengo[index].flag == 0 {
                            array.append(index)
                        }
                    }
                    if let randomNumber = array.randomElement() {
                        zengoNumber = randomNumber
                    }
                }
                
                backgroundNumber = Int.random(in: 1...7)
                timerModel.isPlaying = true
                let musicNumber = Int.random(in: 1...6)
                // MP3ファイルのURLを指定
                guard let url = Bundle.main.url(forResource: "japan\(musicNumber)", withExtension: "mp3") else {
                    print("MP3ファイルが見つかりません")
                    return
                }

                // AVPlayerを作成して音声を再生
                player = AVPlayer(url: url)
                player?.seek(to: .zero)
                player?.play()
                timerModel.startTimer()
                
                dateFormatter.dateFormat = "YYYY-MM-dd"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                date = dateFormatter.string(from: Date())
            }
            .onDisappear {
                timerModel.showZengoDetail = false
                player = nil
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    // 秒数を分と秒に変換
    func timeString(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

#Preview {
    TimerView(notificationModel: NotificationModel(), timerModel: TimerModel(), isModalSheet: .constant(true))
}
