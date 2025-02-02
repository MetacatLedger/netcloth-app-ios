




import Foundation

class StoreObservable<Element> {
    private var _value: Element
    
    deinit {
        print("dealloc \(type(of: self))")
    }

    init(value: Element) {
        self._value = value
    }
    var value: Element {
        _value
    }

    let observable = PublishSubject<Void>()

    func change(commit: (Element)-> Void) {
        commit(_value)
        observable.onNext(())
    }
}
