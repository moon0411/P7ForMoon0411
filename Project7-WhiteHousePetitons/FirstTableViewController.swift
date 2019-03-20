//
//  FirstTableViewController.swift
//  project7
//
//  Created by 李沐軒 on 2019/3/17.
//  Copyright © 2019 李沐軒. All rights reserved.
//

import UIKit

class FirstTableViewController: UITableViewController {
    
    var petitions = [Petition]()
    var searches = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        navigationItem.leftBarButtonItem?.tag = 1
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(openInfo))
        

        let urlStr: String
            
        if navigationController?.tabBarItem.tag == 0 {
            urlStr = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        } else {
            urlStr = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }
        
        
    
        if let url = URL(string: urlStr) {
            if let data = try? Data(contentsOf: url) {
                parsing(json: data)
                return
            }
        }
        
        showError()
        
        //This line not needed, your searches array can be populated when you do a search
        //searches = petitions
    }
    
    @objc func search() {
        let ac = UIAlertController(title: "search for key word", message: nil, preferredStyle: .alert)
        
        ac.addTextField(configurationHandler: nil)
        
        let submitAction = UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] (_) in
            guard let input = ac?.textFields?[0].text, case input.isEmpty = false else { return }
            
            self?.addIntoList(input)
           
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true, completion: nil)
        
    }
    
    func addIntoList(_ input: String) {
        
        // You are already performing an empty check inside your UIAlertAction, so not needed here

        let lowerInput = input.lowercased()
    
        // This line moved from inside your loop
        searches.removeAll(keepingCapacity: true)
        
        for petition in petitions {

            // Added lowercased to title and body so you can compare with your lowercased input
            if petition.title.lowercased().contains(lowerInput) || petition.body.lowercased().contains(lowerInput) {

                // This line is wiping your searches every iteration of the loop, it needs to be moved before the loop
                //searches.removeAll(keepingCapacity: true)
                
                // Append the petition to your searches array
                searches.append(petition)
                
                //searches.insert(search, at: 0)
                
                // Remove from inside loop
                //let indexPath = IndexPath(row: 0, section: 0)
                //tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                //tableView.reloadData()
            }
        }
        
        // After your loop has finished then check for nil results and reload tableview
        if searches.isEmpty {
            errorMessage(title: "no results.", message: "Can't find the petiton with keyword.")
            
            // You can repopulate your searches array to show all the petitions again until the next search
            searches = petitions
        }
        
        tableView.reloadData()
    }
    
    
    
    
    func errorMessage(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
        
    }
    
    @objc func openInfo() {
        let ac = UIAlertController(title: "We the People", message: "The data comes from the We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "Erron in loading, please check out and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
        
    }
   
    func parsing(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            
            // initially your searches array can show all the petitions
            searches = petitions
            tableView.reloadData()
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // You need to return searces.count here, not petitions.count
        return searches.count
        //return petitions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
//        if navigationItem.leftBarButtonItem?.tag == 1 {
//
//            cell.textLabel?.text = searches[indexPath.row].title
//            cell.detailTextLabel?.text = searches[indexPath.row].body
//            return cell
//        } else {
        
            let petition = searches[indexPath.row]
            cell.textLabel?.text = petition.title
            cell.detailTextLabel?.text = petition.body
            return cell
//        }


    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        //This should use searches array, not petitions array
        vc.detailItem = searches[indexPath.row]
        //vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
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

    

}
