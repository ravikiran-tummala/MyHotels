//
//  HotelsTableViewController.swift
//  MyHotels
//
//  Created by Ravi Kiran Tummala on 19/02/21.
//

import UIKit

protocol HotelInfoUpdate:AnyObject {
    func onHotelAddition(hotel:HotelModel)
    func onHotelInfoUpdate(hotel:HotelModel)
}

struct HotelModel{
    
    var name: String = ""
    var rating: String = ""
    var address: String = ""
    var dateOfStay: Date = Date()
    var roomRate: Float = 0.0
    var photo:UIImage = UIImage(named: "PlaceIcon")!

}




class HotelTableViewCell: UITableViewCell{
    @IBOutlet weak var hotelImageView: UIImageView!
    @IBOutlet weak var hotelTitleLabel: UILabel!
    @IBOutlet weak var ratingTitleLabel: UILabel!
}

class HotelsTableViewController: UITableViewController,HotelInfoUpdate {
    let segueTitle = "AddEditSegue"
    let hotelCellIdentifier = "HotelCell"
    func onHotelAddition(hotel: HotelModel) {
        hotels.append(hotel)
    }
    
    func onHotelInfoUpdate(hotel: HotelModel) {
        hotels[selectedHotelIndex] = hotel
    }
    
    
    var selectedHotelIndex = -1
    var hotels = [HotelModel]()
    @IBAction func onSelect(_ sender: Any) {
        isEditing = !isEditing
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return hotels.count
    }

    @IBAction func onAdd(_ sender: Any) {
        selectedHotelIndex = -1
        performSegue(withIdentifier: segueTitle, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           print("Deleted")
           hotels.remove(at: indexPath.row)
           self.tableView.beginUpdates()
           self.tableView.deleteRows(at: [indexPath], with: .automatic)
           self.tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: hotelCellIdentifier, for: indexPath) as! HotelTableViewCell
        let hotel = hotels[indexPath.row]

        cell.hotelTitleLabel.text = hotel.name
        cell.ratingTitleLabel.text = hotel.rating
        cell.hotelImageView.image = hotel.photo

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedHotelIndex = indexPath.row
        performSegue(withIdentifier: segueTitle, sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let editViewController = segue.destination as! EditViewController
        if segue.identifier == segueTitle && selectedHotelIndex > -1{
            editViewController.hotel = hotels[selectedHotelIndex]
        }
        editViewController.delegate = self
    }
    

}
