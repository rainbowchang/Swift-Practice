//
//  ViewController.swift
//  practice01
//
//  Created by 张长虹 on 15/6/22.
//  Copyright (c) 2015年 张长虹. All rights reserved.
//

import UIKit
import SystemConfiguration

class ViewController: UIViewController {
    
    var t:MyTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var button:UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        button.frame=CGRectMake(10,150,100,30)
        button.setTitle("JSON", forState: .Normal)
        button.addTarget(self, action: Selector("tapped"), forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
        
        var button2:UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        button2.frame=CGRectMake(10,200,100,30)
        button2.setTitle("XML", forState: .Normal)
        button2.addTarget(self, action: Selector("tapped2"), forControlEvents: .TouchUpInside)
        self.view.addSubview(button2)
        
        var button3:UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        button3.frame=CGRectMake(10,250,100,30)
        button3.setTitle("Http client", forState: .Normal)
        button3.addTarget(self, action: Selector("tapped3"), forControlEvents: .TouchUpInside)
        self.view.addSubview(button3)
        
        var button4:UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        button4.frame=CGRectMake(10,300,100,30)
        button4.setTitle("Timer", forState: .Normal)
        button4.addTarget(self, action: Selector("tapped4"), forControlEvents: .TouchUpInside)
        self.view.addSubview(button4)
        
        var button5:UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        button5.frame=CGRectMake(10,350,100,30)
        button5.setTitle("Suspend", forState: .Normal)
        button5.addTarget(self, action: Selector("tapped5"), forControlEvents: .TouchUpInside)
        self.view.addSubview(button5)
        
        var button6:UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        button6.frame=CGRectMake(10,400,100,30)
        button6.setTitle("network type", forState: .Normal)
        button6.addTarget(self, action: Selector("tapped6"), forControlEvents: .TouchUpInside)
        self.view.addSubview(button6)
    }
    
    func tapped(){
        let user = ["uname" : "user1",
            "tel":["mobile":"138138000101","home":"010"]]
        var jsonstring=(user as NSDictionary).JSONString()
        println(jsonstring)
        println(jsonstring.objectFromJSONString() as! NSDictionary)
        var jsondata = (user as NSDictionary).JSONData()
        println(jsondata)
        println(jsondata.objectFromJSONData() as! NSDictionary)
        //NSJSONSerialization.isValidJSONObject(obj: AnyObject)  这个函数很有用处
    }
    
    func tapped2(){
        //获取xml文件路径
        var path = NSBundle.mainBundle().pathForResource("users", ofType:"xml")
        //获取xml文件内容
        var xmlData = NSData(contentsOfFile:path!)
        //可以转换为字符串输出查看
        //println(NSString(data:xmlData, encoding:NSUTF8StringEncoding))
        
        //使用NSData对象初始化文档对象
        //这里的语法已经把OC的初始化函数直接转换过来了
        var doc:GDataXMLDocument = GDataXMLDocument(data:xmlData, options : 0, error : nil)
        
        //获取Users节点下的所有User节点，显式转换为element类型编译器就不会警告了
        //var users = doc.rootElement().elementsForName("User") as GDataXMLElement[]
        
        //通过XPath方式获取Users节点下的所有User节点，在路径复杂时特别方便
        var users = doc.nodesForXPath("//User", error:nil) as! [GDataXMLElement]
        
        for user in users {
            //User节点的id属性
            let uid = user.attributeForName("id").stringValue()
            //获取name节点元素
            let nameElement = user.elementsForName("name")[0] as! GDataXMLElement
            //获取元素的值
            let uname =  nameElement.stringValue()
            //获取tel子节点
            let telElement = user.elementsForName("tel")[0] as! GDataXMLElement
            //获取tel节点下mobile和home节点
            let mobile = (telElement.elementsForName("mobile")[0] as! GDataXMLElement).stringValue()
            let home = (telElement.elementsForName("home")[0] as! GDataXMLElement).stringValue()
            //输出调试信息
            println("User: uid:\(uid),uname:\(uname),mobile:\(mobile),home:\(home)")
        }
    }
    
    func tapped3(){
        let urlString:String = " "
        var url: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{
            (response, data, error) -> Void in
            
            if (error != nil) {
                //Handle Error here
            }else{
                //Handle data in NSData type
            }
            
        })
    }
    
    func tapped4(){
        t = MyTimer()
        t!.doTimer()
    }
    
    func tapped5(){
        t?.suspend()
        t = nil
    }
    
    func tapped6(){
        if(ViewController.isConnectedToNetwork()){
            ViewController.isConnectedToNetworkOfType()
        }else{
            println("无连接")
        }
        
    }
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
        }
        var flags: SCNetworkReachabilityFlags = 0
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
            return false
        }
        let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection) ? true : false
    }
    
    class func isConnectedToNetworkOfType() -> IJReachabilityType {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
        }
        var flags: SCNetworkReachabilityFlags = 0
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
            println("无连接")
            return .NotConnected
        }
        let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
        let isWWAN = (flags & UInt32(kSCNetworkReachabilityFlagsIsWWAN)) != 0
        //let isWifI = (flags & UInt32(kSCNetworkReachabilityFlagsReachable)) != 0
        if(isReachable && isWWAN){
            println("蜂窝网")
            return .WWAN
        }
        if(isReachable && !isWWAN){
            println("Wi-Fi")
            return .WiFi
        }
        return .NotConnected
        //let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        //return (isReachable && !needsConnection) ? true : false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    enum IJReachabilityType {
        case WWAN,
        WiFi,
        NotConnected
    }
    
}

