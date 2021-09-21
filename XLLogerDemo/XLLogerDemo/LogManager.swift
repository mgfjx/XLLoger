//
//  LogManager.swift
//  XLLogerDemo
//
//  Created by mgfjx on 2021/9/21.
//

import UIKit

class LogManager: NSObject {
    
    var inputPipe:Pipe!
    var outputPipe:Pipe!
    
    @objc var callback: ((String)->Void)?
    
    @objc public func openConsolePipe() {
        DispatchQueue.main.async {
            self.inputPipe = Pipe()

            self.outputPipe = Pipe()
            let pipeReadHandle = self.inputPipe.fileHandleForReading

            dup2(STDOUT_FILENO, self.outputPipe.fileHandleForWriting.fileDescriptor)
            dup2(STDERR_FILENO, self.outputPipe.fileHandleForWriting.fileDescriptor)

            dup2(self.inputPipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)
            dup2(self.inputPipe.fileHandleForWriting.fileDescriptor, STDERR_FILENO)

            NotificationCenter.default.addObserver(self, selector: #selector(self.handlePipeNotification), name: FileHandle.readCompletionNotification, object: pipeReadHandle)

            pipeReadHandle.readInBackgroundAndNotify()
        }
    }
    
    @objc func handlePipeNotification(notification: Notification)
    {
            DispatchQueue.main.async {
                self.inputPipe.fileHandleForReading.readInBackgroundAndNotify()
                if let data = notification.userInfo![NSFileHandleNotificationDataItem] as? Data,
                let str = String(data: data, encoding: String.Encoding.ascii) {
                    self.outputPipe.fileHandleForWriting.write(data)
                    if self.callback != nil {
                        self.callback!(str)
                    }
                }
            }
    }

}
