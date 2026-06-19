import UIKit
import WebKit

public class AdSwap {
    public static let shared = AdSwap()
    
    private var pubId: String?
    // INSERISCI QUI IL TUO SITO NETLIFY SEGUITO DA /ad.html
    private let baseURL = "https://adswap.netlify.app/ad.html"
    
    private init() {}
    
    public func initialize(publisherId: String) {
        self.pubId = publisherId
    }
    
    public func showBanner(in view: UIView, category: String = "any") {
        guard let pubId = pubId else {
            print("AdSwap Error: You must call initialize() first.")
            return
        }
        
        let webView = createTransparentWebView()
        webView.frame = view.bounds
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if let url = URL(string: "\(baseURL)?pubId=\(pubId)&format=banner&category=\(category)&platform=ios") {
            webView.load(URLRequest(url: url))
            view.addSubview(webView)
        }
    }
    
    public func showInterstitial(category: String = "any") {
        guard let pubId = pubId else {
            print("AdSwap Error: You must call initialize() first.")
            return
        }
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }),
              let rootVC = window.rootViewController else { return }
        
        let webView = createTransparentWebView()
        webView.frame = rootVC.view.bounds
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Collega il sensore per la chiusura dell'annuncio
        let contentController = webView.configuration.userContentController
        let handler = CloseHandler(webView: webView)
        contentController.add(handler, name: "AdSwapApple")
        
        if let url = URL(string: "\(baseURL)?pubId=\(pubId)&format=interstitial&category=\(category)&platform=ios") {
            webView.load(URLRequest(url: url))
            rootVC.view.addSubview(webView)
        }
    }
    
    private func createTransparentWebView() -> WKWebView {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        return webView
    }
}

// Classe per ascoltare il comando "Chiudi" dalla tua pagina HTML
class CloseHandler: NSObject, WKScriptMessageHandler {
    weak var webView: WKWebView?
    
    init(webView: WKWebView) {
        self.webView = webView
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "AdSwapApple" {
            DispatchQueue.main.async {
                self.webView?.removeFromSuperview()
            }
        }
    }
}
