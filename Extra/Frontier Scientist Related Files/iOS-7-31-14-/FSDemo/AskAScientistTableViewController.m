//
//  AskAScientistTableViewController.m
//  FSApp
//
//  Created by alandrews3 on 4/9/14.
//  Copyright (c) 2014 alandrews3. All rights reserved.
//

#import "AskAScientistTableViewController.h"


@interface AskAScientistTableViewController ()

@end

@implementation AskAScientistTableViewController
@synthesize askTextLabel;
@synthesize m_userName, m_userEmail, m_userSubject,m_userQuestion;
@synthesize scientistBio, scientistPicture, scientistName, scientistBioText;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RiR_lined_iphone_V44px"]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTableNotification:)
                                                 name:@"update"
                                               object:nil];
    [self setOutputs];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RiR_lined_iphone_V44px.png"]];
    self.m_userName.delegate = self;
    self.m_userEmail.delegate = self;
    self.m_userSubject.delegate = self;
    self.m_userQuestion.delegate = self;
    
    m_userQuestion.text = @"Your Question";
    m_userQuestion.textColor = [UIColor lightGrayColor];
    
    m_userName.borderStyle = UITextBorderStyleNone;
    m_userEmail.borderStyle = UITextBorderStyleNone;
    m_userSubject.borderStyle = UITextBorderStyleNone;
}

-(void)receiveTableNotification:(NSNotification *)pNotification
{
    NSLog(@"Reload Ask time!");
    [self setOutputs];
    [self.tableView reloadData];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.m_userName resignFirstResponder];
    [self.m_userEmail resignFirstResponder];
    [self.m_userSubject resignFirstResponder];
    [self.m_userQuestion resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField)
       [textField resignFirstResponder];
    
    return NO;
}

- (BOOL) textViewShouldReturn:(UITextField *)textView
{
    if(textView)
        [textView resignFirstResponder];
    
    return NO;
}

- (IBAction)backgroundTouched:(id)sender
{
    [sender resignFirstResponder];
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    if([m_userQuestion.text  isEqualToString:@"Your Question"])
    {
        m_userQuestion.text = @"";
        m_userQuestion.textColor = [UIColor blackColor];
    }
}

- (void) textViewDidEndEditing:(UITextView *) textView
{
    if(m_userQuestion.text.length == 0)
    {
        m_userQuestion.text = @"Your Question";
        m_userQuestion.textColor = [UIColor lightGrayColor];
        [m_userQuestion resignFirstResponder];
    }
}

- (void) textFieldDidEndEditing:(UITextField *) textField
{
    [textField resignFirstResponder];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

    if(cell == nil)
        cell = [[UITableViewCell alloc] init];
    
    cell.backgroundColor = [UIColor clearColor];
 
    if(indexPath.row == 0)
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Large_CellBorder.png"]];
        
    else if(indexPath.row > 0 && indexPath.row < 4)
    {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellBorder.png"]];
    }
    else
    {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Larger_CellBorder.png"]];
    }
    
    return cell;
}

- (void) setOutputs
{
    scientistPicture.image = [UIImage imageWithData:[[[[NSUserDefaults standardUserDefaults] objectForKey:@"researchDict"] objectForKey:@"scientist_on_call"] objectForKey:@"picture"]];
    scientistName = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"researchDict"] objectForKey:@"scientist_on_call"] objectForKey:@"name"];
    scientistBioText = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"researchDict"] objectForKey:@"scientist_on_call"] objectForKey:@"bio"];
    scientistBio.text = [NSString stringWithFormat:@"%@\n%@", scientistName,scientistBioText ];
    scientistBio.font = [UIFont fontWithName:@"Chalkduster" size:17.0];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return 132;
    else if(indexPath.row == 4)
        return 154;
    else
        return 44;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //askTextLabel.text = textLabelString;
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendButtonAction:(UIButton *)sender
{
    if(![MFMailComposeViewController canSendMail])
    {
        [self displayAlert: @"noMailSetUp"];
        return;
    }
    if([self.m_userName.text isEqualToString:@""])
    {
        [self displayAlert: @"fieldsLeftBlank"];
        return;
    }
    if([self.m_userEmail.text isEqualToString:@""])
    {
        [self displayAlert: @"fieldsLeftBlank"];
        return;
    }
    //Email subject
    NSString *emailTitle= self.m_userSubject.text;
    if([emailTitle isEqualToString:@""])
    {
        [self displayAlert: @"fieldsLeftBlank"];
        return;
    }
    //Content
    NSString *emailMessage = self.m_userQuestion.text;
    if([emailMessage isEqualToString:@"Your Question"] || [emailMessage isEqualToString:@""])
    {
        [self displayAlert: @"fieldsLeftBlank"];
        return;
    }
    emailMessage = [NSString stringWithFormat:@"%@\n\n From: %@\nAt: %@", self.m_userQuestion.text, self.m_userName.text, self.m_userEmail.text];
    //Address
    NSArray *toRecipents = [NSArray arrayWithObjects:@"liz@frontierscientists.com", nil];
    if(toRecipents == nil)
        toRecipents = [NSArray arrayWithObjects:@"testEmail", nil];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:emailMessage isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    [self presentViewController:mc animated:YES completion:NULL];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed");
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)displayAlert: (NSString *)errorOrigin
{
    UIAlertView *alert = [[UIAlertView alloc] init];
    
    if([errorOrigin isEqualToString:@"noMailSetUp"])
    {
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your mail is not set up!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    }
    else if([errorOrigin isEqualToString:@"fieldsLeftBlank"])
    {
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Fill out all of your information!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    }
    [alert show];
}


- (IBAction)cancel:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)SebdButtonAction:(id)sender {
}
@end
