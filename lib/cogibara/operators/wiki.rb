require_relative 'wiki/wiki_getter.rb'

class Wiki < Cogibara::OperatorBase

  def initialize_operator
    @handler = WikiGetter.new
  end

  def process(message)
    search = message.text
    article = WikiGetter.new.getArticle(search)
    # splits = article.split
    # (splits.count / 100).times do |n|
    #     if (n+1)*100 > splits.count
    #       chunk = splits[n*100..splits.count] * ' '
    #     else
    #       chunk = splits[n*100..((n+1)*100 - 1)] * ' '
    #     end
    #     yield chunk
    #   end
  end
end