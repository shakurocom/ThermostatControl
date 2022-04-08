//
//  DecelerationBehaviour.swift
//  ShakuroApp
//
//  Created by Vlad on 07.10.2020.
//  Copyright © 2020 Shakuro. All rights reserved.
//

import UIKit

final class DecelerationBehaviour {

    var minVelocity: CGFloat = 0
    var decelerationFactor: CGFloat = 0

    private var timer: CADisplayLink?
    private var currentVelocity: CGFloat = 0

    private var completion: (() -> Void)?
    private var update: ((_ distance: CGFloat) -> Void)?

    func decelerate(velocity: CGFloat,
                    update: ((_ distance: CGFloat) -> Void)?,
                    completion: (() -> Void)? = nil) {
        stop()
        currentVelocity = velocity
        self.completion = completion
        self.update = update
        startTimer()
    }

    func stop() {
        update = nil
        stopTimer()
        currentVelocity = 0
        completion?()
        completion = nil
    }

    // MARK: - Private

    private func startTimer() {
        stopTimer()
        let newTimer = CADisplayLink(target: self, selector: #selector(timerTick))
        newTimer.add(to: RunLoop.main, forMode: .common)
        timer = newTimer
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    @objc private func timerTick(_ sender: CADisplayLink) {
        currentVelocity *= decelerationFactor
        guard currentVelocity >= minVelocity else {
            stop()
            return
        }
        let distance = currentVelocity * CGFloat(sender.duration)
        update?(distance)
    }

}
