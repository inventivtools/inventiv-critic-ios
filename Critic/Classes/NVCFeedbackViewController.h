#import <Foundation/Foundation.h>
#import <UITextView_Placeholder/UITextView+Placeholder.h>

@interface NVCFeedbackViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextView *descriptionView;
@property (nonatomic, weak) IBOutlet UINavigationItem *titleView;

- (IBAction)cancelAction:(id)sender;
- (IBAction)submitAction:(id)sender;

@end
