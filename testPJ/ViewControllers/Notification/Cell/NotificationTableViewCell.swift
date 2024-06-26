//
//  NotificationTableViewCell.swift
//  testPJ
//
//  Created by yilin on 2024/6/26.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var readView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(_ viewModel: NotificationModel.Message) {
        self.titleLabel.text = viewModel.title
        self.dateLabel.text = viewModel.updateDateTime
        self.contentLabel.text = viewModel.message
        self.readView.isHidden = viewModel.status
    }
    
}
