import UIKit
import CoreData
import SDWebImage

class SavedTableViewController: UITableViewController {
    var savedItems = [Items]()
    var context: NSManagedObjectContext?
    
    @IBOutlet weak var editButtonOutlet: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        loadData()
        countItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
        countItems()
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
        if tableView.isEditing{
            editButtonOutlet.title = "Save"
        }else{
            editButtonOutlet.title = "Edit"
        }
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        basicAlert(title: "Saved News Info!", message: "In this section you will find your saved articles. If you decide to delete some articles, you can do it by using \"Edit\" button and click on delete symbol, or alternative way is to pointer on related article and swipe from right side the left, then press \"delete\"!")
    }
    
    
    func saveData(){
        do{
            try context?.save()
            basicAlert(title: "Deleted!", message: "Oops you just erased from CoreData your article.")
        }catch{
            print(error.localizedDescription)
        }
        loadData()
    }
    
    func loadData(){
        let request: NSFetchRequest<Items> = Items.fetchRequest()
        do {
            savedItems = try (context?.fetch(request))!
            tableView.reloadData()
        }catch{
            fatalError("Error in retrieving Saved Items")
        }
        tableView.reloadData()
    }
    
    func countItems() {
        let itemsInTable = String(self.tableView.numberOfRows(inSection: 0))
        self.title = "Saved(\(itemsInTable))"
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "savedFeedCell", for: indexPath) as? NewsTableViewCell else{
            return UITableViewCell()
        }

        let item = savedItems[indexPath.row]
        cell.newsTitleLabel.text = item.newsTitle
        cell.newsTitleLabel.numberOfLines = 0
        cell.newsImageView.sd_setImage(with: URL(string: item.image ?? ""), placeholderImage: UIImage(named: "news.png"))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {_ in
                let item = self.savedItems[indexPath.row]
                self.context?.delete(item)
                self.saveData()
            }))
            self.present(alert, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let row = savedItems.remove(at: fromIndexPath.row)
        savedItems.insert(row, at: to.row)
    }
   
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }

    
    // MARK: - Navigation
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
         guard let vc = storyboard.instantiateViewController(identifier: "WebViewController") as? WebViewController else {
             return
         }
         self.title = "Saved"

         vc.urlString = savedItems[indexPath.row].url ?? "https://blog.thomasnet.com/hs-fs/hubfs/shutterstock_774749455.jpg?width=1200&name=shutterstock_774749455.jpg"
         navigationController?.pushViewController(vc, animated: true)
     }

}
