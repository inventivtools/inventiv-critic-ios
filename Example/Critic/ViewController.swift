import Critic
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Actions
    @IBAction func sendFeedbackButton() {
        
        let reportCreator = NVCReportCreator()
        reportCreator.description = "Testing from iOS."
        
        reportCreator.create({(success: Bool, error: Error?) in
            if success {
                NSLog("Feedback has been submitted!")
            }
            else {
                NSLog("Feedback submission failed.")
            }
        })
    }
}
