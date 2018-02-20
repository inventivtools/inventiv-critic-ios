#import "Critic.h"
#import <Foundation/Foundation.h>
#import "NVCFeedbackViewController.h"
#import "NVCReportCreator.h"
#import <UITextView_Placeholder/UITextView+Placeholder.h>

@implementation NVCFeedbackViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [[self titleView] setTitle:[[Critic instance] defaultFeedbackScreenTitle]];
    [[self descriptionView] setPlaceholder:[[Critic instance] defaultFeedbackScreenDescriptionPlaceholder]];
    [[self descriptionView] becomeFirstResponder];
}

- (IBAction)cancelAction:(id)sender{
    [self dismissViewControllerAnimated:false completion:nil];
}

- (IBAction)submitAction:(id)sender{
    NVCReportCreator *reportCreator = [NVCReportCreator new];
    reportCreator.description = [self descriptionView].text;
    
    if(!reportCreator.description || [reportCreator.description length] == 0){
        [self descriptionView].layer.borderColor = [UIColor redColor].CGColor;
        [self descriptionView].layer.borderWidth = 1;
        [self descriptionView].placeholder = [NSString stringWithFormat:@"Please enter some text to continue.\n\n%@", [self descriptionView].placeholder];
        return;
    }
    
    dispatch_queue_t queue = dispatch_queue_create("io.inventiv.critic.report.create", NULL);
    dispatch_async(queue, ^{
        [reportCreator create:^(BOOL success, NSError *error){
            if(success){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"Thank You!" message: @"Feedback received." preferredStyle: UIAlertControllerStyleActionSheet];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                    [self dismissViewControllerAnimated:false completion:nil];
                }]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:alert animated:true completion:nil];
                });
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"Uh Oh!" message: @"We encountered a problem submitted your feedback. Please try again." preferredStyle: UIAlertControllerStyleActionSheet];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                    // do nothing.
                }]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:alert animated:true completion:nil];
                });
            }
        }];
    });
}

@end
