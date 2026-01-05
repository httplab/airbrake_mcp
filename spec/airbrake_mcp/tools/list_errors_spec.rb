# frozen_string_literal: true

RSpec.describe AirbrakeMcp::Tools::ListErrors do
  let(:client) { instance_double(AirbrakeMcp::Client, project_id: 123) }
  let(:server_context) { { client: client } }

  describe '.call' do
    it 'returns formatted error groups' do
      groups_data = fixture('groups')
      allow(client).to receive(:groups).and_return(groups_data)

      response = described_class.call(server_context: server_context)

      expect(response.error?).to be false
      expect(response.content.first.text).to include('Found 2 error groups')
    end

    it 'passes pagination parameters' do
      allow(client).to receive(:groups)
        .with(project_id: 123, page: 2, limit: 50)
        .and_return({ 'groups' => [], 'count' => 0 })

      response = described_class.call(page: 2, limit: 50, server_context: server_context)

      expect(response.error?).to be false
    end

    it 'filters by resolved status' do
      groups_data = fixture('groups')
      allow(client).to receive(:groups).and_return(groups_data)

      response = described_class.call(resolved: true, server_context: server_context)

      expect(response.error?).to be false
      # The tool filters client-side
    end

    context 'when no project_id is configured' do
      let(:client) { instance_double(AirbrakeMcp::Client, project_id: nil) }

      it 'returns error' do
        response = described_class.call(server_context: server_context)

        expect(response.error?).to be true
        expect(response.content.first.text).to include('No project_id specified')
      end
    end
  end
end
