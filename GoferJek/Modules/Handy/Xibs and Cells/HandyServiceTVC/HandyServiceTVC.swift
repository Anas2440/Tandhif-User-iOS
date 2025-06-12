//
//  HandyServiceTVC.swift
//  GoferHandy
//
//  Created by trioangle on 25/08/20.
//  Copyright © 2020 Trioangle Technologies. All rights reserved.
//

import UIKit

class HandyServiceTVC: UITableViewCell {

    @IBOutlet weak var categorieTableView : UITableView!
    static let CellHeight  = 150
    var contentCount = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initView()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initView(){
        self.categorieTableView.registerNib(forCell: HandySubServiceTVC.self)
        self.categorieTableView.dataSource = self
        self.categorieTableView.delegate = self
    }
    
}
extension HandyServiceTVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return contentCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HandySubServiceTVC = tableView.dequeueReusableCell(for: indexPath)
        cell.nameLbl.text = "\(LangHandy.name.capitalized) \(indexPath.row + 1)"
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return LangHandy.categoryName
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 50
       }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Self.CellHeight)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
   
    
}
extension HandyServiceTVC : UITableViewDelegate{
   
}
