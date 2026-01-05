# frozen_string_literal: true

RSpec.describe AirbrakeMcp::Tools::ListProjects do
  let(:client) { instance_double(AirbrakeMcp::Client) }
  let(:server_context) { { client: client } }

  describe '.call' do
    it 'returns formatted projects list' do
      projects = [
        { 'id' => 123, 'name' => 'Production App' },
        { 'id' => 456, 'name' => 'Staging App' }
      ]
      allow(client).to receive(:projects).and_return(projects)

      response = described_class.call(server_context: server_context)

      expect(response).to be_a(MCP::Tool::Response)
      expect(response.error?).to be false
      expect(response.content.first.text).to include('Found 2 projects')
    end

    context 'when API error occurs' do
      it 'returns error response' do
        allow(client).to receive(:projects).and_raise(AirbrakeMcp::Client::ApiError, 'Connection failed')

        response = described_class.call(server_context: server_context)

        expect(response.error?).to be true
        expect(response.content.first.text).to include('Error: Connection failed')
      end
    end
  end
end
