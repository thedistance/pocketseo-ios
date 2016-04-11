//
//  TDSelectionViewController.h
//  mCommerce
//
//  Created by Josh Campion on 10/07/2014.
//  Copyright (c) 2014 The Distance. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TDSelectionViewController;

typedef NS_ENUM(NSUInteger, SelectionType) {
    SelectionTypeSingle,
    SelectionTypeSingleSectioned,
    SelectionTypeMultiple,
};

@protocol SelectionCell <NSObject>

@property (nonatomic, strong) UILabel  * _Nullable titleLabel;
@property (nonatomic, strong) UILabel  * _Nullable detailLabel;

@end

@protocol TDSelectionViewControllerDelegate <NSObject>

/// This requests dismissal from the delegate. This assumes no specific form of presentation allowing the presenter to decide how the view is displayed to the user. It is assumed that this delegate call back updates the selection in the presenting view controller.
-(void)selectionViewControllerRequestsDismissal:(TDSelectionViewController * _Nonnull) selectionVC;
/// This requests dismissal from the delegate. This assumes no specific form of presentation allowing the presenter to decide how the view is displayed to the user. It is assumed that this delegate call back does not update the selection in the presenting view controller.
-(void)selectionViewControllerRequestsCancel:(TDSelectionViewController * _Nonnull) selectionVC;

@end

/*!
 * @class TDSelectionViewController
 * @discussion Simple class to display a list of choices. 
 
 The class generates cells using the identifiers `Basic` or `Detail` based on the values in `self.optionDetails`. Cells should be registered against these identifiers to prevent exceptions being thrown. Options can be configured into multiple sections using nested arrays in the `sortedOptionKeys` property. Cells should conform to `SelectionCell`. Cell selection should be configured in the cell itself.
 
 Has a delegate to return the selected choice(s) on dismissal. This only requests dismissal, it makes no assumption of how to be dismissed. This allows for modal / push / custom / child view controller presentation of the choices.
 */
@interface TDSelectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    /// Used to track the current selection so that if multiple selections aren't allowed, the previous selection has its selection accessory checkmark removed.
    NSIndexPath *currentSingleSelection;
}

@property (nonatomic, assign) SelectionType selectionType;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/// Dictionary representing the options the user can choose from. The keys are ids used in the code, and will be passed back to the delegate as the selections parameter in the `selectionViewController:requestsDismissalWithSelections:` method. The values should be NSStrings representing the description to be displayed to the user. Setting this property automatically sets the sortedOptionKeys property using the compare: selector if sortedOptionKeys has not been set.
@property (nonatomic, strong) NSDictionary<id, NSString *> * _Nullable options;

/// The titles to use for the section in the selection view.
@property (nonatomic, strong) NSArray<NSString *> * _Nullable sectionTitles;

/// Array of Arrays of keys for the choices. The nested array represents the section - row structure of the tableview. the keys should be unique otherwise the user's specific choices cannot be distinguished. As these objects should be the same as the keys in the self.options property, they should conform to the NSCopying Protocol. Sections are set using nested sets.
@property (nonatomic, strong) NSArray<NSArray<id> *> * _Nullable sortedOptionKeys;

/// Determines whether or not the view can be dismissed without the user making a selection. If true and no selection has been made when the user requests dismissal, a UIAlertView is presented.
@property (nonatomic, assign) BOOL requiresSelection;

/// Delegate to inform of the selection made on dismissal
@property (weak) id<TDSelectionViewControllerDelegate> _Nullable delegate;

/// The current selections made by the user. These should be stored as the keys from the options and optionKeys, thus each object conforms to NSCopying. Selections can be pre-specified by the presenter as this array determines the selected rows on viewWillAppear:. A set is used for more efficient checking of contains.
@property (nonatomic, strong) NSMutableSet * _Nonnull selectedKeys;

/// If an option's key has a value in this dictionary, that value is set as the detailTextLabel text. The values should thus be NSStrings.
@property (strong, nonatomic) NSDictionary * _Nullable optionDetails;

/// Checks whether the view can be dismissed based on the requiresSelectionProperty. If it can dismissal is requested from the delegate.
-(IBAction)dismissSelectionViewController:(id _Nullable)sender;

-(IBAction)cancelSelectionViewController:(id _Nullable)sender;

/// Helper method to set the options and their order.
-(void)setOptions:(NSDictionary * _Nonnull)options withDetails:(NSDictionary * _Nullable) details orderedAs:(NSArray * _Nonnull) orderedOptions;

/// As a presenter may present multiple selections, either singularly or at the same time, this property can be used to distinguish what this selection is for. It is not used in the class implementation
@property (nonatomic, strong) id _Nullable key;

/*!
 * @discussion Helper method to deal with multiple sections in the table.
 * @param key An object which is a key in the options NSDictionary property
 * @return NSIndexPath The index of this key in sortedOptionKeys, representing this option's position in the tableview.
 */
-(NSIndexPath * _Nullable)indexPathForKey:(id _Nonnull) key;

/*!
 * @discussion Helper method to deal with multiple sections in the table.
 * @param  indexPath The index of the option whose key should be returned.
 * @return id A key in the options NSDictionary property which is at indexPath in sortedOptionKeys.
 */
-(id _Nullable)keyForIndexPath:(NSIndexPath * _Nonnull) indexPath;

@end
