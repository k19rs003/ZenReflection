//
//  SwiftUIView.swift
//
//
//  Created by Abe on R 6/02/25.
//

import SwiftUI
import Combine

struct CalenderView: View {
    @StateObject private var viewModel: CalenderViewModel = .init()

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                Image("Background")
                    .resizable()
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Text("session log")
                            .padding()
                            .foregroundStyle(Color("Indigo"))
            //                        .font(.system(size: 24, design: .serif))
                            .font(.system(.largeTitle, design: .serif))
                            .bold()
                            .lineSpacing(8.0)
                            .frame(maxHeight: geometry.size.height * 0.09, alignment: .center)
                        Image("Zazen")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: geometry.size.height * 0.09, alignment: .trailing)
                    }
                    UICalendarViewRepresentable(didSelectDateSubject: viewModel.didSelectDateSubject)
                }
                .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.8, alignment: .top)
            }
        }
        
    }
}


struct UICalendarViewRepresentable: UIViewRepresentable {
    private let didSelectDateSubject: PassthroughSubject<Void, Never>
    
    init(didSelectDateSubject: PassthroughSubject<Void, Never>) {
        self.didSelectDateSubject = didSelectDateSubject
    }

    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        let selection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        calendarView.delegate = context.coordinator
        calendarView.selectionBehavior = selection
        calendarView.calendar = Calendar(identifier: .gregorian)
        calendarView.locale = Locale(identifier: "us")
        calendarView.fontDesign = .serif
        
        return calendarView
    }

    func updateUIView(_ uiView: UICalendarView, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UICalendarSelectionSingleDateDelegate, UICalendarViewDelegate {
        private let parent: UICalendarViewRepresentable
        
        init(_ parent: UICalendarViewRepresentable) {
            self.parent = parent
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            parent.didSelectDateSubject.send()
        }
        
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            
            let calender = UserDefaults.standard.stringArray(forKey: "calender") ?? []
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.dateFormat = "yyyy-MM-dd"

            guard let date = dateComponents.date else {
                return nil
            }
            
            print(date)
            
            for i in 0 ..< calender.count {
                if date == dateFormatter.date(from: calender[i]) ?? Date() {
//                    return UICalendarView.Decoration.default(color: .blue, size: .large)
//                    return UICalendarView.Decoration.image(UIImage(systemName: "face.smiling"), color: .cyan, size: .large)
                    let label = UILabel()
                    label.text = "🎉"
                    return UICalendarView.Decoration.customView{label}
                }
            }
            
            return nil
        }
    }
}


#Preview {
    CalenderView()
}
