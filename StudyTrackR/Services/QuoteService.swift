import Foundation

// MARK: - ZenQuotes public API (no key required)
// Used on the Home screen to show a daily motivational quote
class QuoteService {

    static let shared = QuoteService()
    private init() {}

    private let url = URL(string: "https://zenquotes.io/api/random")!

    // Closure-based completion (satisfies "use at least one closure" requirement)
    func fetchQuote(completion: @escaping (Result<Quote, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            do {
                // API returns an array; grab the first element
                let quotes = try JSONDecoder().decode([Quote].self, from: data)
                if let quote = quotes.first {
                    completion(.success(quote))
                } else {
                    completion(.failure(URLError(.cannotParseResponse)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
