require 'wikipedia'
require 'wikicloth'
require 'json'
require 'sanitize'

class WikiGetter

  def checkRedirect(article)
    if(/\Aredirect/ =~ article.strip)
      return article.strip.gsub(/\Aredirect/,'')
    elsif(/\AREDIRECT/ =~ article.strip)
      return article.strip.gsub(/\AREDIRECT/,'').strip
    end
  end

  def getArticle(title)
      article = JSON.parse(Wikipedia.find(title).json)["query"]["pages"].to_a[0][1]["revisions"]
      unless article
        "Could not find article, sorry"
      else
        raw = article[0]["*"]
        # parsed = Wikitext::Parser.new.parse(raw)
        parsed = WikiCloth::Parser.new({:data => raw})
        sanitized = Sanitize.clean(parsed.to_html)
        redirect = checkRedirect(sanitized)
        if redirect
          puts "redirecting to #{redirect}"
          getArticle(redirect)
        else
          ref_links = sanitized.gsub(/\[\d+\]/,'').gsub(/\[edit\]/,'')
          http_links = ref_links.gsub(/\[http+\s?\]/m,'')


          # leftover = sanitized.gsub(/\[\[.*\]\]/, '').gsub(/\{\{.*\}\}/, '')
          # leftover = leftover.gsub(/\[\[.*?\]\]/m, '').gsub(/\{\{.*?\}\}/m, '').gsub(/&lt;.*?&gt;/m,'')
          # leftover = leftover.gsub(/\'\'/,'').gsub(/\[http.*?\]/m,'').gsub(/\{\|.*?\|\}/m,'').gsub(/\}\}/,'')
          # removeUgly = leftover.gsub(/\|/,' ').gsub(/\_/,'')
        end
      end

    # leftover
    # leftover
  end
end

# puts WikiGetter.new.getArticle("Cattle")
# puts WikiGetter.new.getArticle("Cat").length