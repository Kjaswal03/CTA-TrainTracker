//
//  StopsViewController.swift
//  CTA-TrainTracker
//
//  Created by Kashev Jaswal on 4/1/25.
//

import UIKit

class StopsViewController: UITableViewController {
    
    var lineCode: String?
    var stations: [String] = [] // This will hold station names fetched dynamically
    var stationIds: [Int] = []  // This will hold station IDs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(lineCode ?? "Line") Stations"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        loadStationIds()
    }
    
    func loadStationIds() {
        guard let lineCode = lineCode else { return }
        stationIds = StationData.shared.stationIds(forLineCode: lineCode)
        fetchStationNames()
    }
    
    func fetchStationNames() {
        guard let lineCode = lineCode else { return }

        // Fetching station IDs based on the selected line
        let stationIDs = StationData.shared.stationIds(forLineCode: lineCode)
        
        // Assuming each station ID corresponds to multiple arrivals at a single station
        for id in stationIDs {
            NetworkManager.shared.fetchArrivalDetails(forStationId: id) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let arrivalDetails):
                        if let stationName = arrivalDetails.first?.staNm {  // Assuming all arrivals at the same station have the same name
                            if !self!.stations.contains(stationName) {  // Avoid duplicates if multiple arrivals share the same station name
                                self?.stations.append(stationName)
                            }
                        }
                        self?.tableView.reloadData()
                    case .failure(let error):
                        print("Failed to fetch station details: \(error)")
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = stations[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ArrivalVC = ArrivalsViewController()
        ArrivalVC.stationId = stationIds[indexPath.row]
        navigationController?.pushViewController(ArrivalVC, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showArrivals", let destinationVC = segue.destination as? ArrivalsViewController, let indexPath = tableView.indexPathForSelectedRow {
            // Pass the selected station ID to the ArrivalsViewController
            destinationVC.stationId = stationIds[indexPath.row]
        }
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


