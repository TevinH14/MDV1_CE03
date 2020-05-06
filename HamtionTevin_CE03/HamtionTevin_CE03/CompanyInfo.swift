//
//  CompanyInfo.swift
//  HamtionTevin_CE03
//
//  Created by Tevin Hamilton on 9/11/19.
//  Copyright © 2019 Tevin Hamilton. All rights reserved.
//

import Foundation
import UIKit

class CompanyInfo
{
    let catchPhrase:String
    let dailyRevene:String?
    let description:[String]
    let color:[String]
    
    init (catchPhrase:String, dailyRevene:String!, description:[String], color:[String])
    {
        self.catchPhrase = catchPhrase
        self.dailyRevene = dailyRevene
        self.description = description
        self.color = color
    }
    convenience init(Phrase:String, revene:String? = nil, description:[String], color:[String])
    {
        //pass $0.00 string into the designated initializer
        self.init(catchPhrase:Phrase, dailyRevene: "$0.00", description:description, color:color)
    }
   
}


