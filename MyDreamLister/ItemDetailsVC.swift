//
//  ItemDetailsVC.swift
//  MyDreamLister
//
//  Created by Max Furman on 6/7/17.
//  Copyright © 2017 Max Furman. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, NSFetchedResultsControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var itemImg: UIImageView!
    @IBOutlet weak var titleLbl: CustomTextField!
    @IBOutlet weak var priceLbl: CustomTextField!
    @IBOutlet weak var detailsLbl: CustomTextField!
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var imgView: UIImageView!
    
    var stores = [Store]()
    var itemTypes = [ItemType]()
    var itemToEdit: Item!
    
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboard()

        if let navBar = self.navigationController?.navigationBar{
            
            navBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
            
            navBar.tintColor = UIColor.darkGray

        }
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        
        getStores()
        getItemTypes()
        
        
        
        if itemToEdit != nil {
            loadItemData()
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return stores.count
        } else {
            return itemTypes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return stores[row].name
        } else {
            return itemTypes[row].type
        }
        
    }
    
    
    func getStores(){
        let fetchRequest : NSFetchRequest<Store> = Store.fetchRequest()
        let sortByName = NSSortDescriptor(key: "name", ascending: false).reversedSortDescriptor as! NSSortDescriptor
        fetchRequest.sortDescriptors = [sortByName]
        
        do{
            let storesInCoreData = try context.fetch(fetchRequest)
            

            if storesInCoreData.count != 0 {
                self.stores = storesInCoreData
            } else {
                addStores()
                getStores()
                return
            }
            
            self.storePicker.reloadAllComponents()
        } catch {
            let error = error as NSError
            print(error.debugDescription)
        }
    }
    
    func getItemTypes(){
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        let sortByName = NSSortDescriptor(key: "type", ascending: false).reversedSortDescriptor as! NSSortDescriptor
        fetchRequest.sortDescriptors = [sortByName]
        
        do{
            let itemTypesInCoreData = try context.fetch(fetchRequest)
            
            if itemTypesInCoreData.count != 0 {
                itemTypes = itemTypesInCoreData
            } else {
                addTypes()
                getItemTypes()
                return
            }
        } catch {
            let error = error as NSError
            print(error.debugDescription)
        }
    }
    
    func addStores(){
        let store = Store(context: context)
        store.name = "Best Buy"
        let store2 = Store(context: context)
        store2.name = "Amazon"
        let store3 = Store(context: context)
        store3.name = "Rozetka"
        let store4 = Store(context: context)
        store4.name = "Ali Express"
        let store5 = Store(context: context)
        store5.name = "Stylus"
        ad.saveContext()
    }
    
    func addTypes(){
        let itemType = ItemType(context: context)
        itemType.type = "Vehicle"
        let itemType2 = ItemType(context: context)
        itemType2.type = "Electronic"
        let itemType3 = ItemType(context: context)
        itemType3.type = "Literature"
        let itemType4 = ItemType(context: context)
        itemType4.type = "Sport"
        let itemType5 = ItemType(context: context)
        itemType5.type = "Food"
        let itemType6 = ItemType(context: context)
        itemType6.type = "Entertainment"
        ad.saveContext()
    }
    
    func loadItemData(){
        if let item = itemToEdit{
            titleLbl.text = item.name
            priceLbl.text = "\(item.price)"
            detailsLbl.text = item.details
            
            imgView.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore{
                for i in 0...stores.count{
                    if stores[i].name == store.name{
                        storePicker.selectRow(i, inComponent: 0, animated: false)
                        break
                    }
                }
            }
            
            if let itemType = item.toType{
                for i in 0...itemTypes.count{
                    if itemType.type == itemTypes[i].type{
                        storePicker.selectRow(i, inComponent: 1, animated: false)
                        break
                    }
                }
            }
            
        }
    }
    
    

    
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        
        var item: Item!


        if itemToEdit == nil{
            item = Item(context: context)
        } else {
            item = itemToEdit
        }
        
        if let image = imgView.image{
            let picture = Image(context: context)
            picture.image = image
            item.toImage = picture
        }
        
        
        if let title = titleLbl.text{
            item.name = title.capitalized
        }
        
        if let price = priceLbl.text{
            item.price = (price as NSString).doubleValue
        }
        
        if let details = detailsLbl.text{
            item.details = details
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        item.toType = itemTypes[storePicker.selectedRow(inComponent: 1)]
        
        navigationController?.popViewController(animated: true)
        
    }
  
    @IBAction func removeBtnPressed(_ sender: UIBarButtonItem) {
        if (itemToEdit != nil){
            context.delete(itemToEdit)
            ad.saveContext()
        }
        
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
        
    }

    @IBAction func imgBtnPressed(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imgView.image = img
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
}


extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
