//
//  ArrivalsViewController.swift
//  CTA-TrainTracker
//
//  Created by Kashev Jaswal on 4/1/25.
//

import UIKit

class ArrivalsViewController: UITableViewController {
    var stationId: Int?
    var arrivals: [ETA] = []  // This will hold all the arrival details for the selected station
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Train Arrivals"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshArrivalData(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl!) // Add refresh control to the table view
        
        if let stationId = stationId {
            fetchArrivalDetails(for: stationId)
        }
    }
    
    @objc private func refreshArrivalData(_ sender: Any) {
        guard let stationId = stationId else { return }
        fetchArrivalDetails(for: stationId)
    }
    
    
    
    private func fetchArrivalDetails(for stationId: Int) {
        NetworkManager.shared.fetchArrivalDetails(forStationId: stationId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let arrivalDetails):
                    self?.arrivals = arrivalDetails
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Error fetching arrivals: \(error)")
                    self?.arrivals = [] // Clear any old data
                    self?.tableView.reloadData() // Reload to show the 'No data' message
                }
            }
        }
    }
    
    func extractTime(_ dateTime: String) -> String {
        let parts = dateTime.split(separator: "T")
        if parts.count > 1 {
            let timeWithSeconds = parts[1]  // Get the time part which includes seconds
            let timeComponents = timeWithSeconds.split(separator: ":")
            if timeComponents.count >= 2 {
                if let hour = Int(timeComponents[0]), let minute = Int(timeComponents[1]) {
                    let isPM = hour >= 12
                    let convertedHour = hour % 12
                    let displayHour = convertedHour == 0 ? 12 : convertedHour  // Handle the midnight and noon case
                    let displayMinute = String(format: "%02d", minute)
                    return "\(displayHour):\(displayMinute) \(isPM ? "PM" : "AM")"
                }
            }
        }
        return "N/A"  // Return N/A if the format is unexpected
    }


    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(arrivals.count, 1) // Ensure there's always at least one cell to display the 'No data' message
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if arrivals.isEmpty {
            cell.textLabel?.text = "No scheduled arrivals or departures."
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .black
        } else {
            let arrival = arrivals[indexPath.row]
            let extractedTime = extractTime(arrival.arrT)
            cell.textLabel?.text = "To \(arrival.destNm): Arrives at \(extractedTime)"
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.textColor = .black
        }
        return cell
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Unable to fetch arrival times.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}
