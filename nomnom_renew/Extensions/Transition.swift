//
//  Transition.swift
//  nomnom_renew
//
//  Created by Jack Lee on 2023/04/17.
//

import UIKit

class Transition: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum Direction {
        case present
        case dismiss
    }
    
    var direction: Direction = .present
    private var presentedConstraints: [NSLayoutConstraint] = []
    private var dismissedConstraints: [NSLayoutConstraint] = []
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { 0.8 }
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
            presentedView.leftAnchor.constraint(equalTo: context.containerView.leftAnchor),
            presentedView.rightAnchor.constraint(equalTo: context.containerView.rightAnchor),
            presentedView.topAnchor.constraint(equalTo: context.containerView.topAnchor),
            presentedView.bottomAnchor.constraint(equalTo: context.containerView.centerYAnchor, constant: 100)
        ]
        
        dismissedConstraints = [
            presentedView.leftAnchor.constraint(equalTo: context.containerView.leftAnchor, constant: 60),
            presentedView.rightAnchor.constraint(equalTo: context.containerView.rightAnchor, constant: -60),
            presentedView.topAnchor.constraint(equalTo: context.containerView.centerYAnchor),
            presentedView.bottomAnchor.constraint(equalTo: context.containerView.bottomAnchor, constant: 900)
        ]
        
        NSLayoutConstraint.activate(dismissedConstraints)
        
        context.containerView.setNeedsLayout()
        context.containerView.layoutIfNeeded()
        
        NSLayoutConstraint.deactivate(dismissedConstraints)
        NSLayoutConstraint.activate(presentedConstraints)
        
        UIView.animate(
            withDuration: transitionDuration(using: context),
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
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
            usingSpringWithDamping: 1,
            initialSpringVelocity: 5,
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
