# frozen_string_literal: true

RSpec.describe AirbrakeMcp::Tools::ListNotices do
  let(:client) { instance_double(AirbrakeMcp::Client, project_id: 123) }
  let(:server_context) { { client: client } }

  describe '.call' do
    it 'returns formatted notices' do
      notices = fixture('notices')
      allow(client).to receive(:notices).with(1001, project_id: 123, page: 1, limit: 10).and_return(notices)

      response = described_class.call(group_id: 1001, server_context: server_context)

      expect(response.error?).to be false
      expect(response.content.first[:text]).to include('Error occurrences')
    end

    it 'passes pagination parameters' do
      allow(client).to receive(:notices)
        .with(1001, project_id: 123, page: 2, limit: 5)
        .and_return({ 'notices' => [] })

      response = described_class.call(group_id: 1001, page: 2, limit: 5, server_context: server_context)

      expect(response.error?).to be false
    end

    context 'when group is not found' do
      it 'returns error response' do
        allow(client).to receive(:notices).and_raise(AirbrakeMcp::Client::NotFoundError)

        response = described_class.call(group_id: 9999, server_context: server_context)

        expect(response.error?).to be true
        expect(response.content.first[:text]).to include('not found')
      end
    end
  end
end
