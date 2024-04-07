//
//  SwiftUIView.swift
//  
//
//  Created by Abe on R 6/02/25.
//

import SwiftUI
import Combine

final class CalenderViewModel: ObservableObject {
    private(set) var didSelectDateSubject: PassthroughSubject<Void, Never> = .init()
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        subscribeDidSelectDate()
    }
    
    private func subscribeDidSelectDate() {
        didSelectDateSubject
            .receive(on: DispatchQueue.main)
            .sink {
                print("did select")
            }
            .store(in: &cancellables)
    }
}
