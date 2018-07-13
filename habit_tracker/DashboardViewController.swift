//
//  ViewController.swift
//  habit_tracker
//
//  Created by Torsten Schmickler on 23/06/2018.
//  Copyright © 2018 Torsten Schmickler. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    let userDefaults = UserDefaults.standard
    let sevenDaysInSeconds: TimeInterval = 604800
    var habitData: [String:[Date]] = [:]
    
    @IBOutlet var habitButtons: [UIButton]!
    @IBOutlet var habitCounterLabels: [UILabel]!
    @IBOutlet var daysScinceLabels: [UILabel]!
    
    
    
    // Mehtods
    @IBAction func touchHabit(_ sender: UIButton) {
        let habitIndex = habitButtons.index(of: sender)!
        let habitKey = String(habitIndex)
        if habitData[habitKey] != nil {
            habitData[habitKey]!.append(Date())
        } else {
            habitData[habitKey] = [Date()]
        }
        userDefaults.set(habitData, forKey: "habitData")
        print(userDefaults.dictionary(forKey: "habitData")!)
        habitCounterLabels[habitIndex].text = String(countTimesLastSevenDays(habitData[habitKey]!))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCounters()
    }
    
    func loadCounters() {
        if let storedData = (userDefaults.dictionary(forKey: "habitData") as! Dictionary<String, [Date]>?) {
            var index = 0
            var count = 0
            habitData = storedData
            habitCounterLabels.forEach { habitLabel in
                if let dates = storedData[String(index)] {
                    count = countTimesLastSevenDays(dates)
                    habitLabel.text = String(count)
                    daysScinceLabels[index].text = calculateDaysScince(dates.last!)
                }
                index += 1
            }
        }
    }
    
    func calculateDaysScince(_ date: Date) -> String {
        let differenceInDays = (Date().timeIntervalSinceReferenceDate - date.timeIntervalSinceReferenceDate) / 86400
        return String(format: "%.0f", differenceInDays.rounded(.down))
    }
    
    func countTimesLastSevenDays(_ arrayOfDates: Array<Date>) -> Int{
        let sevenDaysAgo = Date().addingTimeInterval(-sevenDaysInSeconds)
        var times = 0
        arrayOfDates.forEach { date in
            if date > sevenDaysAgo {
                times += 1
            }
        }
        return times
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

