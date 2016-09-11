//
//  EditTeamTableViewController.swift
//  AreYouHere
//
//  Created by block7 on 5/12/16.
//  Copyright © 2016 Jack Doherty. All rights reserved.
//
//remove teams from editableTeams in users profile when deleted or when their admin status is removed

import UIKit
import Firebase
import FirebaseDatabase

class EditTeamTableViewController: UITableViewController {
    var teamNum: Int!
    var program: String!
    var teamRef: FIRDatabaseReference!
    
    var teamMemberNames: [String] = [String]()
    var teamMemberEIDs: [String] = [String]()
    var teamAdmins: [String:String] = [String:String]()
    
    var detailMemberName: String!
    var detailMemberEID: String!

    override func viewDidLoad() {
        print("Edit VC Load")
        super.viewDidLoad()
        teamRef = rootRef.child("teams/\(program)/\(teamNum)")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(EditTeamTableViewController.hitAdd))
        
        let button = UIBarButtonItem(title: "Home", style: .Plain, target: self, action: #selector(EditTeamTableViewController.popToRoot(_:)))
        self.navigationItem.leftBarButtonItem = button
    }
    
    override func viewWillAppear(animated: Bool) {
        teamRef.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot)
            let admins = snapshot.value!["admins"] as! [String:String]
            print(admins)
            self.teamAdmins = admins
            
            let teamMembers = snapshot.value!["teamMembers"] as! [String : String]
            var teamMembersSwitched: [String : String] = [String : String]()
            for (eid, name) in teamMembers {
                teamMembersSwitched[name] = eid
            }
            print(teamMembersSwitched)
            
            var namesArray: [String] = [String]()
            var eidArray: [String] = [String]()
            for (name, _) in teamMembersSwitched {
                namesArray.append(name)
            }
            namesArray.sortInPlace()
            for names in namesArray {
                eidArray.append(teamMembers[names]!)
            }
            self.teamMemberNames = namesArray
            self.teamMemberEIDs = eidArray
            
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
        cell.detailTextLabel?.text = String(teamMemberEIDs[indexPath.row]).base64Decoded()
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
            if let _ = teamAdmins[teamMemberNames[indexPath.row]] {
                let alert = UIAlertController(title: "Delete Error", message: "You cannot delete a team admin. Please revoke team member's admin status before deletion.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                print(teamMemberNames[indexPath.row])
                teamRef.child("teamMembers/\(teamMemberNames[indexPath.row])").removeValue()
                teamMemberNames.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
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
        rootRef.child("users/\(self.teamMemberEIDs[indexPath.row]))").observeSingleEventOfType(.Value, withBlock: { snapshot in
            self.performSegueWithIdentifier("editTeamToTeamMember", sender: nil)
        })
//        self.teamMemberName.text = teamMemberNames[indexPath.row]
//        self.teamMemberEmail.text = String(teamMemberEIDs[indexPath.row]).base64Decoded
//        self.popUpDetailView.hidden = false
    }
    
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editTeamToTeamMember" {
            let DVC = segue.destinationViewController as! TeamMemberViewController
            //send over name and email decrypted and eventually a pro pic
//            let data = NSData(contentsOfURL: AppState.sharedInstance.photoURL)
//            DVC.imageView.image = UIImage(data: data!)
//            DVC.emailLabel.text = AppState.sharedInstance.eid.base64Decoded()
//            DVC.nameLabel.text = AppState.sharedInstance.name
        }
    }

}
