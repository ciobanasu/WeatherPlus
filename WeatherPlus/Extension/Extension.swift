//
//  Extension.swift
//  WeatherPlus
//
//  Created by Ciobanasu Ion on 11/26/19.
//  Copyright © 2019 Ciobanasu Ion. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    
    func getShortDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: self)
    }
    
    func getCurrentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    func getDayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }  
}

extension UICollectionView {
    func registerCollectionViewCell(nibName: String) {
        let cellIdentifier = "Cell"
        let bundle = Bundle.main
        let nibName = nibName
        let nib = UINib(nibName: nibName, bundle: bundle)
        self.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
