//
//  Test1ViewController.swift
//  ImitateMeizi
//
//  Created by wsk on 2018/7/30.
//  Copyright © 2018年 hml. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class Test1ViewController: ASViewController<ASDisplayNode> {

    private var p_vm: DoubanVM = DoubanVM()
    
    private lazy var p_tableView = ASTableNode().then { (obj: ASTableNode) in
        obj.backgroundColor = .white
        obj.view.separatorStyle = .none
        obj.delegate = self
        obj.dataSource = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.p_tableView.frame = self.view.bounds
        self.p_tableView.leadingScreensForBatching = 1.0;  // 默认值是 2.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubnode(self.p_tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension Test1ViewController: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        let minSize = CGSize.init(width: CGFloat.screen_width, height: ((CGFloat.screen_width*9)/16))
        let maxSize = CGSize.init(width: CGFloat.screen_width, height: CGFloat(MAXFLOAT))
        let range = ASSizeRange.init(min: minSize, max: maxSize)
        return range
    }
    
    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        return true
    }
    
    typealias closures = (Bool) -> (Void)

    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        self.retrieveNextPageWithCompletion { (iterms) -> (Void) in
            context.completeBatchFetching(true)
        }
    }
    
    func retrieveNextPageWithCompletion(callBack: closures?) {
        self.p_vm.loadData(category:.daXiong, suc: { [weak self] (oldCount, iterms) in
            var isFinish: Bool = false
            if let datas = iterms as? [MeiziIterm] {
                if datas.count > oldCount {
                    self?.p_tableView.insertWith(start: oldCount, count: datas.count)
                    isFinish = true
                }
                else {
                    isFinish = false
                }
            }
            if let cb = callBack {
                cb(isFinish)
            }
        }) { (error) in
            if let cb = callBack {
                cb(false)
            }
        }
    }
}

extension Test1ViewController: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.p_vm.p_dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let model: MeiziIterm = self.p_vm.p_dataSource[indexPath.row]
        return  {
            let node: MeiziCellNode = MeiziCellNode.init(model: model)
            return node
        }
    }
}




