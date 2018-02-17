#import <Foundation/Foundation.h>
#import "NVCFeedbackViewController.h"
#import "NVCReportCreator.h"
#import <UITextView_Placeholder/UITextView+Placeholder.h>

@implementation NVCFeedbackViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [[self descriptionView] becomeFirstResponder];
}

- (IBAction)cancelAction:(id)sender{
    [self dismissViewControllerAnimated:false completion:nil];
}

- (IBAction)submitAction:(id)sender{
    NVCReportCreator *reportCreator = [NVCReportCreator new];
    reportCreator.description = [self descriptionView].text;
}

@end
