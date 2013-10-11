require 'open-uri'

class BookmarksController < ApplicationController

  before_action :set_bookmark, only: [:edit, :update, :destroy]

  def index
    @bookmarks = Bookmark.find(:all, :order=>"created_at DESC")
    @bookmark = Bookmark.new
  end

  def new
    @bookmark = Bookmark.new
  end

  def create
    url = bookmark_params[:url]

    if Bookmark.find(:first, :conditions=>{:url=>url})
      status = 'already exist'
      render json: {status: status}

    else

      json = purse_html(url)

      if !json.empty?
        title = json[:title]

        @bookmark = Bookmark.new(:title => title, :url=> url)
        @bookmark.save

        status = 'success'
        html = render_to_string partial: 'panel', locals: { bookmark: @bookmark }
      else
        @bookmark = null
        status = 'error'
      end

      render json: {status: status, html: html}
    end

  end

  def edit
  end

  def update
    if @bookmark.update(bookmark_params)
      redirect_to bookmarks_path
    else
      render 'edit'
    end
  end

  def destroy
    if @bookmark.destroy
      status = 'success'
    else
      status = 'error'
    end
    render json: {status: status}
    # redirect_to bookmarks_path
  end

  private
    def bookmark_params
      params[:bookmark].permit(:url)
    end

    def set_bookmark
      @bookmark = Bookmark.find(params[:id])
    end

    # htmlをパースする
    def purse_html(url)
      json = {}
      begin
        if url =~ /http[s]?\:\/\/[\w\+\$\;\?\.\%\,\!\#\~\*\/\:\@\&\\\=\_\-]+/
          res = open(url,"r",{:ssl_verify_mode=>OpenSSL::SSL::VERIFY_NONE})
          doc = Nokogiri::HTML(res, nil, 'utf-8')
          json[:title] = doc.search('title').first.inner_text  if doc.search('title')
          json[:description] = doc.search('meta[@name="description"]').first.attribute("content").to_s if doc.search('meta[@name="description"]').first
          # invalid byte sequence in UTF-8というエラーが出る場合は下記を追加すると対応できます
          # str.encode("UTF-8", "UTF-8", invalid: :replace, undef: :replace, replace: '')
        else
          raise "不明なプロトコルなため処理を中断"
        end
      rescue Exception => e
        logger.error "error-message:" + e.message
      end
      json
    end


end
