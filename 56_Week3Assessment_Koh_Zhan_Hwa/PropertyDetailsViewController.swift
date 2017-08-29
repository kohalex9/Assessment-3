//
//  PropertyDetailsViewController.swift
//  56_Week3Assessment_Koh_Zhan_Hwa
//
//  Created by Alex Koh on 29/08/2017.
//  Copyright © 2017 AlexKoh. All rights reserved.
//

import UIKit
import CoreData

class PropertyDetailsViewController: UIViewController {

    var selectedOwner: Owner?
    var selectedPropertyFromPreviosVC: Property?
    var isAddBtnFromPropertiesVCTapped: Bool?
    var navigationBackgroundNItemsColor: UIColor?
    
    @IBOutlet weak var propertyNameTextField: UITextField!
    @IBOutlet weak var propertyPriceTextField: UITextField!
    @IBOutlet weak var propertyLocationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideDefaultBackBtn()
        setupDoneBarItem()
        setupTextFieldWithInitialData(isAddBtnTapped: isAddBtnFromPropertiesVCTapped!)
        
        self.title = "Add properties"
    }
    
    //before going back to previous VC - PropertiesVC,
    //save all changes back to core data
    override func viewWillDisappear(_ animated: Bool) {
        DataController.saveContext()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = navigationBackgroundNItemsColor
    }
    
    func setupTextFieldWithInitialData(isAddBtnTapped: Bool) {
        if !isAddBtnTapped {
            propertyNameTextField.text = selectedPropertyFromPreviosVC?.name
            propertyLocationTextField.text = selectedPropertyFromPreviosVC?.location
            if let price = selectedPropertyFromPreviosVC?.price {
                propertyPriceTextField.text = "\(price)"
            }
            
        }
    }
    
    func extractDataFromTextFields(isAddBtnTapped: Bool) {
        guard let nameProperty = propertyNameTextField.text else {return}
        guard let priceProperty = propertyPriceTextField.text, let price = Int16(priceProperty) else {
            propertyPriceTextField.text = ""
            return}
        guard let locationProperty = propertyLocationTextField.text else {return}
        
        
        if isAddBtnTapped {
            //1. create a new property object
            //2. add the new property object to the selected owner
            //3. update each attribute of this specific property
            
            //1.
            guard let entityDesc = NSEntityDescription.entity(forEntityName: "Property", in: DataController.managedObjectContext) else {return}
            let newProperty = Property(entity: entityDesc, insertInto: DataController.managedObjectContext)
            
            //2.
            newProperty.name = nameProperty
            newProperty.location = locationProperty
            newProperty.price = price
            
            //3.
            selectedOwner?.addToHasProperty(newProperty)
        } else if !isAddBtnTapped {
            selectedPropertyFromPreviosVC?.name = nameProperty
            selectedPropertyFromPreviosVC?.location = locationProperty
            selectedPropertyFromPreviosVC?.price = price

        } else {
            print("Some logic error at doneBtnTapped, check it!")
        }
        
    }
    
    func hideDefaultBackBtn() {
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        //reference & attribute: https://stackoverflow.com/questions/29779060/how-to-remove-default-back-navigation-button
    }
    
    func setupDoneBarItem() {
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnTapped))
        
        if navigationBackgroundNItemsColor != nil {
            done.tintColor = UIColor.white
        }
        
        self.navigationItem.rightBarButtonItem = done
    }
    
    func isTextFieldsAreEmpty() -> Bool {
        
        if (propertyNameTextField.text?.isEmpty)! && (propertyPriceTextField.text?.isEmpty)! && (propertyLocationTextField.text?.isEmpty)! {
            return true
        }
        
        return false
    }
    
    func doneBtnTapped() {
        
        if isTextFieldsAreEmpty() {
            navigationController?.popViewController(animated: true)
            return
        }
        extractDataFromTextFields(isAddBtnTapped: isAddBtnFromPropertiesVCTapped!)

        //quick fix to ensure no values other than Int16 is used at priceTextField
        if let priceProperty = propertyPriceTextField.text, let price = Int16(priceProperty) {
        } else {
            propertyPriceTextField.text = ""
            return
        }
        
        navigationController?.popViewController(animated: true)
    }

}
