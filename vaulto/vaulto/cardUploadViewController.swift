//
//  cardUploadViewController.swift
//  vaulto
//
//  Created by ShreeThaanu RK on 10/02/19.
//  Copyright © 2019 strlab. All rights reserved.
//

import UIKit
import CoreData

class cardUploadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
 
    @IBOutlet weak var shoTable: UITableView!
    @IBOutlet weak var addView: UIStackView!
    
    @IBOutlet weak var cvv: UITextField!
    @IBOutlet weak var bankName: UITextField!
    @IBOutlet weak var expiryDate: UITextField!
    @IBOutlet weak var holderaName: UITextField!
    @IBOutlet weak var cardNum: UITextField!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var cardData = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shoTable.isHidden = true
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "UserCard", in: context)
    }
    
    func display(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserCard")
        request.returnsObjectsAsFaults = false
        do {
            let context = appDelegate.persistentContainer.viewContext
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                print("thee data is ", data)

                cardData.append(data.value(forKey: "bankname") as! String)
                shoTable.reloadData()
            }
        } catch {
            print("Failed")
        }
    }
    @IBAction func rearPic(_ sender: Any) {
        
    }
    @IBAction func frontPic(_ sender: Any) {
        
    }
    
    @IBAction func addCard(_ sender: Any) {
        shoTable.isHidden = true
        addView.isHidden = false
    }
    
    @IBAction func showUp(_ sender: Any) {
         shoTable.isHidden = false
         addView.isHidden = true
         display()
    }
    
    @IBAction func submit(_ sender: Any) {
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "UserCard", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(cardNum.text, forKey: "holdernumber")
        newUser.setValue(bankName.text, forKey: "bankname")
        newUser.setValue(holderaName.text, forKey: "holdername")
        newUser.setValue(cvv.text, forKey: "cvv")
        newUser.setValue(expiryDate.text, forKey: "expiry")
        do {
            try context.save()
            print("savedd")
        } catch {
            print("Failed saving")
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardTableViewCell", for: indexPath) as! cardTableViewCell
        cell.textLabel?.text = cardData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
