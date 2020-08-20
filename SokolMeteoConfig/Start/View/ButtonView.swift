//
//  ButtonView.swift
//  SokolMeteoConfig
//
//  Created by Володя Зверев on 16.07.2020.
//  Copyright © 2020 zverev. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

class ForceGestureRecognizer: UIGestureRecognizer {

    var force: CGFloat { return trackingTouch?.force ?? 0.0 }

    private let forceThreshold: CGFloat
    private var trackingTouch: UITouch?

    init(forceThreshold: CGFloat) {
        self.forceThreshold = forceThreshold
        super.init(target: nil, action: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if let trackingTouch = trackingTouch {
            touches.filter { $0 !== trackingTouch }.forEach { ignore($0, for: event) }
        } else if let touch = touches.first {
            trackingTouch = touch
        } else {
            state = .failed
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let trackingTouch = trackingTouch, touches.contains(where: { $0 === trackingTouch }) else { return }

        if trackingTouch.force >= forceThreshold || state == .changed {
            if state == .possible || state == .ended {
                state = .began
            }

            state = .changed
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        guard touches.contains(where: { $0 === trackingTouch }) && (state == .began || state == .changed) else { return }
        trackingTouch = nil
        state = .cancelled
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        guard touches.contains(where: { $0 === trackingTouch }) && (state == .began || state == .changed)  else { return }
        trackingTouch = nil
        state = .ended
    }

    override func reset() {
        trackingTouch = nil
        state = .possible
    }

}
