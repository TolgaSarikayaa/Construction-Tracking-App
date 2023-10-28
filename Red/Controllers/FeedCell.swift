//
//  FeedCell.swift
//  Red
//
//  Created by Tolga Sarikaya on 19.08.23.
//

import UIKit

class FeedCell: UITableViewCell {

    // MARK: - UI Elements
    @IBOutlet var userLabel: UILabel!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var structureNameLabel: UILabel!
    @IBOutlet var documentIdLabel: UILabel!
    @IBOutlet var structureTypeLabel: UILabel!
    @IBOutlet weak var cellBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.layer.cornerRadius = 32
        userImageView.clipsToBounds = true
        userImageView.layer.shadowColor = UIColor.black.cgColor
        userImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        userImageView.layer.shadowOpacity = 1
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
