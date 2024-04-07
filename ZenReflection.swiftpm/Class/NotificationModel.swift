import AVFoundation
import UserNotifications

final class NotificationModel: ObservableObject {
    @Published var zengo = [ZengoData]()

    static let shared = NotificationModel()
    let synthesizer = AVSpeechSynthesizer()

    func loadZengoJson() {
        guard let path = Bundle.main.path(forResource: "ZengoData", ofType: "json") else { return print("faild")}
        let url = URL(fileURLWithPath: path)

        do {
            let zengoData = try Data(contentsOf: url)
            zengo = try JSONDecoder().decode([ZengoData].self, from: zengoData)
            zengo.sort(by: {$0.kana < $1.kana})
//            zengo = zengo.sorted()
//            print("zengo: \(zengo)")
        } catch {
            print(error.localizedDescription)
        }
    }

    func speechSynthesizer() {
        let utterance = AVSpeechUtterance(string: zengo[1].detail)
        utterance.voice = makeVoice(AVSpeechSynthesisVoiceIdentifierAlex)
//        utterance.voice = makeVoice("com.apple.ttsbundle.siri_male_en-US_compact")
//        utterance.voice = makeVoice("com.apple.ttsbundle.siri_female_en-US_compact")
//        utterance.voice = makeVoice("com.apple.ttsbundle.Samantha-compact")
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }

    // 単語ごとの区切りで音声を停止
    func stopSpeechSynthesizer() {
        synthesizer.stopSpeaking(at: .word)
    }

    // ボイスの生成
    private func makeVoice(_ identifier: String) -> AVSpeechSynthesisVoice! {
        let voices = AVSpeechSynthesisVoice.speechVoices()
        for voice in voices {
            if voice.identifier == identifier {
                return AVSpeechSynthesisVoice.init(identifier: identifier)
            }
        }
        return AVSpeechSynthesisVoice.init(language: "en-US")
    }
}

