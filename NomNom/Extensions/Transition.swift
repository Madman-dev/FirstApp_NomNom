//
//  TransitionManager.swift
//  NomNom
//
//  Created by Jack Lee on 2023/04/13.

// MARK: - transition 효과를 위한 구성

//import UIKit
//
//class transitionManager: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        <#code#>
//    }
//
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        <#code#>
//    }
//
//
//
//}
//
//extension transitionManager: UIViewControllerTransitioningDelegate {
//
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return self
//    }
//
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return self
//
//    }
//
//    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        return nil
//    }
//
//    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        return self
//    }
//}
//
//


// MARK: - 이전 효과 적용 도전
import UIKit

class Transition: NSObject, UIViewControllerAnimatedTransitioning {

    enum Direction {
        case present
        case dismiss
    }
    
    var direction: Direction = .present
    private var presentedConstraints: [NSLayoutConstraint] = []
    private var dismissedConstraints: [NSLayoutConstraint] = []

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { 0.7 }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch direction {
        case .present:
            present(using: transitionContext)
        case .dismiss:
            dismiss(using: transitionContext)
        }
    }

    private func present(using context: UIViewControllerContextTransitioning) {
        guard let presentedView = context.view(forKey: .to) else {
            context.completeTransition(false)
            return
        }

        context.containerView.addSubview(presentedView)
        presentedView.translatesAutoresizingMaskIntoConstraints = false

        presentedConstraints = [
            presentedView.leftAnchor.constraint(equalTo: context.containerView.leftAnchor, constant: 10),
            presentedView.rightAnchor.constraint(equalTo: context.containerView.rightAnchor, constant: -10),
            presentedView.topAnchor.constraint(equalTo: context.containerView.topAnchor),
            presentedView.bottomAnchor.constraint(equalTo: context.containerView.centerYAnchor, constant: 170)
        ]

        dismissedConstraints = [
            presentedView.leftAnchor.constraint(equalTo: context.containerView.leftAnchor, constant: 80),
            presentedView.rightAnchor.constraint(equalTo: context.containerView.rightAnchor, constant: -80),
            presentedView.topAnchor.constraint(equalTo: context.containerView.centerYAnchor, constant: -400),
            presentedView.bottomAnchor.constraint(equalTo: context.containerView.bottomAnchor, constant: 400)
        ]

        NSLayoutConstraint.activate(dismissedConstraints)

        context.containerView.setNeedsLayout()
        context.containerView.layoutIfNeeded()

        NSLayoutConstraint.deactivate(dismissedConstraints)
        NSLayoutConstraint.activate(presentedConstraints)


        UIView.animate(
            withDuration: transitionDuration(using: context),
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: .curveEaseInOut,
            animations: {
                context.containerView.setNeedsLayout()
                context.containerView.layoutIfNeeded()
            },
            completion: { _ in
                context.completeTransition(true)
            })
    }

    private func dismiss(using context: UIViewControllerContextTransitioning) {
        NSLayoutConstraint.deactivate(presentedConstraints)
        NSLayoutConstraint.activate(dismissedConstraints)

        UIView.animate(
            withDuration: transitionDuration(using: context),
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: .curveEaseInOut,
            animations: {
                context.containerView.setNeedsLayout()
                context.containerView.layoutIfNeeded()
            },
            completion: { _ in
                context.completeTransition(true)
            })
    }
}
