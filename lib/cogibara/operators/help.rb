# require_relative 'wolfram_alpha.rb'

class Help < Cogibara::OperatorBase

  def process(message)
    operators = Cogibara::dispatcher.operators.keys

    soft_operators = operators.reject{ |o| o.upcase != o}
    hard_operators = operators

    "I understand the following categories of natural speech: #{soft_operators}, and keyword queries of the form #{Cogibara::config.name}: #{hard_operators}. Most natural speech categories implement a more natural response, so, for example, 'what is 18 dollars in rupees' activates the knowledge module, and returns 'rupee 968.31(Indian rupees)', while the 'ask' keyword sends the query to the knowledge engine and prints raw output, so 'cucumber ask what is 18 dollars in rupees' = 'Input Interpretation: convert $18  (US dollars) to Indian rupees, Result: rupee968.31  (Indian rupees), 1-year  minimum | rupee931.42  (October 4, 2012 | 7 months ago) 1-year  maximum | rupee1030.38  (June 24, 2012 | 10 months ago)"
  end
end