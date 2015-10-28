class PagesController < ApplicationController
  def index
    revision_key = $redis.get("noteriver:index:current")
    index_html = $redis.get("noteriver:index:#{revision_key}")
    render html: index_html.html_safe
  end
end
