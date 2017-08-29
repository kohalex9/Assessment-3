//
//  OwnersViewController.swift
//  56_Week3Assessment_Koh_Zhan_Hwa
//
//  Created by Alex Koh on 29/08/2017.
//  Copyright © 2017 AlexKoh. All rights reserved.
//

import UIKit
import CoreData

class OwnersViewController: UIViewController {

    var owners: [Owner] = []
    var navigationBackgroundNItemsColor: UIColor?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        loadData()
        writeToCoreDataFromNamePlistIfEmpty()
        loadData()
        
        self.title = "Property Owners"
    }
    
    @IBAction func colorBtnTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Change Color", message: "Change Color of Navigation Items and Navigation Bar Background", preferredStyle: .alert)
        
        let red = UIAlertAction(title: "Red", style: .default) { (action) in
            self.navigationBackgroundNItemsColor = UIColor.red
        self.updateColorOfNavigationBarBackgroundAndItems()
        }
        alert.addAction(red)
        
        let orange = UIAlertAction(title: "Orange", style: .default) { (action) in
            self.navigationBackgroundNItemsColor = UIColor.orange
        self.updateColorOfNavigationBarBackgroundAndItems()
        }
        alert.addAction(orange)
        
        let black = UIAlertAction(title: "Black", style: .default) { (action) in
            self.navigationBackgroundNItemsColor = UIColor.black
        self.updateColorOfNavigationBarBackgroundAndItems()
        }
        alert.addAction(black)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func loadData() {
        let request = NSFetchRequest<Owner>(entityName: "Owner")
        
        //Sort by owner name from A-Z
        let ownerNameAlphabetSort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [ownerNameAlphabetSort]
        
        do {
            let data = try DataController.managedObjectContext.fetch(request)
            
            owners = data
            tableView.reloadData()
        } catch {}
    }
    
    func writeToCoreDataFromNamePlistIfEmpty() {
        if owners.count == 0 {
            //Read from plist then write the data to core data
            
            guard let filePath = Bundle.main.path(forResource: "users", ofType: "plist") else {
                print("File not found")
                return}
            
            guard let itemsFromPlist = NSArray(contentsOfFile: filePath) else {
                print("Error when reading an array of items from the file")
                return}
            
            for item in itemsFromPlist {
                guard let desc = NSEntityDescription.entity(forEntityName: "Owner", in: DataController.managedObjectContext) else {
                    print("eRROr")
                    return}
                let newOwner = Owner(entity: desc, insertInto: DataController.managedObjectContext)
                
                guard let itemInString = item as? String else {return}
                
                newOwner.name = itemInString
            }
            
            
        } else {
            //Do nothing
        }
    }
    
    func updateColorOfNavigationBarBackgroundAndItems() {
        self.navigationController?.navigationBar.tintColor = navigationBackgroundNItemsColor
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }


}

extension OwnersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return owners.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = owners[indexPath.row].name
        
        return cell
    }
}

extension OwnersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = owners[indexPath.row]
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let destination = mainStoryboard.instantiateViewController(withIdentifier: "PropertiesViewController") as? PropertiesViewController else {return}
        
        destination.selectedOwner = selectedCell
        destination.navigationBackgroundNItemsColor = navigationBackgroundNItemsColor
        
        navigationController?.pushViewController(destination, animated: true) 
    }
}




















