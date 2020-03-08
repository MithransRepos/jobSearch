//
//  JobSearchViewController.swift
//  jobSearch
//
//  Created by MithranN on 08/03/20.
//  Copyright © 2020 MithranN. All rights reserved.
//

import UIKit

class JobSearchViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Job Search"
        
        let params = ApiRequestParam()
        params.searchText = "Developer"
        let dictionary = try? params.asDictionary()
        JobSearchDataManager().searchJob(params: dictionary) { result in
            switch result {
            case .success(_):
                print("s")
            case .failure(_):
                print("f")
            }
        }
        
    }
    

  

}
