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

//class Transition: NSObject, UIViewControllerAnimatedTransitioning {

//    enum Direction {
//        case present
//        case dismiss
//    }
//
//    var direction: Direction = .present
//    private var presentedConstraints: [NSLayoutConstraint] = []
//    private var dismissedConstraints: [NSLayoutConstraint] = []
//
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { 0.7 }
//
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        switch direction {
//        case .present:
//            present(using: transitionContext)
//        case .dismiss:
//            dismiss(using: transitionContext)
//        }
//    }
//
//    private func present(using context: UIViewControllerContextTransitioning) {
//        guard let presentedView = context.view(forKey: .to) else {
//            context.completeTransition(false)
//            return
//        }
//
//        context.containerView.addSubview(presentedView)
//        presentedView.translatesAutoresizingMaskIntoConstraints = false
//
//        presentedConstraints = [
//            presentedView.leftAnchor.constraint(equalTo: context.containerView.leftAnchor, constant: 10),
//            presentedView.rightAnchor.constraint(equalTo: context.containerView.rightAnchor, constant: -10),
//            presentedView.topAnchor.constraint(equalTo: context.containerView.centerYAnchor),
//            presentedView.bottomAnchor.constraint(equalTo: context.containerView.bottomAnchor)
//        ]
//
//        dismissedConstraints = [
//            presentedView.leftAnchor.constraint(equalTo: context.containerView.leftAnchor),
//            presentedView.rightAnchor.constraint(equalTo: context.containerView.rightAnchor),
//            presentedView.topAnchor.constraint(equalTo: context.containerView.bottomAnchor),
//            presentedView.bottomAnchor.constraint(equalTo: context.containerView.topAnchor)
//        ]
//
//        NSLayoutConstraint.activate(dismissedConstraints)
//
//        context.containerView.setNeedsLayout()
//        context.containerView.layoutIfNeeded()
//
//        NSLayoutConstraint.deactivate(dismissedConstraints)
//        NSLayoutConstraint.activate(presentedConstraints)
//
//
//        UIView.animate(
//            withDuration: transitionDuration(using: context),
//            delay: 0,
//            usingSpringWithDamping: 0.8,
//            initialSpringVelocity: 0,
//            options: .curveEaseInOut,
//            animations: {
//                context.containerView.setNeedsLayout()
//                context.containerView.layoutIfNeeded()
//            },
//            completion: { _ in
//                context.completeTransition(true)
//            })
//    }
//
//    private func dismiss(using context: UIViewControllerContextTransitioning) {
//        NSLayoutConstraint.deactivate(presentedConstraints)
//        NSLayoutConstraint.activate(dismissedConstraints)
//
//        UIView.animate(
//            withDuration: transitionDuration(using: context),
//            delay: 0,
//            usingSpringWithDamping: 0.8,
//            initialSpringVelocity: 0,
//            options: .curveEaseInOut,
//            animations: {
//                context.containerView.setNeedsLayout()
//                context.containerView.layoutIfNeeded()
//            },
//            completion: { _ in
//                context.completeTransition(true)
//            })
//    }
//}



    // MARK: - 이전 효과 적용 도전

    class Transition: NSObject, UIViewControllerAnimatedTransitioning {
        
        enum Direction {
            case present
            case dismiss
        }
        
        var direction: Direction = .present // if는 아니고 그냥 지정을 하네? 일단은 담아둔거구나
        private var presentedConstraints: [NSLayoutConstraint] = [] // 이건 왜 있는거지? 🙋🏻‍♂️
        private var dismissedConstraints: [NSLayoutConstraint] = []
        
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { 0.8 }   /// TimeInterval가 애니메이션이 진행되는 전체 속도 - 진행되는 동안에는 버튼을 누를 수 없다 - unable to click ⏲️ THIS IS REGARDING TIME FRAME, contextTransitioning은 별도로 만드는게 아니다. 건드리는 것도 아니라고 한다.
        
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) { // 여기서 가장 많은 영향이 발생한다.
            switch direction {
            case .present:
                present(using: transitionContext)
            case .dismiss:
                dismiss(using: transitionContext)
            }
        }   /// ⏲️ 여기서 나는 궁금한건 어떻게 다른 화면에 존재하는 present 함수를 부를 수 있는지야
        
        private func present(using context: UIViewControllerContextTransitioning) {
            guard let presentedView = context.view(forKey: .to) else {  // .from으로 바꾸면 작동을 안하네?? 오호...>> 보여지는 화면이 다음 화면인지 확인을 하고 아니면 completeTransition을 체크하지 말아라~
                context.completeTransition(false) // 이건 true false에 따라 변하는게 없네?
                return
            }
            
            /// ⭐️⭐️ 가장 중요한 건 **다음 화면을** 건드리고 있다는 점.
            context.containerView.addSubview(presentedView) /// transition을 할 떄 담아주는 친구잖아
            presentedView.translatesAutoresizingMaskIntoConstraints = false
            
            presentedConstraints = [    /// 여기서 등장하는 (다음 view)에 사용되는 영역의 구간을 잡을 수 있다 - 지금은 파란색 타원형 친구 >> 등장할 때의 애니메이션을 담당하네
                presentedView.leftAnchor.constraint(equalTo: context.containerView.leftAnchor, constant: 10),
                presentedView.rightAnchor.constraint(equalTo: context.containerView.rightAnchor, constant: -10),
                presentedView.topAnchor.constraint(equalTo: context.containerView.topAnchor),
                presentedView.bottomAnchor.constraint(equalTo: context.containerView.centerYAnchor, constant: 170)  // 여기가 너무 높으면 너무 위로 올라가네
            ]
            
            dismissedConstraints = [    /// 여기서는 등장한!(다음 view)가 복귀하는 구간을 뜻한다... 처음보여지는 view는 어디서 건드리는거지? >>> 초기 screenA에서 건드린다
                presentedView.leftAnchor.constraint(equalTo: context.containerView.leftAnchor, constant: 80),// 여기 때문에 등장할 때와 복귀할 때 이상한 것
                presentedView.rightAnchor.constraint(equalTo: context.containerView.rightAnchor, constant: -80),
                presentedView.topAnchor.constraint(equalTo: context.containerView.centerYAnchor, constant: 800),
                presentedView.bottomAnchor.constraint(equalTo: context.containerView.bottomAnchor, constant: 400)
            ]
            
            /// 가장 먼저 선언한 NSLayoutConstraint 배열에 dismiss와 present를 건드리는 것 (배열 속에 담아 두는 거네)⭐️
            NSLayoutConstraint.activate(dismissedConstraints)
            
            context.containerView.setNeedsLayout()  // 🙋🏻‍♂️ 이 두 함수는 왜 걸어두는걸까? >>> 이건 찾아봐야겠다
            context.containerView.layoutIfNeeded()  /// 이 친구가 없으면 시작할 때 갑자기 등장해서 조정을 하네
            
            NSLayoutConstraint.deactivate(dismissedConstraints)   // 이걸 끄니 - consstraint 오류가 나는데 자동으로 잡아주고 있네
            NSLayoutConstraint.activate(presentedConstraints)   // 2차 화면이 화면 밖으로 넘어간다 >> 결론적으로 두 스크린에 대한 constaint를 담당하고 있기는 하네
            
            UIView.animate( // 2차 화면에 대한 애니메이션 효과
                withDuration: transitionDuration(using: context),
                delay: 0,
                usingSpringWithDamping: 0.8,      /// 0으로 설정하면 자연스럽게 이동하는 모습이 없다, 수치가 낮을수록 튕기는 spring 느낌 존재
                initialSpringVelocity: 0,       /// 진짜 그냥 초기 애니메이션 속도구나 (100으로 설정해보니 초반에 엄청 빠르게 튕긴다)
                options: .curveEaseInOut,       /// animation 속도에 대한 이야기구나 (전반적인 초반에 천천히 - 중반 빠르게 - ending 천천히)
                animations: {
                    context.containerView.setNeedsLayout()
                    context.containerView.layoutIfNeeded()  /// 미적용하면 애니메이션 자체가 없네
                },
                completion: { _ in
                    context.completeTransition(true)
                })
        }
        
        private func dismiss(using context: UIViewControllerContextTransitioning) { /// 별도로 접근제어를 걸어두었다, present도 마찬가지
            NSLayoutConstraint.deactivate(presentedConstraints)
            NSLayoutConstraint.activate(dismissedConstraints)
            
            UIView.animate(
                withDuration: transitionDuration(using: context),
                delay: 0,
                usingSpringWithDamping: 0.8,    /// bounce 효과가 있네 - 0에 가까울수록 효과X
                initialSpringVelocity: 4,
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


    //Q. .to라고 했을 때 어떤게 첫번째이고 다음 화면인지 알수 있지?
