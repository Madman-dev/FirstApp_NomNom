////
////  Extension.swift
////  NomNom
////
////  Created by Jack Lee on 2023/04/07.
////
//
//import UIKit
//
//extension UIViewController {
//
//    func configureBackground() {
//        let gradient = CAGradientLayer()    // 한번 더 보자~? >>> configureBackground는 이후에 출력되는 문제로 인해 SceneDelegate에 넣을 수 있는지 확인 필요⭐️
//        gradient.frame = view.frame
////        gradient.colors = [UIColor.gray.cgColor, UIColor.brown.cgColor]
//        //gradient.colors = [UIColor(red: 39, green: 17, blue: 45, alpha: 1), UIColor(red: 198, green: 66, blue: 110, alpha: 1)]
//        gradient.colors = [UIColor(#colorLiteral(red: 0.3764705882, green: 0.4235294118, blue: 0.5333333333, alpha: 1)).cgColor,
//                           UIColor(#colorLiteral(red: 0.2470588235, green: 0.2980392157, blue: 0.4196078431, alpha: 1)).cgColor]
////        gradient.shouldRasterize = true /// 이건 정확하게 어떤 역할을 하는 코드? >>> "A Boolean that indicates whether the layer is rendered as a bitmap before compositing." - 이 값이 참일 경우 bitmap으로 렌더링이 된다고 하는데 (raster image로 렌더링이 된다는 의미라고 한다.) ⭐️ 비트맵에 대해서 배우기는 했는데 어떤 차이가 있는거지?
//         gradient.locations = [0,1]
//        view.layer.addSublayer(gradient)
//    }
//}
//
////extension UIView {
////    func setDimensions(height: CGFloat, width: CGFloat) {
////        translatesAutoresizingMaskIntoConstraints = false
////        heightAnchor.constraint(equalToConstant: height).isActive = true
////        widthAnchor.constraint(equalToConstant: width).isActive = true
////    }
////}
////
