//
//  CustomerDetailsViewController.m
//  EuLux
//
//  Created by Varghese Simon on 3/17/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "CustomerDetailsViewController.h"
#import "Customer.h"

@interface CustomerDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *faxLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation CustomerDetailsViewController
{
    Customer *aCustomer;
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
    
    NSString *URLString = @"http://ripple-io.in/Customer/";
    URLString = [NSString stringWithFormat:@"%@%i",URLString, self.userID];
    
    Postman *postMan = [[Postman alloc] init];
    postMan.delegate = self;
    [postMan get:URLString];
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
    
    aCustomer = [[Customer alloc] init];
    aCustomer.userID = [customerDict[@"Id"] integerValue];
    aCustomer.name = [NSString stringWithFormat:@"%@ %@ %@",customerDict[@"FirstName"], customerDict[@"MiddleName"], customerDict[@"LastName"]];
    aCustomer.code = customerDict[@"Code"];
    aCustomer.website = customerDict[@"Website"];
    aCustomer.categoryCode = customerDict[@"CategoryCode"];
    
    NSString *contactsInJSON = customerDict[@"Contact"];
    NSDictionary *contactFromJSON = [NSJSONSerialization JSONObjectWithData:[contactsInJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    NSArray *contactsArray = contactFromJSON[@"contact"];
    if ([contactsArray count] > 0)
    {
        NSDictionary *contact = contactsArray[0];
        aCustomer.email = contact[@"Email"];
        aCustomer.phone = contact[@"Phone"];
        aCustomer.moblie = contact[@"Mobile"];
        aCustomer.fax = contact[@"Fax"];
    }
    
    NSString *addressInJSON = customerDict[@"Address"];
    NSDictionary *addressFromJSON = [NSJSONSerialization JSONObjectWithData:[addressInJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    NSArray *addressArray = addressFromJSON[@"address"];
    if ([addressArray count] > 0)
    {
        NSDictionary *address = addressArray[0];
        aCustomer.address = [NSString stringWithFormat:@"%@, %@, %@, %@ %@, %@",address[@"StreetLine1"], address[@"StreetLine2"], address[@"City"], address[@"State"], address[@"PostalCode"], address[@"Country"]];
    }
    
    [self updateUI];
}

- (void)updateUI
{
    self.nameLabel.text = aCustomer.name;
    [self.nameLabel sizeToFit];
    self.websiteLabel.text = aCustomer.website;
    [self.websiteLabel sizeToFit];
    self.categoryLabel.text = aCustomer.categoryCode;
    self.emailLabel.text = aCustomer.email;
    self.phoneLabel.text = aCustomer.phone;
    self.mobileLabel.text = aCustomer.moblie;
    self.faxLabel.text = aCustomer.fax;
    
    self.addressLabel.text = aCustomer.address;
    [self.addressLabel sizeToFit];
//    [self assignSizeToLabel:self.addressLabel withText:aCustomer.address andSize:(CGSizeMake(200, 100))];
//    self.addressLabel.text = aCustomer.address;
}

- (void)assignSizeToLabel:(UILabel *)label withText:(NSString *)text andSize:(CGSize) size
{
    CGSize expectedLabelSize = [text sizeWithFont:label.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect frameOfLabel= label.frame;
    frameOfLabel.size.height = expectedLabelSize.height;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.frame = frameOfLabel;
    
    label.text = text;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
