//
//  BrowseTableViewController.swift
//  jeanmichel
//
//  Created by Samuel Beek on 19/05/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import UIKit

class StationTableViewController : UITableViewController {
    
    var stations = [Station]()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = Styles.Colors.stationHeaderBackgroundColor
        navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: Styles.Fonts.headerFont, NSForegroundColorAttributeName: Styles.Colors.stationHeaderTextColor]
        
        AudioPlayer.instance.pause()
        AudioPlayer.instance.stopRemote()
    }
    
    override func viewDidLoad() {
        self.title = "On the Air"

        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(ChannelTableViewCell.self, forCellReuseIdentifier: Constants.defaultCellIdentifier)
        tableView.reloadData()
        tableView.delegate = self
        
        
        // bind data
        API.getStations() { [weak self] result in
            
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .value(let stations):
                strongSelf.stations = stations
                strongSelf.tableView.reloadData()
            case .error(let error):
                print(error.debugDescription)
            }
            
        }
}
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let station = stations[safe: (indexPath as NSIndexPath).row] else {
             return
        }
        self.navigationController?.pushViewController(PlayerViewController(station: station), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Styles.stationCellHeight
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: TableViewDelegate
extension StationTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.defaultCellIdentifier) as? ChannelTableViewCell {
            cell.textLabel?.text = stations[indexPath.row].title.lowercased()
            return cell
        }
        return UITableViewCell()
    }
    

}


extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
