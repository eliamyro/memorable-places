//
//  PlacesViewController.swift
//  Memorable Places
//
//  Created by Elias Myronidis on 28/4/17.
//  Copyright © 2017 eliamyro. All rights reserved.
//

import UIKit


class PlacesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    var storedPlaces = [Dictionary<String, String>()]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let storedPlacesTemp = UserDefaults.standard.object(forKey: "storedPlaces") as? [Dictionary<String, String>]{
            storedPlaces = storedPlacesTemp
        }
        
        if storedPlaces.count == 1 && storedPlaces[0].count == 0 {
            storedPlaces.remove(at: 0)
            storedPlaces.append(["name":"Taj  Majal","lat":"27.175277","lon":"78.0421"])
            UserDefaults.standard.set(storedPlaces, forKey: "storedPlaces")
        }
        
        tableView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return storedPlaces.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        if storedPlaces[indexPath.row]["name"] != nil {
            cell.textLabel?.text = storedPlaces[indexPath.row]["name"]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let activePlace = indexPath.row
        let locationsBundle = [storedPlaces, activePlace] as [Any]
        performSegue(withIdentifier: "fromCellToMap", sender: locationsBundle)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            storedPlaces.remove(at: indexPath.row)
            UserDefaults.standard.set(storedPlaces, forKey: "storedPlaces")
            tableView.reloadData()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromCellToMap"{
            let mapViewController = segue.destination as! MapViewController
            mapViewController.locationsBundle = sender as? [Any]
        }
    }

    

}

