//
//  ViewController.swift
//  HamtionTevin_CE03
//
//  Created by Tevin Hamilton on 9/11/19.
//  Copyright © 2019 Tevin Hamilton. All rights reserved.
//

import UIKit

//Mark:Extension UIColor
//extension to UIColor to convert String that carrys hex Code and convert it to UIColor.
extension UIColor
{
    func HexToUIColor(hex:String) -> UIColor
    {
        //have the incoming parameter equal to new var string data type.
        var hexString = hex
        
        //check for # and remove it
        if hexString.hasPrefix("#")
        {
            hexString.remove(at: hexString.startIndex)
        }
        
        // use UInt32 to convert convert hex code to rgb
        var rgb : UInt32 = 0
        
        //scan hexString and rgb string
        Scanner(string: hexString).scanHexInt32(&rgb)
        
        //return UIColor
        return UIColor.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgb & 0x0000FF) / 255.0, alpha: 1.0)
    }
}
class ViewController: UIViewController {
    
    //arrays to capture data from url
    var companyArray = [Company]()
    var companyInfoArray = [CompanyInfo]()
    
    //counter for the array object above
    var currentCounter = 0
    //MARK: UIOutLets
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelCompany: UILabel!
    @IBOutlet weak var labelVersion: UILabel!
    @IBOutlet weak var labelPhrase: UILabel!
    @IBOutlet weak var labelRevenue: UILabel!
    @IBOutlet weak var labelPrimary: UILabel!
    @IBOutlet weak var labelSecondary: UILabel!
    @IBOutlet weak var labelTertiary: UILabel!
    @IBOutlet weak var labelQuatnary: UILabel!
    @IBOutlet weak var labelColorOne: UILabel!
    @IBOutlet weak var labelColorTwo: UILabel!
    @IBOutlet weak var labelColorThree: UILabel!
    @IBOutlet weak var labelColorFour: UILabel!
    @IBOutlet weak var TextFieldColorOne: UITextField!
    @IBOutlet weak var TextFieldColorTwo: UITextField!
    @IBOutlet weak var TextFieldColorThree: UITextField!
    @IBOutlet weak var TextFieldColorFour: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //call first urlDownload to capture data from first url.
        FirstUrlDataDownLoad()
        
