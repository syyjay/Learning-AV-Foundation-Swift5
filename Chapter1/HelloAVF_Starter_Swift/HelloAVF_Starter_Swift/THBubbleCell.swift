//
//  THBubbleCell.swift
//  HelloAVF_Starter_Swift
//
//  Created by nathan on 2020/12/24.
//

import UIKit

class THBubbleCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
