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
        
//        let podBundle = Bundle(for: Critic.self)
//        let bundleURL = podBundle.url(forResource:"Critic", withExtension: "bundle")
//        let bundle = Bundle(url: bundleURL!)!
//        let storyboard = UIStoryboard(name: "FeedbackScreen", bundle: bundle)
//        let vc = storyboard.instantiateViewController(withIdentifier: "FeedbackScreen")
//        present(vc, animated: true, completion: nil)
        Critic.instance().showDefaultFeedbackScreen(self);
        
        
//        let reportCreator = NVCReportCreator()
//        reportCreator.description = "Testing from iOS."
//
//        reportCreator.create({(success: Bool, error: Error?) in
//            if success {
//                NSLog("Feedback has been submitted!")
//            }
//            else {
//                NSLog("Feedback submission failed.")
//            }
//        })
    }
}
