import AVKit
import SwiftUI

final class TimerModel: ObservableObject {
    @Published var timer: Timer?
    @Published var isPlaying = false
    @Published var remainingSeconds: Int = 60
    @Published var showZengoDetail = false
    @State private var player: AVPlayer?

    func startTimer() {
        stopTimer() // 念のため，ストップ

        print("remainingSeconds: \(remainingSeconds)")

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.remainingSeconds > 0 {
                self.remainingSeconds -= 1
                print("remainingSeconds: \(self.remainingSeconds)")
            } else {
                self.stopTimer()
                self.showZengoDetail = true
                self.isPlaying = true
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func userDefault(key: String, number: Int) {
        UserDefaults.standard.set(number, forKey: key)
    }
}
