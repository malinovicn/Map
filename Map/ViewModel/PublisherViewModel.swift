//
//  PublisherViewModel.swift
//  Map
//
//  Created by Nikola Malinovic on 25.03.21.
//

import Foundation
import Combine

/// A generic view model implementation
///
///     struct SomeView: View {
///         @ObservedObject var model = PublisherViewModel { SomeAPI.get() }
///         :
///     }
open class PublisherViewModel<Input, Output>: ObservableObject {
    public typealias Processor = (Input) -> AnyPublisher<Output, Error>
    public struct Configuration {
        public init(delay: DispatchQueue.SchedulerTimeType.Stride = 0,
                    debounce: DispatchQueue.SchedulerTimeType.Stride = 0,
                    timeout: DispatchQueue.SchedulerTimeType.Stride = 10,
                    retries: Int = 3,
                    scheduler: DispatchQueue = DispatchQueue.main) {
            self.delay = delay
            self.debounce = debounce
            self.timeout = timeout
            self.retries = retries
            self.scheduler = scheduler
        }

        var delay: DispatchQueue.SchedulerTimeType.Stride = 0
        var debounce: DispatchQueue.SchedulerTimeType.Stride = 0
        var timeout: DispatchQueue.SchedulerTimeType.Stride = 10
        var retries = 3
        var scheduler = DispatchQueue.main
    }

    @Published public var output: Output?
    @Published public var input: Input?
    @Published public var isLoading = false
    @Published public var error: Error? {
        didSet { hasError = error != nil }
    }

    @Published public var hasError = false

    private var holder, cancellable: AnyCancellable?

    public init(configuration: Configuration = Configuration(), processor: @escaping Processor) {
        holder = $input
            .delay(for: configuration.delay, scheduler: configuration.scheduler)
            .debounce(for: configuration.debounce, scheduler: configuration.scheduler)
            .sink { input in
                guard let input = input else { return }
                self.cancellable?.cancel()
                self.isLoading = true
                self.cancellable = processor(input)
                    .timeout(configuration.timeout, scheduler: configuration.scheduler)
                    .retry(configuration.retries)
                    .receive(on: configuration.scheduler)
                    .sink(receiveCompletion: { completion in
                        self.isLoading = false
                        if case let .failure(error) = completion {
                            self.error = error
                            debugPrint(error)
                        } else {
                            self.error = nil
                        }
                    }, receiveValue: { value in
                        self.output = value
                    })
            }
    }

    /// Triggers an update without inputs
    @discardableResult public func start() -> Self {
        input = () as? Input
        return self
    }

    /// Triggers an update without inputs only if not already started
    @discardableResult public func autostart() -> Self {
        if output == nil, error == nil {
            start()
        }
        return self
    }
}
