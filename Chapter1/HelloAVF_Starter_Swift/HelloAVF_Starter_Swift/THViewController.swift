//
//  THViewController.swift
//  HelloAVF_Starter_Swift
//
//  Created by nathan on 2020/12/24.
//

import UIKit
import AVFoundation

class THViewController: UITableViewController ,AVSpeechSynthesizerDelegate{

    var speechController :THSpeechController
    var speechStrings:Array<String> = [];
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets.init(top: 20, left: 0, bottom: 20, right: 0)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        speechController.synthesizer.delegate = self
        speechController.beginConversation()
    }
    
    required init(coder aDecoder: NSCoder) {
        speechController = THSpeechController.init()
        speechStrings = Array()
        super.init(coder: aDecoder)!
        
        
        // fatalError("init(coder:) has not been implemented")
        
    }
    
    // MARK: - AVSpeechSynthesizerDelegate
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        speechStrings.append(utterance.speechString)
        tableView .reloadData()
        let indexPath:IndexPath = NSIndexPath.init(row: speechStrings.count-1, section: 0) as IndexPath
        tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return speechStrings.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier:String = indexPath.row % 2 == 0 ? "YouCell" : "AVFCell"
        let cell:THBubbleCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! THBubbleCell
        cell.messageLabel.text = speechStrings[indexPath.row]
       
        return cell
    }
}
