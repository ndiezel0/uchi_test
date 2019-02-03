require 'prawn'
require 'zip'

class Github
  include HTTParty
  base_uri 'https://api.github.com'
  headers 'Accept' => 'application/vnd.github.v3+json',
          'Authorization' => 'token %s' % Rails.application.credentials.dig(:github, :api_key),
          'User-Agent' => 'Uchi-Test'

  def initialize
    @options = {query: {page: 1}}
  end

  def collaborators(owner = nil, project = nil)
    self.class.get("/repos/%s/%s/contributors" % [owner, project], @options)
  end
end

class DefaultController < ApplicationController
  def index
  end

  def show
    @collaborators = collaborators(params[:repo])
  end

  def pdf
    send_file gen_pdf(params[:contrib], params[:project], params[:placement])
  end

  def pdf_zip
    send_file gen_zip(params[:project], params[:contribs])
  end

  private

  def gen_pdf(contributor = 'default_contrib', project = 'default_project', placement = 1)
    filename = Rails.root.join("tmp", "%s_%s.pdf" % [contributor, project])
    Prawn::Document.generate(filename) do
      move_down 30
      text '%s #%s' % [project, placement], align: :center, size: 28
      move_down 10
      text 'The award goes to', align: :center, size: 20
      move_down 10
      text contributor.to_s, align: :center, size: 16
    end
    filename
  end

  def gen_zip(project, contributors)
    filename = Rails.root.join("tmp", "%s.zip" % project)
    FileUtils.rm_f filename
    Zip::File.open(filename, Zip::File::CREATE) do |zipfile|
      contributors.each_with_index do |contributor, index|
        zipfile.add "%s.pdf" % contributor, gen_pdf(contributor, project, index + 1)
      end
    end
    filename
  end

  def collaborators(url, *options)
    link = options.any? ? options : URI::parse(url).path.split('/')[1..2]
    @project = link.last

    github = Github.new
    result = github.collaborators(*link)
    case result.code
    when 200
      JSON.parse(result.body)[0..2].map {|a| a['login']}
    when 204
      []
    else
      nil
    end
  rescue URI::InvalidURIError
    @project = 'none'
    nil
  end
end
