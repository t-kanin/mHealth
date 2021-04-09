//
//  MonsterGraphViewController.swift
//  mHealthGame
//
//  Created by kanin tansirisittikul on 26/2/2564 BE.
//

import UIKit
import Charts

class GraphViewController: UIViewController, ChartViewDelegate{
    
    //@IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var xAxis: UILabel!
    
    var lineChart = LineChartView()
    var chartLabel: String?
    
    let picker_arr = ["Weekly","Montly"]
    
    let weekday = ["Sat","Sun","Mon","Tue","Wed","Thr","Fri"]
    
    let days = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"]
    
    var progress_str = ""
    
    override func viewDidLoad() {
        //setupTitleLabel()
        lineChart.delegate = self
        xAxis.text = "Day"
        setupChart()
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    
    func setupChart(){
        lineChart.frame = CGRect(x: 0, y: 150, width: self.view.frame.width, height: self.view.frame.height * 0.65)
        lineChart.setScaleEnabled(false)
        lineChart.rightAxis.enabled = false
        lineChart.leftAxis.axisMinimum = 0
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.leftAxis.drawGridLinesEnabled = false

        lineChart.legend.horizontalAlignment = .right
        lineChart.legend.verticalAlignment = .top
        lineChart.legend.drawInside = true
        
        lineChart.noDataText = "no data"
        setData7days()
        //lineChart.zoom(scaleX: 1.5, scaleY: 1, x: 0 , y: 0)
        view.addSubview(lineChart)
    }
    
    func setData7days(){
        var entries = [ChartDataEntry]()
        var count = [Int].init(repeating: 0, count: 7)
        DatabaseManager.shared.getProgressData(progress_str: progress_str, numOfDays: 7) { [self] (datas) in
            for day in 0..<7 {
                if(day > datas.count - 1){count.insert(0, at: 0)}
                else{
                    let checkDay = self.checkTimeStamp(interval: TimeInterval(datas[day].timestamp/1000))
                    let index = 6 - checkDay
                    if(index < 0){ count[0] = 0}
                    else{count[index] = datas[day].count}
                }
            }
            for x in 0..<7{
                entries.append(ChartDataEntry(x: Double(x), y: Double(count[x])))
            }
            let set = LineChartDataSet(entries: entries, label: chartLabel)
            setChartDataSet(set: set)
            let data =  LineChartData(dataSet: set)
            data.setDrawValues(false)
            self.lineChart.data = data
            formatXaxis(xAxis: lineChart.xAxis, sevenDays: true)
        }
    }
    
    func setData30days(){
        var entries = [ChartDataEntry]()
        var count = [Int].init(repeating: 0, count: 30)
        
        DatabaseManager.shared.getProgressData(progress_str: progress_str, numOfDays: 30) { (datas) in
            for day in 0..<30 {
                if(day > datas.count - 1){count.insert(0, at: 0)}
                else{
                    let checkDay = self.checkTimeStamp(interval: TimeInterval(datas[day].timestamp/1000))
                    let index = 6 - checkDay
                    if(index < 0){ count[0] = 0}
                    else{count[index] = datas[day].count}
                }
            }
            for x in 0..<30{
                entries.append(ChartDataEntry(x: Double(x), y: Double(count[x])))
            }
            let set = LineChartDataSet(entries: entries, label: self.chartLabel)
            self.setChartDataSet(set: set)
            let data =  LineChartData(dataSet: set)
            data.setDrawValues(false)
            
            self.lineChart.data = data
            self.formatXaxis(xAxis: self.lineChart.xAxis, sevenDays: false)
        }
    }
    
    func setChartDataSet(set: LineChartDataSet){
        set.drawCirclesEnabled = false
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        set.valueFormatter = DefaultValueFormatter(formatter:formatter)
        set.mode = .cubicBezier
        set.lineWidth = 2
        set.setColor(.red)
    }
    
    
    func formatXaxis(xAxis: XAxis, sevenDays: Bool){
        if(sevenDays){
            let weekday = sortWeekDay()
            xAxis.valueFormatter = IndexAxisValueFormatter(values: weekday)}
        else{xAxis.valueFormatter = IndexAxisValueFormatter(values: days)}
        
    }
    
    func sortWeekDay() -> [String]{
        var sort_weekday: [String] = []
        var weekday_int = Calendar.current.component(.weekday, from: Date())
        for _ in 0..<7 {
            sort_weekday.insert(weekday[weekday_int], at: 0)
            weekday_int -= 1
            if(weekday_int < 0) {weekday_int = 6}
        }
        
        return sort_weekday
    }
    
    func sortDay() -> [String]{
        var sort_day: [String] = []
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date)
        var day = components.day!
        for _ in 0..<30{
            sort_day.insert(days[day], at: 0)
            day -= 1
            if(day < 0){day = 30}
            
        }
        return sort_day
    }
    
    func checkTimeStamp(interval : TimeInterval) -> Int{
        
        let calendar = Calendar.current
        let date = Date(timeIntervalSince1970: interval)
        if calendar.isDateInYesterday(date) { return 1  }
        else if calendar.isDateInToday(date) { return 0 }
        else if calendar.isDateInTomorrow(date) { return 1 }
        else {
            let startOfNow = calendar.startOfDay(for: Date())
            let startOfTimeStamp = calendar.startOfDay(for: date)
            let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
            let day = components.day!
            if day < 1 { return -day }
            else { return day }
        }
    }
    
        
    @IBAction func didChangeSegment(_ sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0 {
            setData7days()
        }
        else if sender.selectedSegmentIndex == 1 {
            setData30days()
        }
    }
}


