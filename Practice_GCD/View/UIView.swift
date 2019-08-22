//
//  UIView.swift
//  Practice_GCD
//
//  Created by yueh on 2019/8/22.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

protocol MyUIViewDelegate: AnyObject {
    func useGroupGetData()
    func useSemaphoreGetData()
    func clearData()
}

class MyUIView: UIView {
    
//    @IBOutlet weak var groupBtn: UIButton!
//    @IBOutlet weak var semaphoreBtn: UIButton!
    @IBOutlet weak var firstRoadLabel: UILabel!
    @IBOutlet weak var secondRoadLabel: UILabel!
    @IBOutlet weak var thirdRoadLabel: UILabel!
    @IBOutlet weak var firstLimitLabel: UILabel!
    @IBOutlet weak var secondLimitLabel: UILabel!
    @IBOutlet weak var thirdLimitLabel: UILabel!
    
    weak var delegate: MyUIViewDelegate?
    
    func setMyview(firstRoadText: String,
                   secondRoadText: String,
                   thirdRoadText: String,
                   firstLimitText: String,
                   secondLimitText: String,
                   thirdLimitText: String){
        
        firstRoadLabel.text = firstRoadText
        secondRoadLabel.text = secondRoadText
        thirdRoadLabel.text = thirdRoadText
        firstLimitLabel.text = firstLimitText
        secondLimitLabel.text = secondLimitText
        thirdLimitLabel.text = thirdLimitText

    }
    
    func setSemaphoreFirst(firstRoadText: String,
                           firstLimitText: String){
        
        firstRoadLabel.text = firstRoadText
        firstLimitLabel.text = firstLimitText
        
    }
    
    func setSemaphoreSecond(secondRoadText: String,
                             secondLimitText: String){
        
        secondRoadLabel.text = secondRoadText
        secondLimitLabel.text = secondLimitText
    }
    
    func setSemaphoreThired(thirdRoadText: String,
                             thirdLimitText: String){
        thirdRoadLabel.text = thirdRoadText
        thirdLimitLabel.text = thirdLimitText
    }
    
    @IBAction func clickGroupBtn(_ sender: UIButton) {
        print("click")
        self.delegate?.useGroupGetData()
    }
    
    @IBAction func clickSemaphoreBtn(_ sender: UIButton) {
        print("click")
        self.delegate?.useSemaphoreGetData()
    }
    
    @IBAction func clearData(){
        
        self.delegate?.clearData()
    }

}
