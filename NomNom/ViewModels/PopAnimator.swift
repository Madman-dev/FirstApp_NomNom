//
//  PopAnimator.swift
//  NomNom
//
//  Created by Jack Lee on 2023/04/11.
//
/// 아래 Animation 코드들은 1도 모른다. 그만큼 일단 적용해보고 추후에 공부를 통해 적어도 어떻게 행동하는건지 이해하고자 한다.
//
//import UIKit
//
//class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
//    
//    
//    enum PopTransitionMode: Int {
//        case Present, Dismiss
//    }
//    
//    var transitionMode: PopTransitionMode = .Present
//    
//    // view of circle being presented
//    var circle: UIView?
//    
//    // color of circle, set based on button clicked
//    var circleColor: UIColor?
//    
//    // starting point of transition
//    var origin = CGPointZero
//    
//    // Duration
//    var presentDuration = 0.5
//    var dismissDuration = 0.5
//    
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        // set transition duration based on whether it is a presenting transition or dismissing transition
//        if transitionMode == .Present {
//            return presentDuration
//        } else {
//            return dismissDuration
//        }
//    }
//    
//    func frameForCircle(center: CGPoint, size: CGSize, start: CGPoint) -> CGRect {
//        let lengthX = fmax(start.x, size.width - start.x);
//        let lengthY = fmax(start.y, size.height - start.y)
//        let offset = sqrt(lengthX * lengthX + lengthY * lengthY) * 2;
//        let size = CGSize(width: offset, height: offset)
//        
//        return CGRect(origin: CGPointZero, size: size)
//    }
//    
//    
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        let containerView = transitionContext.containerView()
//        
//        if transitionMode == .Present {
//            
//            // get view of view controller being presented
//            let presentedView = transitionContext.view(forKey: UITransitionContextViewKey)!
//            let originalCenter = presentedView.center
//            let originalSize = presentedView.frame.size
//            
//            // get frame of circle
//            circle = UIView(frame: frameForCircle(originalCenter, size: originalSize, start: origin))
//            circle!.layer.cornerRadius = circle!.frame.size.height / 2
//            circle!.center = origin
//            
//            // make it small
//            circle!.transform = CGAffineTransformMakeScale(0.001, 0.001)
//            
//            // set the background color
//            circle!.backgroundColor = circleColor
//            
//            // add circle to container View
//            containerView.addSubview(circle!)
//            
//            // make presented View very small and transparent
//            presentedView.center = origin
//            presentedView.transform = CGAffineTransformMakeScale(0.001, 0.001)
//            
//            // set the background color
//            presentedView.backgroundColor = circleColor
//            
//            //add presented view to container View
//            containerView.addSubview(presentedView)
//            
//            // animate both Views
//            UIView.animate(withDuration: presentDuration, animations: {
//                self.circle!.transform = CGAffineTransformMakeScale(1.0, 1.0)
//                presentedView.transform = CGAffineTransformMakeScale(1.0, 1.0)
//                presentedView.center = originalCenter
//            }) { (_) -> Void in
//                // on completion, complete the transition
//                transitionContext.completeTransition(true)
//            }
//        } else {
//            // essentially oding the smae but in reverse
//            let returningControllerView = transitionContext.view(forKey: UITransitionContextViewKey)!
//            let originalCenter = returningControllerView.center
//            let originalSize = returningControllerView.frame.size
//            
//            circle!.frame = frameForCircle(originalCenter, size: originalSize, start: origin)
//            circle!.layer.cornerRadius = circle!.frame.size.height / 2
//            circle!.center = origin
//            
//            UIView.animate(withDuration: dismissDuration, animations: {
//                self.circle!.transform = CGAffineTransformMakeScale(0.001, 0.001)
//                returningControllerView.transform = CGAffineTransformMakeScale(0.001, 0.001)
//                returningControllerView.center = self.origin
//                returningControllerView.alpha = 0
//            }) { (_) -> Void in
//                returningControllerView.removeFromSuperview()
//                self.circle!.removeFromSuperview()
//                transitionContext.completeTransition(true)
//            }
//        }
//    }
//}
