#import <Foundation/Foundation.h>
#import <UITextView_Placeholder/UITextView+Placeholder.h>

@interface NVCFeedbackViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextView *descriptionView;

- (IBAction)cancelAction:(id)sender;
- (IBAction)submitAction:(id)sender;

@end
