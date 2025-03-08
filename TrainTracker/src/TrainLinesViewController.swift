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
        let trainLine = lines[indexPath.row]
        cell.textLabel?.text = trainLine
    
        // Set the background color based on the trai line
        cell.backgroundColor = colorForTrainLine(trainLine)
        
        // Leave the
        cell.textLabel?.textColor = .black
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
    
    // Function to assign colors to each train line 
    func colorForTrainLine(_ trainLine: String) -> UIColor {
        switch trainLine {
        case "Red Line":
            return .systemRed
        case "Blue Line":
            return .systemBlue
        case "Brown Line":
            return .systemBrown
        case "Green Line":
            return .systemGreen
        case "Orange Line":
            return .systemOrange
        case "Purple Line":
            return .systemPurple
        case "Pink Line":
            return .systemPink
        case "Yellow Line":
            return .systemYellow
        default:
            return .white
        }
    }
}