        //disable user interaction with text fields which they are only used to display color
        TextFieldColorOne.isUserInteractionEnabled = false
        TextFieldColorTwo.isUserInteractionEnabled = false
        TextFieldColorThree.isUserInteractionEnabled = false
        TextFieldColorFour.isUserInteractionEnabled = false
    }
    
    // function to pull data from first url that contains
    func FirstUrlDataDownLoad()
    {
        //create default config
        let config = URLSessionConfiguration.default
        
        //Create a session
        let session = URLSession(configuration: config)
        
        //Validate URL to ensure that it is not a broken link
        if let validURL = URL(string: "https://api.myjson.com/bins/9kj3f")
            
        {
            
            //Create a task that will download whatever is found at validURL as a Data object
            
            let task = session.dataTask(with: validURL) { (data, response, error) in
                
                //If there is an error the bail out of this entire method (return)
                if let error = error
                {
                    print("Data task failed with error " + error.localizedDescription)
                }
                
                //if we recieve this print the we have gather data pulled from url
                print("Success")
                
                //Check response status, validate the data
                guard let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200,
                    let validData = data
                    else {print("JSON Object creation failed."); return}
                //pull data from json object
                do {
                    let jsonObj = try JSONSerialization.jsonObject(with: validData, options: .mutableLeaves) as? [Any]
                    
                    guard let json = jsonObj
                        else{print("something went wrong");return}
                    
                    //loop through date with guard statement
                    for firstLevel in json
                    {
                        guard let object = firstLevel as? [String: Any],
                            let name = object ["name"] as? String,
                            let version = object ["version"] as? String,
                            let company = object ["company"] as? String
                            else {print("something went wrong "); continue}
                        
                        // add to the companyArray and Company class
                        self.companyArray.append(Company(name: name, version: version, company: company))
                    }
                    
                    //call SecondUrlDataDownLoad to retrive data from 2nd url.
                    self.SecondUrlDataDownLoad()
                    
                }
                    //print error
                catch {
                    print(error.localizedDescription)
                }
            }
        
            task.resume()
        }
        //test if data can be recieve.
        print("Test")
    }
    
    
    func SecondUrlDataDownLoad()
    {
        let config = URLSessionConfiguration.default
        
        //Create a session
        let session = URLSession(configuration: config)
        
        //Validate URL to ensure that it is not a broken link
        if let validURL = URL(string: "https://api.myjson.com/bins/1cxa6j") {
            //Create a task that will download whatever is found at validURL as a Data object
            let task = session.dataTask(with: validURL) { (data, response, error) in
                //If there is an error the bail out of this entire method (return)
                if let error = error {
                    print("Data task failed with error " + error.localizedDescription)
                }
                //If we get this then we have gotten the info at the URL as a Data Object and we can now use it
                print("Success")
                
                //Check response status, validate the data
                guard let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200,
                    let validData = data
                    else {print("JSON Object creation failed."); return}
                do {
                    
                    let jsonObj = try JSONSerialization.jsonObject(with: validData, options: .mutableLeaves) as? [Any]
                    guard let json = jsonObj
                        else{print("something went wrong");return}
                    
                    for firstLevel in json
                    {
                        guard let object = firstLevel as? [String: Any],
                            let catchPhrase = object ["catch_phrase"] as? String,
                            let color = object ["colors"] as? [[String :Any]]
                            else{continue}
                        
                        //create arrays to be passed into the CompanyInfo class
                        var descriptionArray = [String]()
                        var colorArray = [String]()
                        
                        //add data init or convenience init
                        func AddToCompanyInfoArray(catchPhrase:String,description:[String],color:[String])
                        {
                            //optional binding
                            if let dailyRevene = object ["daily_revene"] as? String
                            {
                                //designated initializer
                                self.companyInfoArray.append(CompanyInfo(catchPhrase: catchPhrase, dailyRevene: dailyRevene, description: descriptionArray, color: colorArray))
                            }
                            else
                            {
                                //convenience initializers
                                self.companyInfoArray.append(CompanyInfo(Phrase: catchPhrase, description: descriptionArray, color: colorArray))
                            }
                        }
                        
                        //loop through the color array
                        for secLevel in color
                        {
                            guard let description = secLevel ["desription"] as? String,
                                let color = secLevel ["color"] as? String
                                else{return}
                            //add to arrays above nested function to be used to be pass into function
                            descriptionArray.append(description)
                            colorArray.append(color)
                        }
                        
                        //pass retrieve data into function
                        AddToCompanyInfoArray(catchPhrase: catchPhrase,description: descriptionArray, color: colorArray)
                        self.DisplayCompanyData()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            //MUST ALWAYS START THE TASK... REALLY ALWAYS
            task.resume()
        }
        print("Test")
    }
    //set objects data to the appropriate labels and text field.
    func DisplayCompanyData()
    {
        DispatchQueue.main.async
            {
                self.labelName.text = self.companyArray[self.currentCounter].name
                self.labelCompany.text = self.companyArray[self.currentCounter].company
                self.labelVersion.text = self.companyArray[self.currentCounter].version
                self.labelPhrase.text = self.companyInfoArray[self.currentCounter].catchPhrase
                self.labelRevenue.text = self.companyInfoArray[self.currentCounter].dailyRevene
                self.labelPrimary.text = self.companyInfoArray[self.currentCounter].description[0]
                
                //switch statement to check how many colors are in the comapnyInfo class object in current index
                switch self.companyInfoArray[self.currentCounter].description.count
                {
                case 1:
                    //show labels and textfield to user based on description index.
                    self.labelColorOne.isHidden = false
                    self.labelPrimary.isHidden = false
                    self.TextFieldColorOne.isHidden = false
                    
                    //change background color based on hex code.
                    self.TextFieldColorOne.backgroundColor = UIColor().HexToUIColor(hex: self.companyInfoArray[self.currentCounter].color[0])
                    
                    //add color description to label
                    self.labelPrimary.text = self.companyInfoArray[self.currentCounter].description[0]
                    
                    // add hex code to the color label
                    self.labelColorOne.text = self.companyInfoArray[self.currentCounter].color[0]
                    
                    
                case 2:
                    
                    self.labelColorOne.isHidden = false
                    self.labelPrimary.isHidden = false
                    self.TextFieldColorOne.isHidden = false
                    
                    self.labelColorTwo.isHidden = false
                    self.labelSecondary.isHidden = false
                    self.TextFieldColorTwo.isHidden = false
                    
                    self.TextFieldColorOne.backgroundColor = UIColor().HexToUIColor(hex: self.companyInfoArray[self.currentCounter].color[0])
                    self.TextFieldColorTwo.backgroundColor = UIColor().HexToUIColor(hex: self.companyInfoArray[self.currentCounter].color[1])
                    
                    self.labelPrimary.text = self.companyInfoArray[self.currentCounter].description[0]
                    self.labelSecondary.text = self.companyInfoArray[self.currentCounter].description[1]
                    
                    self.labelColorOne.text = self.companyInfoArray[self.currentCounter].color[0]
                    self.labelColorTwo.text = self.companyInfoArray[self.currentCounter].color[1]
                    
                case 3:
                    
                    self.labelColorOne.isHidden = false
                    self.labelPrimary.isHidden = false
                    self.TextFieldColorOne.isHidden = false
                    
                    self.labelColorTwo.isHidden = false
                    self.labelSecondary.isHidden = false
                    self.TextFieldColorTwo.isHidden = false
                    
                    self.labelColorThree.isHidden = false
                    self.labelTertiary.isHidden = false
                    self.TextFieldColorThree.isHidden = false
                    
                    self.TextFieldColorOne.backgroundColor = UIColor().HexToUIColor(hex: self.companyInfoArray[self.currentCounter].color[0])
                    self.TextFieldColorTwo.backgroundColor = UIColor().HexToUIColor(hex: self.companyInfoArray[self.currentCounter].color[1])
                    self.TextFieldColorThree.backgroundColor = UIColor().HexToUIColor(hex: self.companyInfoArray[self.currentCounter].color[2])
                    
                    self.labelPrimary.text = self.companyInfoArray[self.currentCounter].description[0]
                    self.labelSecondary.text = self.companyInfoArray[self.currentCounter].description[1]
                    self.labelTertiary.text = self.companyInfoArray[self.currentCounter].description[2]
                    
                    self.labelColorOne.text = self.companyInfoArray[self.currentCounter].color[0]
                    self.labelColorTwo.text = self.companyInfoArray[self.currentCounter].color[0]
                    self.labelColorThree.text = self.companyInfoArray[self.currentCounter].color[0]
                    
                    
                case 4:
                    
                    self.labelColorOne.isHidden = false
                    self.labelPrimary.isHidden = false
                    self.TextFieldColorOne.isHidden = false
                    
                    self.labelColorTwo.isHidden = false
                    self.labelSecondary.isHidden = false
                    self.TextFieldColorTwo.isHidden = false
                    
                    self.labelColorThree.isHidden = false
                    self.labelTertiary.isHidden = false
                    self.TextFieldColorThree.isHidden = false
                    
                    self.labelColorFour.isHidden = false
                    self.labelQuatnary.isHidden = false
                    self.TextFieldColorFour.isHidden = false
                    
                    self.TextFieldColorOne.backgroundColor = UIColor().HexToUIColor(hex: self.companyInfoArray[self.currentCounter].color[0])
                    self.TextFieldColorTwo.backgroundColor = UIColor().HexToUIColor(hex: self.companyInfoArray[self.currentCounter].color[1])
                    self.TextFieldColorThree.backgroundColor = UIColor().HexToUIColor(hex: self.companyInfoArray[self.currentCounter].color[2])
                    self.TextFieldColorFour.backgroundColor = UIColor().HexToUIColor(hex: self.companyInfoArray[self.currentCounter].color[3])
                    
                    self.labelPrimary.text = self.companyInfoArray[self.currentCounter].description[0]
                    self.labelSecondary.text = self.companyInfoArray[self.currentCounter].description[1]
                    self.labelTertiary.text = self.companyInfoArray[self.currentCounter].description[2]
                    self.labelQuatnary.text = self.companyInfoArray[self.currentCounter].description[3]
                    
                    self.labelColorOne.text = self.companyInfoArray[self.currentCounter].color[0]
                    self.labelColorTwo.text = self.companyInfoArray[self.currentCounter].color[1]
                    self.labelColorThree.text = self.companyInfoArray[self.currentCounter].color[2]
                    self.labelColorFour.text = self.companyInfoArray[self.currentCounter].color[3]
                    
                default:
                    print("something went wrong")
                }
                
        }
    }
    
    //go back or foward based on yours button press
    @IBAction func CurrentCustomerChanged(_ sender: UIButton)
    {
        //hide all labels and textfields.
        self.labelColorOne.isHidden = true
        self.labelPrimary.isHidden = true
        self.TextFieldColorOne.isHidden = true
        
        self.labelColorTwo.isHidden = true
        self.labelSecondary.isHidden = true
        self.TextFieldColorTwo.isHidden = true
        
        self.labelColorThree.isHidden = true
        self.labelTertiary.isHidden = true
        self.TextFieldColorThree.isHidden = true
        
        self.labelColorFour.isHidden = true
        self.labelQuatnary.isHidden = true
        self.TextFieldColorFour.isHidden = true
        
        //add one to current index base on the button tag
        currentCounter += sender.tag
        
        //check if current idex is less then 0
        if currentCounter < 0 {
            currentCounter = companyArray.count - 1
        }
        //check if currentCounter is greater or equal to the index of comapny array.
        else if currentCounter >= companyArray.count {
            currentCounter = 0
        }
        //display data.
        self.DisplayCompanyData()
    }
    
}

