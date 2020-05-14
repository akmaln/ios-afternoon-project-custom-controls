//
//  CustomControl.swift
//  StarRating
//
//  Created by Akmal Nurmatov on 5/14/20.
//  Copyright © 2020 Akmal Nurmatov. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CustomControl: UIControl {
    
    var value: Int = 1
    let componentDimension: CGFloat = 40.0
    let componentCount: Int = 5
    let componentActiveColor: UIColor = .black
    let componentInactiveColor: UIColor = .gray
    var labels: [UILabel] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
      
    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        setup()
    }

    override var intrinsicContentSize: CGSize {
        let componentsWidth = CGFloat(componentCount) * componentDimension
        let componentsSpacing = CGFloat(componentCount + 1) * 8.0
        let width = componentsWidth + componentsSpacing
        return CGSize(width: width, height: componentDimension)
    }

    private func setup() {
        labels.removeAll()
        var padding: CGFloat = 8.0
        for index in 1...componentCount {
            let label = UILabel()
            label.tag = index
            label.font = UIFont.boldSystemFont(ofSize: 32.0)
            label.text = "\u{272D}"
            label.textColor = .black
            label.frame = CGRect(x: padding, y: 0.0, width: componentDimension, height: componentDimension)
            padding += 8.0 + componentDimension

            labels.append(label)
            self.addSubview(label)
        }
    }
    
    func updateValue(at touch: UITouch) {
        for label in labels {
            if label.frame.contains(touch.location(in: self)) {
                value = label.tag
                for label in labels {
                    if label.tag <= value {
                        label.textColor = componentActiveColor
                    }
                }
            } else {
                for label in labels {
                    if label.tag > value {
                        label.textColor = componentInactiveColor
                    }
                }
            }
        }
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        sendActions(for: .valueChanged)
        updateValue(at: touch)
        return true
    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let touchPoint = touch.location(in: self)
        if bounds.contains(touchPoint) {
            sendActions(for: [.touchDragInside, .valueChanged])
            updateValue(at: touch)
        } else {
            sendActions(for: [.touchDragOutside])
        }
        return true
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        guard let touch = touch else { return }
        if bounds.contains(touch.location(in: self)) {
            sendActions(for: [.touchDragInside])
            updateValue(at: touch)
        } else {
            sendActions(for: [.touchDragOutside])
            return
        }
    }

    override func cancelTracking(with event: UIEvent?) {
        sendActions(for: [.touchCancel])
    }
}
