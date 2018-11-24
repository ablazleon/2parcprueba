//
//  StringTableViewController.swift
//  2parcprueba
//
//  Created by Adrian on 24/11/2018.
//  Copyright © 2018 Adrian. All rights reserved.
//

import UIKit

class StringTableViewController: UITableViewController {

    var items = [String]()
    let URLBASE = "https://www.dit.upm.es/santiago/examen/datos212.json"
    var imagesCache = [String:UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        updateItems()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)

        // Configure the cell...
        let item = items[indexPath.row]
        cell.textLabel?.text = item
        // print(item)
        
        let imgurl = items[indexPath.row]
        if let img = imagesCache[imgurl] {
            cell.imageView?.image = img
        } else {
            cell.imageView?.image = UIImage(named: "none")
            updateImage(imgurl, indexPath: indexPath)
        }
        
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // WHen viewDidLoad it is download the items and repesetn them in the table
    func updateItems() {
        
        // 1. Get url
        guard let url = URL(string: URLBASE) else {
            print("Bad url")
            return
        }
        
        // 2. Get the data and transform the data donwloaded, in an object
        guard let data = try? Data(contentsOf: url) else {
            print("Bad data")
            return
        }
        
        if let itemsSerialized = (try? JSONSerialization.jsonObject(with: data)) as? [String]{
            
        // 3. Store them: used a main.async, onyl to access one.
            DispatchQueue.main.async {
                self.items = itemsSerialized
                
        // 4. Reload data in the table
                self.tableView.reloadData()
            }
        }
        else {
            print("Either casting or serialization failed")
        }
    }
   
    // Given an url, it downloads the image and reload the row.
    func updateImage(_ urlString: String, indexPath: IndexPath){
        
        // 1. Get the url and scape it
        
        guard let urlScaped = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Bad scaping")
            return
        }
        print(urlScaped)
        
        guard let url = URL(string: urlScaped) else {
            print("Bad Url")
            return
        }
        
        // 2. Get data
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else {
                print("Bad data")
                return
            }
            
        // 3. Transform into an img
            
            if let img = UIImage(data: data){
                
        // 4. Store the img in a cache
                
                DispatchQueue.main.async {
                    self.imagesCache[urlString] = img
                    print(urlString)
                    
        // 5. Reload the row
                    
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
            
        }
        
        

    }
}
