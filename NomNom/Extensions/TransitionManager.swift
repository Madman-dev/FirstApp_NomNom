//
//  TransitionManager.swift
//  NomNom
//
//  Created by Jack Lee on 2023/04/12.
//
//
//import UIKit
//
//class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning {
//    
//    private let duration: TimeInterval
//    
//    init(duration: TimeInterval) {
//        self.duration = duration
//    }
//    
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return duration // duration은 지속 시간~
//    }
//    
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {  // this is where we call the transition to Views ++ to do it, we need access to the context View of transition -> context View is the view that's going to appear between the from and to view controller while the animation is running (화면을 캡쳐 - 보여지는 공간!), 지금은 아무것도 없는 상황. > 나는 textField
//        guard
//            let fromViewController = transitionContext.viewController(forKey: .from) as? MainViewController,
//            let toViewController = transitionContext.viewController(forKey: .to) as? MessageViewController,
//        else {
//            return
//        }
//        
//        let containerView = transitionContext.containerView
//        
//        let snapshotContentView = UIView()
//        snapshotContentView.backgroundColor = . white
//        
//        
//        
//    }
    
    // MARK: - UINavigationControllerDelegate - 네비게이션 컨트롤러에 transition Animation 연결
    
    //extension TransitionManager: UINavigationControllerDelegate {
    //    func navigationController(
    //        _ navigationController: UINavigationController,
    //        animationControllerFor operation: UINavigationController.Operation,
    //        from fromVC: UIViewController,
    //        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    //        <#code#>
    //    }
    //}
//}
