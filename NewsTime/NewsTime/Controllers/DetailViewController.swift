import UIKit
import SDWebImage
import CoreData

class DetailViewController: UIViewController {
    
    var savedItems = [Items]()
    var context: NSManagedObjectContext?
    
    var webUrlString = String()
    var titleString = String()
    var contentString = String()
    var newsImage = String()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = titleString
        contentTextView.text = contentString
        newsImageView.sd_setImage(with: URL(string: newsImage), placeholderImage: UIImage(named: "news.png"))
        

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }

    func saveData(){
        do{
            try context?.save()
            basicAlert(title: "Saved!", message: "To see your saved article, go to Saved tab bar.")
        }catch{
            print(error.localizedDescription)
        }
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let newItem = Items(context: self.context!)
        newItem.newsTitle = titleString
        newItem.newsContent = contentString
        newItem.url = webUrlString
        
        if !newsImage.isEmpty{
            newItem.image = newsImage
        }
        
        self.savedItems.append(newItem)
        saveData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC: WebViewController = segue.destination as? WebViewController else {return}
        
        destinationVC.urlString = webUrlString
    }
    
    
}
