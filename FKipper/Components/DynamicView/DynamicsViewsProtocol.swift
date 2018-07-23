//
//  DynamicsViewsProtocol.swift
//  FKipper
//
//  Created by Scherbinin Andrey on 16/07/2018.
//  Copyright © 2018 Scherbinin Andrey. All rights reserved.
//

import Foundation

protocol DynamicsViewsProtocol: class {
    var center: CGPoint { get }
    var dynamicsViews: [DynamicView] { get set }
    var dynamicsViewDelegate : DynamicViewDelegate! { get }
    var radius: Double { get set }
}

extension DynamicsViewsProtocol where Self : UIViewController {
    
    private func createView(endPoint: CGPoint, entry: DynamicEntryViewProtocol) {
            let dynamicView = DynamicView(frame: CGRect(origin: center, size: Sizes.dynamicViewSize),
                                          center: center,
                                          endPosition: endPoint,
                                          entry: entry)
            dynamicView.delegate = dynamicsViewDelegate
            self.dynamicsViews.append(dynamicView)
            self.view.addSubview(dynamicView)
            self.view.sendSubview(toBack: dynamicView)
    }
    
    func hideViews(hide: Bool) {
        for (index, view) in dynamicsViews.enumerated() {
            let delay = !hide ? 0 : Double(index) / 7
            let scaleModifier: CGFloat = !hide ? 0.3 : 1
            UIView.animate(withDuration: 0.2, delay: delay, animations: {
                view.center = !hide ? self.center : view.endPosition
                view.transform = CGAffineTransform(scaleX: scaleModifier , y: scaleModifier)
            })
        }
    }
    
    func appendNewDynamicView(_ dynamic: DynamicEntryViewProtocol, isTapped: Bool) {
        if !dynamicsViews.contains(where: {$0.id == dynamic.id}) {
            let newIndex = dynamicsViews.count + 1
            let newEndPoint = DynamicView.calculateViewPosition(indexOfView: newIndex,
                                                                center: center,
                                                                radius: radius,
                                                                viewsCount: newIndex)
            createView(endPoint: newEndPoint, entry: dynamic)
            for (index, view) in dynamicsViews.enumerated() {
                view.endPosition = DynamicView.calculateViewPosition(indexOfView: index,
                                                                     center: center,
                                                                     radius: radius,
                                                                     viewsCount: dynamicsViews.count)
            }
            if isTapped {
                for (_, view) in dynamicsViews.enumerated() {
                    UIView.animate(withDuration: 0.2, delay: 0.0, animations: {
                        view.center = view.endPosition
                    })
                }
            }
        }
    }
}
