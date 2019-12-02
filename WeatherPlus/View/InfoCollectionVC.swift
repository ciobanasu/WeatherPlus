//
//  InfoCollectionVC.swift
//  WeatherPlus
//
//  Created by Ciobanasu Ion on 11/26/19.
//  Copyright © 2019 Ciobanasu Ion. All rights reserved.
//

import UIKit

class InfoCollectionVC: UICollectionViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var infoForecastLbl: UILabel!
    @IBOutlet weak var infoImgViewForecast: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func generateCellForecastInfo(weatherInfo: WeatherInfoForecast) {
        infoForecastLbl.text = weatherInfo.infoTxt
        infoForecastLbl.adjustsFontSizeToFitWidth = true
        
        if weatherInfo.imgInfo != nil {
            nameLbl.isHidden = true
            infoImgViewForecast.isHidden = false
            infoImgViewForecast.image = weatherInfo.imgInfo
        } else {
            // no image
            nameLbl.isHidden = false
            infoImgViewForecast.isHidden = true
            nameLbl.adjustsFontSizeToFitWidth = true
            nameLbl.text = weatherInfo.nameTxt
        }
    }
    
}
