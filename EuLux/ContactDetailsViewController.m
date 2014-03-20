//
//  ContactDetailsViewController.m
//  EuLux
//
//  Created by Varghese Simon on 3/19/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "ContactDetailsViewController.h"
#import "Contact.h"

@interface ContactDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *faxLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@end

@implementation ContactDetailsViewController
{
    Contact *aContact;
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
    
    self.navigationController.navigationBarHidden = NO;
    
    NSString *URLString = @"http://ripple-io.in/Contact/";
    URLString = [NSString stringWithFormat:@"%@%i",URLString, self.userID];
    
    Postman *postMan = [[Postman alloc] init];
    postMan.delegate = self;
    [postMan get:URLString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)postman:(Postman *)postman gotFailure:(NSError *)error
{
    NSLog(@"Error : %@",[error userInfo]);
}

- (void)postman:(Postman *)postman gotSuccess:(NSData *)response
{
    [self parseResponseData:response];
}

- (void)parseResponseData:(NSData *)response
{
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
    NSDictionary *customerDict = responseDict[@"aaData"][@"User"];
    
    aContact = [[Contact alloc] init];
    aContact.userID = [customerDict[@"Id"] integerValue];
    aContact.name = [NSString stringWithFormat:@"%@ %@ %@",customerDict[@"FirstName"], customerDict[@"MiddleName"], customerDict[@"LastName"]];
    aContact.code = customerDict[@"Code"];
    aContact.website = customerDict[@"Website"];
    aContact.categoryCode = customerDict[@"CategoryCode"];
    
    NSString *contactsInJSON = customerDict[@"Contact"];
    NSDictionary *contactFromJSON = [NSJSONSerialization JSONObjectWithData:[contactsInJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    NSArray *contactsArray = contactFromJSON[@"contact"];
    if ([contactsArray count] > 0)
    {
        NSDictionary *contact = contactsArray[0];
        aContact.email = contact[@"Email"];
        aContact.phone = contact[@"Phone"];
        aContact.moblie = contact[@"Mobile"];
        aContact.fax = contact[@"Fax"];
    }
    
    NSString *addressInJSON = customerDict[@"Address"];
    NSDictionary *addressFromJSON = [NSJSONSerialization JSONObjectWithData:[addressInJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    NSArray *addressArray = addressFromJSON[@"address"];
    if ([addressArray count] > 0)
    {
        NSDictionary *address = addressArray[0];
        aContact.address = [NSString stringWithFormat:@"%@, %@, %@, %@ %@, %@",address[@"StreetLine1"], address[@"StreetLine2"], address[@"City"], address[@"State"], address[@"PostalCode"], address[@"Country"]];
    }
    [self updateUI];
}

- (void)updateUI
{
    self.nameLabel.text = aContact.name;
    [self.nameLabel sizeToFit];
    self.emailLabel.text = aContact.email;
    self.phoneLabel.text = aContact.phone;
    self.mobileLabel.text = aContact.moblie;
    self.faxLabel.text = aContact.fax;
    
    self.addressLabel.text = aContact.address;
    [self.addressLabel sizeToFit];
    //    [self assignSizeToLabel:self.addressLabel withText:aContact.address andSize:(CGSizeMake(200, 100))];
    //    self.addressLabel.text = aCustomer.address;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
