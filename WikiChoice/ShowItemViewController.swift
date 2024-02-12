//
//  ShowItemViewController.swift
//  WikiChoice
//
//  Created by Ira Paniukova on 10/22/23.
//

import UIKit

class ShowItemViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var imgLabel: UIImageView!
    @IBOutlet weak var linkLabel: UITextView!
    
    @IBOutlet weak var dscrpnLabel: UITextView!
    
    
    override func viewDidAppear(_ animated: Bool) {
        titleLabel.text = c.title
        
        let i = c.image
        imgLabel.image = UIImage(data: i!)
        
        linkLabel.isEditable = false
        linkLabel.text = c.link
        linkLabel.dataDetectorTypes = .link
       
        dscrpnLabel.text = c.dscrptn
        
      
    }
}
