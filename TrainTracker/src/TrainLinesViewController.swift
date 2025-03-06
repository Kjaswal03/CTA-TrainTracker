//
//  ViewController.swift
//
//  Created by Kashev Jaswal on 4/1/25.
//

import UIKit

class TrainLinesViewController: UITableViewController {
    
    let lines = ["Red Line", "Blue Line", "Brown Line", "Green Line", "Orange Line", "Purple Line", "Pink Line", "Yellow Line"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select a Train Line"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lines.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = lines[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stopsVC = StopsViewController()
        stopsVC.lineCode = lines[indexPath.row]
        navigationController?.pushViewController(stopsVC, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStops", let destinationVC = segue.destination as? StopsViewController, let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.lineCode = lines[indexPath.row]
        }
    }
}


