//
//  ButtonViewController.m
//  ContactSync
//
//  Created by Jack Dubie on 8/5/13.
//  Copyright (c) 2013 Jack Dubie. All rights reserved.
//

#import "ButtonViewController.h"
#import <Dropbox/Dropbox.h>

@implementation ButtonViewController

/*
 * We want to Link the user's account when they click the button
 */

- (IBAction)didPressLink
{
    NSLog(@"\"Link to Dropbox\" button pressed");
    
    /*
     * Link user's account
     */
    
    [[DBAccountManager sharedManager] linkFromController:self];
}

/*
 * Initialization, adding the button, and writing test output to screen
 */

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(didPressLink)
     forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Link to Dropbox" forState:UIControlStateNormal];
    button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [self.view addSubview:button];
}

- (void)addTextView
{
    [[self.view subviews]
        makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    textView.text = @"\n";
    textView.editable = NO;
    [self.view addSubview:textView];
}


- (void)set:(NSString *)toWrite
{
    UITextView *textView = [self.view.subviews objectAtIndex:0];
    
    if (textView && [[textView class] isSubclassOfClass:[UITextView class]]) {
        textView.text = toWrite;
    }
}


- (void)append:(NSString *)toWrite
{
    UITextView *textView = [self.view.subviews objectAtIndex:0];
    [self set:[NSString stringWithFormat:@"%@%@", textView.text, toWrite]];
}

@end
