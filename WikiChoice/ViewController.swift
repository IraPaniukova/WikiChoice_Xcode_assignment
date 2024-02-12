//
//  ViewController.swift
//  WikiChoice
//
//  Created by Ira Paniukova on 10/20/23.
/* The app allows a user to search for a random article from Wikipedia and display it.
 Some Wikipedia pages do not have images, which is why, I am fetching images based on the search word and adding it when displaying such articles.
 Some Wikipedia articles do not have proper descriptions in the first API, which is why I am using another one to get some related information in the description.
 The app allows to save the chosen article (includes attributes of the title, image, link to the page, and description(extract)).
 The app allows to display of a table of saved data that includes the title and the image.
 By clicking to see more details, a user can see all related attributes for a chosen article. */

import UIKit
import CoreData



//function to show pop-up message
func showMessage(msg: String, controller: UIViewController) {
    DispatchQueue.main.async {
        //I added DispatchQueue here because ootherwise the app would crush when browsing (in BrowseViewController)
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { action in
            controller.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        controller.present(alert, animated: true, completion: nil)
    }
}

//function to search DB by title

func searchByTitle (searchTitle: String) -> Choice?
{   var mydata: Choice?
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let context = delegate.persistentContainer.viewContext
    let request = NSFetchRequest<NSManagedObject>(entityName: "Choice")
    let predicate = NSPredicate(format: "title ==[c] %@", searchTitle)
   // [c] removes case sencitivity
    request.predicate = predicate
    if !(try! (context.fetch(request) as! [Choice] )).isEmpty
     {
         mydata =  try! (context.fetch(request) as! [Choice] )[0]
    }
    return mydata
}



/*  // I made this code before the class where you showed us how to use predicate, I think. But because there is a better option, I changed it
var choices : [Choice]!
// function to fetch data from our DB
func ReadData(controller: UIViewController) -> [Choice]
{
    let deligate = UIApplication.shared.delegate as! AppDelegate
    let context = deligate.persistentContainer.viewContext
    
    let request = NSFetchRequest<NSManagedObject>(entityName: "Choice")
    do{
        choices = try context.fetch(request) as! [Choice]
        return choices
    }
    catch {
        showMessage(msg: "Data fetching error", controller: controller)
        return []
    }
}

//function to search DB by title
 func searchByTitle (searchTitle: String, controller: UIViewController) -> Choice?
{
    var found : Choice? = nil
    var choices = ReadData(controller: controller)
    for i in choices{
        if i.title == searchTitle
        {
            found = i
            break
        }
    }
    return found
}

*/


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }


}


