//
//  ContactsViewController.m
//  EuLux
//
//  Created by Varghese Simon on 3/12/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "ContactsViewController.h"
#import "Contact.h"
#import "ContactDetailsViewController.h"


@interface ContactsViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ContactsViewController
{
    NSMutableArray *contactsListArray;
}

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
	// Do any additional setup after loading the view.
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( rightRevealToggle: )];

    contactsListArray = [[NSMutableArray alloc] init];
    
    NSString *JSONStringParameter = @"{\"request\":{\"Country\":\"\",\"Name\":\"\",\"Type\":\"Contact\"}}";
    NSString *URLStringForPost = @"http://ripple-io.in/GetContacts";
    
    Postman *postMan = [[Postman alloc] init];
    postMan.delegate = self;
    [postMan post:URLStringForPost withParameters:JSONStringParameter];
}

- (void)postman:(Postman *)postman gotFailure:(NSError *)error
{
    NSLog(@"Failure");
}

-(void)postman:(Postman *)postman gotSuccess:(NSData *)response
{
    
    [self parseResponseData:response];
    NSLog(@"Success");
}

- (void)parseResponseData:(NSData *)response
{
    NSDictionary *dictFromJSON = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
    
    NSArray *contactsArrayFromJSON = dictFromJSON[@"aaData"][@"Users"];
    
    for (NSDictionary *contactFromArray in contactsArrayFromJSON)
    {
        Contact *aContact = [[Contact alloc] init];
        
        aContact.userID = [contactFromArray[@"Id"] integerValue];
        aContact.name = contactFromArray[@"Name"];
        [contactsListArray addObject:aContact];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [contactsListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    Contact *aContact = contactsListArray[indexPath.row];
    
    UILabel *label = (UILabel *)[cell viewWithTag:10];
    label.text = aContact.name;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ContactDetailSegue"])
    {
        ContactDetailsViewController *contDetails = (ContactDetailsViewController *)segue.destinationViewController;
        
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        Contact *selectedContact = contactsListArray[selectedIndexPath.row];
        contDetails.userID = selectedContact.userID;
    }
}

@end
