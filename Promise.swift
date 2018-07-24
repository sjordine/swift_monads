class Promise<T> {
    
    var task:(() -> T)?
    
    
    init() {
        
    }
    
    init(_ value: T) {
        task = { value }
    }
    
    init(_ task:@escaping() -> T) {
        self.task = task
    }
    
    
    func onCompletion(_ handler:@escaping (T)->Void) {
        if let task = self.task {
            DispatchQueue.global().async {
                let resultValue = task()
                handler(resultValue)
            }
        }
    }
    
    func map<Destination>(_ transform:@escaping(T)->Destination) -> Promise<Destination> {
        return PromiseMap(container: self, transform: transform)
    }
    
    func flatMap<Destination>(_ transform:@escaping(T) -> Promise<Destination>) -> Promise<Destination> {
        let mappedTransform = self.map(transform)
        return NestedPromise(mappedTransform)
    }
}