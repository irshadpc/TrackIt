//
//  EntryCell.swift
//  TrackIt
//
//  Created by Jason Ji on 4/29/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit
import TagListView
import DateTools

class EntryCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tagListView: TagListView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension EntryCell: EntryConfigurable {
    func configureWithEntry(entry: Entry, numberFormatter: NSNumberFormatter) {
        guard let amount = entry.amount,
                    date = entry.date,
                    note = entry.note else { return }
        
        amountLabel.text = numberFormatter.stringFromNumber(amount)
        amountLabel.textColor = Double(amount) >= 0 ? UIColor(red: 3/255.0, green: 166/255.0, blue: 120/255.0, alpha: 1.0) : UIColor.orangeColor()
        dateLabel.text = date.formattedDateWithStyle(.ShortStyle, locale: NSLocale.currentLocale())
        noteLabel.text = note
        
        if entry.tags?.count > 0, let tags = entry.tags {
            tagListView.hidden = false
            tagListView.removeAllTags()
            let sortedTags = tags.allObjects.sort { return $0.name < $1.name } as! [Tag]
            for tag in sortedTags {
                let tagView = tagListView.addTag(tag.name!)
                tagView.tagBackgroundColor = ColorManager.colorForIndex(Int(tag.colorIndex!))
            }
        }
        else {
            tagListView.hidden = true
        }
        
        self.editingAccessoryType = .DisclosureIndicator
    }
}
