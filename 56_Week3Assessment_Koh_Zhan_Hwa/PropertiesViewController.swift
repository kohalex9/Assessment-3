//
//  PropertiesViewController.swift
//  56_Week3Assessment_Koh_Zhan_Hwa
//
//  Created by Alex Koh on 29/08/2017.
//  Copyright © 2017 AlexKoh. All rights reserved.
//

import UIKit
import CoreData

class PropertiesViewController: UIViewController {

    var selectedOwner: Owner?
    var propertyBelongToSelectedOwner: [Property] = []
    var navigationBackgroundNItemsColor: UIColor = UIColor.blue
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        setUpAddBarButton()
        
        self.title = "Properties"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadData()
        updateColorOfNavigationBarBackgroundAndItems()
    }
    
    func updateColorOfNavigationBarBackgroundAndItems() {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    //load properties by selected owner to the array of properties
    func loadData() {
        propertyBelongToSelectedOwner = []
        
        if let properties = selectedOwner?.hasProperty {
            for eachProperty in properties {
                guard let property = eachProperty as? Property else {
                    print("Error extractiong property from user")
                    return}
                propertyBelongToSelectedOwner.append(property)
            }
        }
        tableView.reloadData()
    }
    
    func setUpAddBarButton() {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnTapped))
        self.navigationItem.rightBarButtonItem = add
        
        //references: https://stackoverflow.com/questions/30022780/uibarbuttonitem-in-navigation-bar-programmatically
    }
    
    func addBtnTapped() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let destination = mainStoryboard.instantiateViewController(withIdentifier: "PropertyDetailsViewController") as? PropertyDetailsViewController else {return}
        
        destination.selectedOwner = selectedOwner
        destination.isAddBtnFromPropertiesVCTapped = true
        destination.navigationBackgroundNItemsColor = navigationBackgroundNItemsColor
        
        navigationController?.pushViewController(destination, animated: true) 
    }
    
}

extension PropertiesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return number of properties own by the selected owner
        return propertyBelongToSelectedOwner.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let property = propertyBelongToSelectedOwner[indexPath.row]
        
        cell.textLabel?.text = property.name
        cell.detailTextLabel?.text = "\(property.location ?? "Unknown location"), \(property.price)"
        
        return cell
    }
}


extension PropertiesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedProperty = propertyBelongToSelectedOwner[indexPath.row]
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let destination = mainStoryBoard.instantiateViewController(withIdentifier: "PropertyDetailsViewController") as? PropertyDetailsViewController else { return }
        
        destination.selectedOwner = selectedOwner
        destination.selectedPropertyFromPreviosVC = selectedProperty
        destination.isAddBtnFromPropertiesVCTapped = false
        destination.navigationBackgroundNItemsColor = navigationBackgroundNItemsColor
        
        navigationController?.pushViewController(destination, animated: true)
        
    }
}


































