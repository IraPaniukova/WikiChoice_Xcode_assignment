//
//  BrowseViewController.swift
//  WikiChoice
//
//  Created by Ira Paniukova on 10/20/23.
//

import UIKit
import CoreData

var temp: String = ""

class BrowseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlLabel.isHidden=true
        textView.isHidden=true
        
    }
    
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBAction func searchButton(_ sender: UIButton) {
        if searchTextField.hasText{
            let Utag = searchTextField.text!.replacingOccurrences(of: " ", with: "_")
            let url_string = "https://en.wikipedia.org/api/rest_v1/page/summary/\(Utag)"  //main API
            let url_stringR = "https://en.wikipedia.org/w/api.php?action=query&prop=revisions&rvprop=content&format=json&titles=\(Utag)"  //API for reference pages
            
            //create url object out of the string
            let an_url = URL(string: url_string)
            let urlRequest = URLRequest(url: an_url!)
            
            //create url object out of the string for reference pages
            let an_urlR = URL(string: url_stringR)
            let urlRequestR = URLRequest(url: an_urlR!)
            
            let task = URLSession.shared.dataTask(with: urlRequest)
            {
                (data,response,error)
                in
                if (error == nil)
                {
                    let jsonD = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                    // print("JsonD: \(jsonD)")
//-----Attribute1--Title-------------------------------------------
                    let title = jsonD["title"] as? String
                    if title != "Not found."
                    
                    {
                        temp = title!
 //-----Attribute2--Image-------------------------------------------
                        if jsonD["originalimage"] != nil || (jsonD["originalimage"] as? [String: Any])?["source"] != nil
                        {
                            let photoString = jsonD["originalimage"] as! [String: Any]
                            //   print("photoString: \(photoString)")
                            let imgString = photoString["source"] as! String
                            //    print("Image URL: \(imgString)")
                            //creating a URL object from a string
                            let imageURL = URL(string: imgString)
                            DispatchQueue.main.async   //to make next piece a hight priority
                            {
                                let imgData = try! Data(contentsOf: imageURL!)
                                let image = UIImage(data: imgData)
                                self.imgLabel.isHidden = false
                                self.imgLabel.image = image
                            }
                        }
                        else {
                            //-------------alternative images from unsplash if Wikipedia doesnt have an image for an article:
                            let unsplashLink = "https://source.unsplash.com/featured/?\(Utag)"
                            let unsplashUrl = URL(string: unsplashLink)
                            DispatchQueue.main.async{
                                if unsplashUrl != nil
                                {
                                    let unsplashData = try! Data(contentsOf: unsplashUrl!)
                                    let unsplashImg = UIImage(data: unsplashData)
                                    self.imgLabel.image = unsplashImg}
                                else {
                                    self.imgLabel.image = UIImage(named: "noPhoto")
                                }
                            }
                        }
 //-------Attribute3--Link to Wikipedia-------------------------
                        if let contentUrls = jsonD["content_urls"] as? [String: Any],
                           let desktopUrls = contentUrls["desktop"] as? [String: String],
                           let pageLink = desktopUrls["page"] {
                            
                            DispatchQueue.main.async {
                                self.urlLabel.isHidden = false
                                self.urlLabel.isEditable = false
                                self.urlLabel.text = pageLink
                                self.urlLabel.dataDetectorTypes = .link
                            }
                        }
                        else {self.urlLabel.text = ""}
                        
//------Attribute4--Description----------------------------------
                        if jsonD["extract"] != nil
                        
                        {
                            let dscrptn = jsonD["extract"] as! String
                            if jsonD["type"] != nil{
                                let type = jsonD["type"] as? String
                                if type != "disambiguation"  //I added this line because I came accros the word Limb and Go that have a pages but don't have a particular description, just references. Such pages have type "disambiguation". To fetch more information I needed to add additional json string to my app to fetch some more data for the page
                                {
                                    //  print(dscrptn)
                                    DispatchQueue.main.async {
                                        self.textView.isHidden = false
                                        self.textView.text = dscrptn
                                    }}
                                else{
                                    DispatchQueue.main.async {
                                        self.textView.isHidden = false
                                        //for reference pages:----------------------
                                        let taskR = URLSession.shared.dataTask(with: urlRequestR)
                                        {
                                            (data,response,error)
                                            in
                                            if (error == nil)
                                            {
                                                let jsnD = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                                                //  print(jsnD)
                                                if let query = jsnD["query"] as? [String: Any],
                                                   let pages = query["pages"] as? [String: [String: Any]],
                                                   let pageN = pages.values.first,  //I discovered that the json string has different ids in pages, that is why I try to access it before continuing
                                                   let pageId = pageN["pageid"] as? Int,
                                                   let pageData = pages[String(pageId)],
                                                   let revisions = pageData["revisions"] as? [[String: Any]],
                                                   var result: String = revisions[0]["*"] as? String
                                                {
                                                    print(result)
                                                    //      print("Pages: \(pages)")
                                                    //    print("PageID: \(pageId)")
                                                    if let range = result.range(of: "==") {
                                                        result = String(result[range.upperBound...])
                                                    }
                                                    if let range = result.range(of: "{{disambig", options: .caseInsensitive) {
                                                        result = String(result[..<range.lowerBound])
                                                    }
                                                    result = result.replacingOccurrences(of: "{{", with: "")
                                                    result = result.replacingOccurrences(of: "}}", with: "")
                                                    result = result.replacingOccurrences(of: "[[", with: "")
                                                    result = result.replacingOccurrences(of: "]]", with: "")
                                                    //print(result)
                                                    DispatchQueue.main.async {
                                                        self.textView.text = "It's a reference page. Go to the Wikipedia page to get more information. Here you can find some more useful details. You can modify your search based on it: \n\n" + "==" + result}
                                                }
                                                else {DispatchQueue.main.async {self.textView.text = "It's a reference page. Go to the Wikipedia page to get more information."}}
                                            }
                                        }
                                        taskR.resume()  //lets you to execute the code above
                                    }
                                }
                            }
                        }
                    }
                    else{
                        DispatchQueue.main.async {
                            let name = self.searchTextField.text!.prefix(1).uppercased() + self.searchTextField.text!.lowercased().dropFirst()  //just some styling here
                            showMessage(msg: "There is no article " + name + " in Wikipedia", controller: self)}
                        //the function is made in ViewController, I needed to add DispatchQueue.main.async there, otherwise the program would fail
                    }
                }
            }
            task.resume()  //lets you to execute the code above
        }
        else {
            showMessage(msg: "The search field is empty", controller: self)
        }
    }
    
    
    
    @IBOutlet weak var imgLabel: UIImageView!
    
    
    
    @IBOutlet weak var urlLabel: UITextView!
    
    
    @IBOutlet weak var textView: UITextView!
    
    
    @IBAction func saveButton(_ sender: UIButton) {
        //next 2 lines delegate access
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let s = searchByTitle (searchTitle: temp)
        if s == nil
        {
            let x = try! NSEntityDescription.insertNewObject(forEntityName: "Choice", into: context) as! Choice
            if temp != "" && searchTextField.hasText && urlLabel.hasText && textView.hasText {
                x.title = temp
                x.link = urlLabel.text!
                x.dscrptn = textView.text!
                x.image = imgLabel.image?.pngData()  //pngData will convert data to binary data
                do{
                    try
                        context.save()
                    showMessage(msg: "The article " + temp + " is saved", controller: self)
                    temp = ""
                    searchTextField.text = ""
                    urlLabel.text = ""
                    textView.text = ""
                    textView.isHidden = true
                    imgLabel.isHidden = true
                    urlLabel.isHidden = true
                }
                catch{
                    showMessage(msg: "An error occured", controller: self)
                }
            }
        }
        else {showMessage(msg: "You already have the article " + temp + " saved in your databese", controller: self)}
    }
    
}
