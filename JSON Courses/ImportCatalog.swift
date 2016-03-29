//
//  ImportCatalog.swift
//  Rebel Success
//
//  Created by Caleb Owens on 3/6/16.
//  Copyright © 2016 Caleb Owens. All rights reserved.
//

/* Use Case: Add returned course objects to a Table View

var courseObjects=[[String: NSObject]]()
let myCourse = Courses()
courseObjects=myCourse.getCourses()

override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

    return 1
}

override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    return courseObjects.count
}


override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Course Cell", forIndexPath: indexPath)
    let courseObject = courseObjects[indexPath.row]

    cell.textLabel!.text = String(courseObject["course_name"]!)
    cell.detailTextLabel!.text = String(courseObject["credits"]!)
    return cell
}

Use case: convert the credit value to an Int
var creditNum=Int(courseObject["credits"] as! Int)
creditNum+=1;


*/

import UIKit


class Courses: NSObject {
    
    var courseObjects=[[String: Any]]()
    
    
    /* Add this to the bottom of Info.plist to allow an unsecure connection to the site!!!
        <key>NSAppTransportSecurity</key>
        <dict>
        <key>NSExceptionDomains</key>
        <dict>
        <key>cardboardorplastic.com</key>
        <dict>
        <key>NSIncludesSubdomains</key>
        <true/>
        <key>NSThirdPartyExceptionAllowsInsecureHTTPLoads</key>
        <true/>
        </dict>
        </dict>
        </dict>
    */
    
    func getCourses()->[[String: Any]]{
        let urlString="http://cardboardorplastic.com/cscatalog.json"
        if let url = NSURL(string: urlString) {
            if let data = try? NSData(contentsOfURL: url, options: []) {
                let json = JSON(data: data)
                
                //Checks for successful return of JSON
                if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                    return parseJSON(json)
                }
            }
        }
        return courseObjects
    }
    
    
    //Parse returned JSON into an array of dictionaries using string for its key and object for its value
    func parseJSON(json: JSON)->[[String:Any]]{
        for course in json["classes"].arrayValue{
            let course_id=course["class_id"].stringValue
            let course_name=course["class_name"].stringValue
            let credits=course["credits"].intValue
            let prereqs=course["prerequisites"].arrayValue
            let obj: [String:Any]=["course_id":course_id,"course_name":course_name,"credits":credits,"prereqs":prereqs]
            courseObjects.append(obj)
        }
        
        return courseObjects
        
    }
    
    
    
    
}
