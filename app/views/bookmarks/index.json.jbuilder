json.array!(@bookmarks) do |bookmark|
  json.extract! bookmark, :title, :url, :like
  json.url bookmark_url(bookmark, format: :json)
end
