//
//  ProblemFeedTableViewController.swift
//  Red
//
//  Created by Tolga Sarikaya on 09.09.23.
//

import UIKit
import FirebaseFirestore
import FirebaseDatabase
import FirebaseStorage
import SDWebImage


class ProblemFeedTableViewController: UITableViewController {
    
    // MARK: - Properties
    let fireStoreDatabase = Firestore.firestore()
    var problemList = [Problem]()
    var viewModel  = ProblemViewModel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLightMode()
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.systemRed
            navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(addButton))
        
        tableView.separatorColor = UIColor(white: 0.95, alpha: 1)
        
        
        _ = viewModel.problemsList.subscribe(onNext: { list in
            self.problemList = list
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
        })
        
    }
    
    // MARK: - Funtions
    private func doneButtonConfiguration(for problemCell: ProblemCell) -> UICellAccessory.CustomViewConfiguration {
        let symbolName = problemCell.isComplete ? "circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        let button = UIButton()
            button.setImage(image, for: .normal)
            return UICellAccessory.CustomViewConfiguration(
            customView: button, placement: .leading(displayed: .always))
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return problemList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let problem = problemList[indexPath.row]
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProblemCell
        cell.projectPersonLabel.text = "Engineer: \(problem.projectEngineer!)"
        cell.problemLabel.text = "Problem: \(problem.problemExplain!)"
        cell.problemImageView.sd_setImage(with: URL(string: problem.problemImage!))
        cell.documentIdLabel.text = problem.documentId
        cell.backgroundColor = UIColor(white: 0.95, alpha: 1)
        cell.cellBackground.layer.cornerRadius = 12.0
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath)  {
            guard cell.accessoryType != .checkmark else {
                cell.accessoryType = .none
                return
            }
            cell.accessoryType = .checkmark
      }
    }
        
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            return .delete
        }
        
    
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            let problem = problemList[indexPath.row]
            
            if editingStyle == .delete {
                viewModel.deleteProject(documentID: problem.documentId!)
              
            }
        }
     
    // MARK: - Actions
    @objc func addButton() {
        performSegue(withIdentifier: "toProblem", sender: nil)
    }
}
