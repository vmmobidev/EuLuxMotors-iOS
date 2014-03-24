//
//  InventoryViewController.m
//  EuLux
//
//  Created by Varghese Simon on 3/3/14.
//  Copyright (c) 2014 Vmoksha. All rights reserved.
//

#import "InventoryViewController.h"
#import "SWRevealViewController.h"
#import "AFNetworking.h"
#import <dispatch/dispatch.h>
#import "InventoryObject.h"
#import "InventoryItemViewController.h"

@interface InventoryViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation InventoryViewController
{
    NSDictionary *dictionaryFromJOSN;
    NSMutableDictionary *dictionaryOfBrandNames;
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
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:.31 green:.46 blue:.99 alpha:1];
    }else
    {
        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:.31 green:.46 blue:.99 alpha:1]];
    }
    
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( rightRevealToggle: )];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer = requestSerializer;

    
    NSString *stringOfJSON = @"{\"request\":{\"UserType\":\"Supplier\",\"InventoryCode\":null,\"Brand\":null,\"Model\":null,\"Transmission\":null,\"Color\":null,\"Supplier\":null,\"CompanyCode\":null,\"Year\":null,\"FromRange\":null,\"ToRange\":null}}";
    
    NSLog(@"%@",stringOfJSON);
    
    
    NSData *datOfJSON = [stringOfJSON dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://ripple-io.in/Inventory/Search/Supplier"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody:datOfJSON];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        [self sendSyncRequest:request];
    });
}

- (void)sendSyncRequest:(NSURLRequest *)request
{
    NSURLResponse *response;
    NSError *error;
    NSData *jsonResult = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    if (!error)
    {
        if (!dictionaryFromJOSN)
        {
            dictionaryFromJOSN = [[NSDictionary alloc] init];
        }
        dictionaryFromJOSN = [NSJSONSerialization JSONObjectWithData:jsonResult options:kNilOptions error:Nil];

        [self respondToJSONResult:dictionaryFromJOSN];
    }
}

- (void)respondToJSONResult:(NSDictionary *)dictFromJSON
{
    NSArray *inventories = dictFromJSON[@"aaData"][@"Inventories"];
    
    if (!dictionaryOfBrandNames)
    {
        dictionaryOfBrandNames = [[NSMutableDictionary alloc] init];
    }
    
    for (NSDictionary *anEntry in inventories)
    {
        NSMutableArray *arrayOfCurrentBrand = dictionaryOfBrandNames[anEntry[@"BrandName"]];
        
        if (!arrayOfCurrentBrand) {
            arrayOfCurrentBrand = [[NSMutableArray alloc] init];
            [dictionaryOfBrandNames setObject:arrayOfCurrentBrand forKey:anEntry[@"BrandName"]];
        }
        
        InventoryObject *anItem = [[InventoryObject alloc] init];
        anItem.invID = [anEntry[@"Id"] integerValue];
        anItem.inventoryCode = anEntry[@"InventoryCode"];
        anItem.brandName = anEntry[@"BrandName"];
        anItem.modelName = anEntry[@"ModelName"];
        anItem.transmissionName = anEntry[@"TransmissionName"];
        anItem.colorName = anEntry[@"ColorName"];
        anItem.yearOfManufacture = anEntry[@"YearOfManufacture"];
        anItem.supplierName = anEntry[@"SupplierName"];
        anItem.supplierURLString = anEntry[@"SupplierWebsiteUrl"];
        anItem.MSRP = [anEntry[@"MSRP"] floatValue];
        
        [arrayOfCurrentBrand addObject:anItem];
        [dictionaryOfBrandNames setObject:arrayOfCurrentBrand forKey:anEntry[@"BrandName"]];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateUIAfterParsing];
    });
}

- (void)updateUIAfterParsing
{
    [self.tableView reloadData];
    
    NSLog(@"%@",dictionaryOfBrandNames);
    NSLog(@"%@",[dictionaryOfBrandNames allKeys]);
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
    NSArray *allKeys = [dictionaryOfBrandNames allKeys];
    return [allKeys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"brandNameCell" forIndexPath:indexPath];
    NSArray *allKey = [dictionaryOfBrandNames allKeys];
    
    NSString *brandName = allKey[indexPath.row];
    
    NSArray *arrayOfItems = dictionaryOfBrandNames[brandName];
    UILabel *brandLabel = (UILabel *)[cell viewWithTag:10];
    brandLabel.text = allKey[indexPath.row];
    
    UILabel *numberLabel = (UILabel *)[cell viewWithTag:11];
    numberLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[arrayOfItems count]];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showAllItemsInInventorySegue"])
    {
        InventoryItemViewController *invItem = (InventoryItemViewController *)segue.destinationViewController;
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        
        UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:selectedIndexPath];
        UILabel *label = (UILabel *)[selectedCell viewWithTag:10];
        
        invItem.itemsToShow = dictionaryOfBrandNames[label.text];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
