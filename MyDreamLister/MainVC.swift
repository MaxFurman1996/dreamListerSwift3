//
//  MainVC.swift
//  MyDreamLister
//
//  Created by Max Furman on 6/4/17.
//  Copyright © 2017 Max Furman. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var controller : NSFetchedResultsController<Item>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //generateTestData()
        attemptFetch()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections{
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections{
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath)
        return cell
        
    }
    
    func configureCell(cell : ItemCell, indexPath : IndexPath){
        let item = controller.object(at: indexPath)
        cell.configureCell(item: item)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = controller.fetchedObjects, objs.count > 0 {
            let item = objs[indexPath.row]
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "ItemDetailsVC", sender: item)
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailsVC"{
            if let dest = segue.destination as? ItemDetailsVC{
                if let item = sender as? Item{
                    dest.itemToEdit = item
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    func attemptFetch(){
        let fetchRequest : NSFetchRequest<Item> = Item.fetchRequest()
        
        var sort: NSSortDescriptor!
        let index = segment.selectedSegmentIndex
        if index == 0{
            sort = NSSortDescriptor(key: "created", ascending: false)
        } else if index == 1 {
            sort = NSSortDescriptor(key: "price", ascending: false)
        } else if index == 2{
            sort = NSSortDescriptor(key: "name", ascending: false).reversedSortDescriptor as! NSSortDescriptor
        } else {
            sort = NSSortDescriptor(key: "toType.type", ascending: false).reversedSortDescriptor as! NSSortDescriptor
        }
        
        fetchRequest.sortDescriptors = [sort]
        
//Written in AppDelegate.swift
//        let ad = UIApplication.shared.delegate as! AppDelegate
//        let context = ad.persistentContainer.viewContext
        
         let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        self.controller = controller
        
        do{
            try controller.performFetch()
            
        }catch {
            let error = error as NSError
            print(error.debugDescription)
        }
        
        
        
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .fade)
                ad.saveContext()
            }
            break
        case .delete:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath{
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                configureCell(cell: cell, indexPath: indexPath as IndexPath)
            }
            break
        case .move:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
    
    //To generate 4 items(cells)
    func generateTestData(){
        let item1 = Item(context: context)
        item1.name = "macbook pro"
        item1.price = 1300
        item1.details = "1"
        
        let item2 = Item(context: context)
        item2.name = "macbook air"
        item2.price = 255
        item2.details = "2"
        
        let item3 = Item(context: context)
        item3.name = "car"
        item3.price = 322
        item3.details = "3"
        
        let item4 = Item(context: context)
        item4.name = "iphone"
        item4.price = 1488
        item4.details = "4"
        
        ad.saveContext()
    }
    
    @IBAction func onSegmentChange(_ sender: UISegmentedControl) {
        attemptFetch()
        tableView.reloadData()
    }
    

}

