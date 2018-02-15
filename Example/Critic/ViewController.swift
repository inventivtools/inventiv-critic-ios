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
        let report = CriticReportData(description: "Testing from iOS.")
        Critic.instance().createReport(report, completion:{(success: Bool, error: Error?) in
            if success {
                print("Feedback has been submitted!")
            }
            else {
                print("Something went wrong.");
            }
        })
    }
}
