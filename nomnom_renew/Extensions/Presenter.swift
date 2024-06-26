//
//  Extension.swift
//  nomnom_renew
//
//  Created by Jack Lee on 2023/04/17.
//

import UIKit

class Presenter: NSObject, UIViewControllerTransitioningDelegate {

    private let transition = Transition()

    func present(_ viewController: UIViewController,
                 from parent: UIViewController) {
        viewController.modalPresentationStyle = .overFullScreen
        viewController.transitioningDelegate = self
        parent.present(viewController, animated: true)
    }

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.direction = .present
        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.direction = .dismiss
        return transition
    }
}
