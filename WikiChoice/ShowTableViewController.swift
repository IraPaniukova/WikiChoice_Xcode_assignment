//
//  ShowTableViewController.swift
//  WikiChoice
//
//  Created by Ira Paniukova on 10/21/23.
//

import UIKit
import CoreData
var c : Choice!

class ShowTableViewController: UITableViewController {
    var choices : [Choice]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let deligate = UIApplication.shared.delegate as! AppDelegate
        let context = deligate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "Choice")
        do{
            choices = try context.fetch(request) as! [Choice]
            
        }
        catch {
            showMessage(msg: "Data fetching error", controller: self)}
       
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choices.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowCell", for: indexPath) as! ShowAllTableViewCell

        cell.titleLabel.text = choices[indexPath.row].title
        
        let i = choices[indexPath.row].image
        cell.ImgLabel?.image = UIImage(data: i!)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        c = choices[indexPath.row]
        performSegue(withIdentifier: "segue", sender: self)
        //it will go to another screen by using the identifier segue 
    }
}
