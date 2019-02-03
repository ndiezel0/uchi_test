require 'rails_helper'

RSpec.describe "Contributor search", type: :request do
  describe 'GET pdf' do
    it 'returns pdf' do
      contrib = 'example_contrib'
      project = 'example_project'
      placement = 1
      get('/pdf?contrib=%s&project=%s&placement%s' % [contrib, project, placement])
      filepath = Rails.root.join('tmp', '%s_%s.pdf' % [contrib, project])

      expect(response.body).to eq IO.binread(filepath)
    end
  end

  describe 'GET pdf_zip' do
    it 'returns zip' do
      contribs = %w(example_contrib_1 example_contrib_2 example_contrib_3)
      project = 'example_project'
      get(pdf_zip_path(contribs: contribs, project: project))
      filepath = Rails.root.join('tmp', '%s.zip' % project)

      expect(response.body).to eq IO.binread(filepath)
    end
  end
end
