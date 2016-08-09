import UIKit
// ###############################################################
// This is the CustomTableViewCell class, responsable for the format of the custom TableView cells used in the
//  main menu and Research section.  The additional attribute added by this custom class is a custom separator
//  that is drawn from the far left to the far right, used in place of the default separator.
// ###############################################################
class CustomTableViewCell: UITableViewCell {
// ###############################################################
// Outlets
// ###############################################################
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
// ###############################################################
// Class Functions
// ###############################################################
    // This override draws in a custom separator with the desired dimensions
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor) // Set color to black
        CGContextSetLineWidth(context, 2) // Set width to 2
        CGContextMoveToPoint(context, 0, self.bounds.size.height)
        CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height)
        CGContextStrokePath(context)
    }
}
