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
    
    var teamMemberNames: Array<String> = []
    var teamMemberEIDs: Array<String> = []
    var teamAdmins: Dictionary<String, String> = [:]
    
    var detailMemberName: String!
    var detailMemberEID: String!

    override func viewDidLoad() {
        print("Edit VC Load")
        super.viewDidLoad()
        teamRef = rootRef.child("teams/\(program)/\(teamNum)")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(EditTeamTableViewController.hitAdd))
        
        let button = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(EditTeamTableViewController.popToRoot(_:)))
        self.navigationItem.leftBarButtonItem = button
    }
    
    override func viewWillAppear(_ animated: Bool) {
        teamRef.observe(.value, with: { (snapshot: FIRDataSnapshot) in
            print(snapshot)
            let admins = (snapshot.value! as! NSDictionary)["admins"] as! [String:String]
            print(admins)
            self.teamAdmins = admins
            
            let teamMembers = (snapshot.value! as! NSDictionary)["teamMembers"] as! [String : String]
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
            namesArray.sort()
            for names in namesArray {
                eidArray.append(teamMembers[names]!)
            }
            self.teamMemberNames = namesArray
            self.teamMemberEIDs = eidArray
            
            self.tableView.reloadData()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        rootRef.child("teams/\(program)/\(teamNum)").removeAllObservers()
    }
    
    func popToRoot(_ sender:UIBarButtonItem){
        self.navigationController!.popToRootViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hitAdd() {
        //code
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamMemberNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        cell.textLabel?.text = teamMemberNames[(indexPath as NSIndexPath).row]
        cell.detailTextLabel?.text = String(teamMemberEIDs[(indexPath as NSIndexPath).row]).base64Decoded()
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let _ = teamAdmins[teamMemberNames[(indexPath as NSIndexPath).row]] {
                let alert = UIAlertController(title: "Delete Error", message: "You cannot delete a team admin. Please revoke team member's admin status before deletion.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                print(teamMemberNames[(indexPath as NSIndexPath).row])
                teamRef.child("teamMembers/\(teamMemberNames[indexPath.row])").removeValue()
                teamMemberNames.remove(at: (indexPath as NSIndexPath).row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        } else if editingStyle == .insert {
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rootRef.child("users/\(self.teamMemberEIDs[indexPath.row]))").observeSingleEvent(of: .value, with: { snapshot in
            self.performSegue(withIdentifier: "editTeamToTeamMember", sender: nil)
        })
//        self.teamMemberName.text = teamMemberNames[indexPath.row]
//        self.teamMemberEmail.text = String(teamMemberEIDs[indexPath.row]).base64Decoded
//        self.popUpDetailView.hidden = false
    }
    
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTeamToTeamMember" {
            let DVC = segue.destination as! TeamMemberViewController
            //send over name and email decrypted and eventually a pro pic
//            let data = NSData(contentsOfURL: AppState.sharedInstance.photoURL)
//            DVC.imageView.image = UIImage(data: data!)
//            DVC.emailLabel.text = AppState.sharedInstance.eid.base64Decoded()
//            DVC.nameLabel.text = AppState.sharedInstance.name
        }
    }

}
