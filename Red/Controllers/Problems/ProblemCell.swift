//
//  ProblemCell.swift
//  Red
//
//  Created by Tolga Sarikaya on 09.09.23.
//

import UIKit

class ProblemCell: UITableViewCell {

    // MARK: - UI Elemets
    
    @IBOutlet var projectPersonLabel: UILabel!
    
    @IBOutlet var problemImageView: UIImageView!
    
    @IBOutlet var problemLabel: UILabel!
    
    @IBOutlet var projectNameLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        problemImageView.layer.cornerRadius = 32
        problemImageView.clipsToBounds = true
        problemImageView.layer.shadowColor = UIColor.black.cgColor
        problemImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        problemImageView.layer.shadowOpacity = 1
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     
    }

}
