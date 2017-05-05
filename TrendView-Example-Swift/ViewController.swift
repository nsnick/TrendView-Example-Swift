//
//  ViewController.swift
//  TrendView-Example-Swift
//
//  Created by Nick Wilkerson on 5/4/17.
//  Copyright © 2017 Nick Wilkerson. All rights reserved.
//

import UIKit
import TrendView

class ViewController: UIViewController, TVTrendViewDatasource {

    let dataArray1 = [0,1,3,5,6,8,7,6,5,4,2,2,0]
    let dataArray2 = [9,8,6,5,4,3,2,2,4,6,8,9,9]
    
    let series1: NSMutableArray
    let series2: NSMutableArray
    let allSeries: NSMutableArray
    
    var trendView: TVTrendView?
    

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        series1 = NSMutableArray()
        series2 = NSMutableArray()
        
        for i:NSInteger in 0 ..< dataArray1.count {
            let point1:TVPoint = TVPoint.init(x: Double(i), andY:Double(dataArray1[i]))
            series1.add(point1)
            let point2:TVPoint = TVPoint.init(x: Double(i), andY:Double(dataArray2[i]))
            series2.add(point2)
        }
        allSeries = [series1, series2]
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let trendViewFrame: CGRect = CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: self.view.frame.size.width*2/3)
        trendView = TVTrendView.init(frame: trendViewFrame, style: TVTrendViewStyleDefault)
        trendView!.titleText = "Trend Title"
        trendView!.xAxisLabelText = "X Axis Label"
        trendView!.yAxisLabelText = "Y Axis Label"
        trendView!.xUnits = "X Units"
        trendView!.yUnits = "Y Units"
        trendView!.datasource = self
    
        view.addSubview(trendView!)
    }
    
    func numberOfSeries(in trendView:TVTrendView) -> UInt {
        return 2;
    }
    
    func trendView(_ trendView:TVTrendView, numberOfElementsInSeries series:CLong) -> UInt {
        var smallestNumber:UInt = .max
        for series in allSeries {
            if (UInt((series as! NSArray).count) < smallestNumber) {
                smallestNumber = UInt((series as! NSArray).count);
            }
        }
        return smallestNumber;
    }
    
    func trendView(_ trendView:TVTrendView, pointInSeries seriesIndex:Int, for index:CLong) -> TVPointProtocol {
        let series:NSArray = allSeries[seriesIndex] as! NSArray
        let point:TVPoint = series[index] as! TVPoint;
        return point;
    }
    
    /*
     *  You must tell the trendview what range of values to display
     */
    func dataRanges(for trendView:TVTrendView)  -> TVDataRanges{
        let point:TVPoint = (allSeries[0] as! NSArray).object(at: 0) as! TVPoint;
    
        var minX = point.x
        var minY = point.y
        var maxX = point.x
        var maxY = point.y
    
        for series in allSeries {
            if let series:NSArray = series as? NSArray {
                for point in (series as! NSMutableArray) {
                    if let point:TVPoint = point as? TVPoint {
                        if (point.x < minX) {
                            minX = point.x
                        }
                        if (point.y < minY) {
                            minY = point.y
                        }
                        if (point.x > maxX) {
                            maxX = point.x
                        }
                        if (point.y > maxY) {
                            maxY = point.y
                        }
                    }
                }
            }
        }
    
        let ranges:TVDataRanges = trendView.dataRange(withMinX: minX, minY: minY, maxX: maxX, maxY: maxY)
    
        return ranges
    }
    
    func trendView( _: TVTrendView, colorForSeries series:CLong) -> UIColor {
        if (series == 0) {
            return UIColor.red
    } else if (series == 1) {
            return UIColor.blue
    }
        return UIColor.yellow
    }


}

