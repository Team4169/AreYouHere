//
//  EditTeamTableViewController.swift
//  AreYouHere
//
//  Created by block7 on 5/12/16.
//  Copyright © 2016 Jack Doherty. All rights reserved.
//

import UIKit

class EditTeamTableViewController: UITableViewController {
    var teamNum: Int!
    var program: String!
    
    var teamMemberNames: [String] = [String]()
    var teamMemberEIDs: [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(EditTeamTableViewController.hitAdd))
        
        let button = UIBarButtonItem(title: "Home", style: .Plain, target: self, action: #selector(EditTeamTableViewController.popToRoot(_:)))
        self.navigationItem.leftBarButtonItem = button
    }
    
    override func viewWillAppear(animated: Bool) {
        rootRef.child("teams/\(program)/\(teamNum)").observeEventType(.Value, withBlock: { snapshot in
            let teamMembers = snapshot.value!["teamMembers"] as! [String : String]
            var returnArray: [String] = [String]()
            for (name, _) in teamMembers {
                returnArray.append(name)
            }
            returnArray.sortInPlace()
            self.teamMemberNames = returnArray
            self.tableView.reloadData()
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        rootRef.child("teams/\(program)/\(teamNum)").removeAllObservers()
    }
    
    func popToRoot(sender:UIBarButtonItem){
        self.navigationController!.popToRootViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hitAdd() {
        //code
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamMemberNames.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath)
        cell.textLabel?.text = teamMemberNames[indexPath.row]
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            teamMemberNames.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("editTeamToTeamMember", sender: nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editTeamToTeamMember" {
            let DVC = segue.destinationViewController as! TeamMemberViewController
            //send over name and email decrypted and eventually a pro pic
        }
    }

}
