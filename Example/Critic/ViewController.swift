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
        Critic.shared().setProductAccessToken("NXJMM2CHo5afj9YpauvB1QLk")
        let report = CriticReportData(description: "Testing from iOS.")
        
        Critic.shared().createReport(report, completion:{(success: Bool, error: Error?) in
            // do nothing for now.
        })
    }
}

