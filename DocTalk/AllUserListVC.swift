//
//  AllUserListVC.swift
//  DocTalk
//
//  Created by Uniqolabel Developer on 19/04/18.
//  Copyright © 2018 GeekGuns. All rights reserved.
//

import UIKit
import SDWebImage

class AllUserListVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet var userListTable: UITableView!
    
    
    @IBOutlet var searchUserTextField: UITextField!
    var enterUserName : String = ""
    var userListArray : NSArray = []
    var pageCount : Int = 0;
    var totalPage : Int = 0;
    
    
    
//    var name = "shubham"
    override func viewDidLoad() {
        super.viewDidLoad()
//            GetUserList(userName: "Anup", pagenumber: 1)
        // Do any additional setup after loading the view.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func GetUserList(userName : String , pagenumber : Int) {
        let url = "\(userList)\(userName)"
        
        let param : NSDictionary = ["page":pagenumber,
                                    "per_page":"100",
                                    "sort":"followers",
                                    "order":"desc"]
        
        AlamofireConnectionMangager.getSingleton().getDataFromServer(url: url, param: param, success: { (responseResult)->Void in
            
            print("ResponseResult",responseResult)
            
            if let message : String = responseResult.value(forKey: "message") as? String {
                self.showAlert(alertMessage: message)
                
            }
            else{
                
                
                let tempDataArray : NSArray = responseResult.value(forKey: "items") as! NSArray;
                if self.userListArray.count == 0 {
                    self.userListArray = tempDataArray
                    
                }
                else{
                    self.userListArray = self.userListArray.addingObjects(from: tempDataArray as! [Any]) as NSArray
                    
                }
                
                let totalCount : NSNumber = responseResult.value(forKey: "total_count") as! NSNumber
                
                self.totalPage = totalCount.intValue / 100
                
                
                self.userListTable.reloadData()
            }
              
        },failure:  { (error)-> Void in
            print("Error",error!)
        })
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UserListCell = self.userListTable.dequeueReusableCell(withIdentifier: "userListCell") as! UserListCell
        
        let userListDict : NSDictionary = userListArray[indexPath.row] as! NSDictionary
        
        
        cell.nameLabel.text = (userListDict.value(forKey: "login") as! String)
        cell.followersLabel.text = String(indexPath.row)
        
        let imgUrl : String = userListDict.value(forKey: "avatar_url") as! String
        
        cell.userAvatar.sd_setImage(with: URL(string: imgUrl), placeholderImage: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //        print("shouldChangeCharactersIn is calling")
        
        if textField == self.searchUserTextField{
           
            enterUserName = ((textField.text as NSString?)?.replacingCharacters(in: range, with: string))!
            
            
            print("enterUserName",enterUserName)
            
             enterUserName = enterUserName.replacingOccurrences(of: " ", with: "")

             GetUserList(userName: enterUserName, pagenumber: 1)
           
        }
        else{
            
        }
        
        
        
        return true
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        let lastElement = userListArray.count - 1 //dataMutableArray.count - 1
        if indexPath.row == lastElement {

            if (pageCount <=  totalPage){
                pageCount += 1

                GetUserList(userName: enterUserName, pagenumber: pageCount)



            }
        }


    }

}

extension UIViewController{
    
    func showAlert(alertMessage : String ) {
        let alertController = UIAlertController(title: "Error", message: alertMessage, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
