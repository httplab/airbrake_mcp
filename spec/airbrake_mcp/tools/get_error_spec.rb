# frozen_string_literal: true

RSpec.describe AirbrakeMcp::Tools::GetError do
  let(:client) { instance_double(AirbrakeMcp::Client, project_id: 123) }
  let(:server_context) { { client: client } }

  describe '.call' do
    it 'returns detailed error information' do
      group = fixture('group')
      allow(client).to receive(:group).with(1001, project_id: 123).and_return(group)

      response = described_class.call(group_id: 1001, server_context: server_context)

      expect(response.error?).to be false
      expect(response.content.first[:text]).to include('Error Group #1001')
      expect(response.content.first[:text]).to include('RuntimeError')
    end

    context 'when group is not found' do
      it 'returns error response' do
        allow(client).to receive(:group).and_raise(AirbrakeMcp::Client::NotFoundError)

        response = described_class.call(group_id: 9999, server_context: server_context)

        expect(response.error?).to be true
        expect(response.content.first[:text]).to include('not found')
      end
    end

    context 'when no project_id is configured' do
      let(:client) { instance_double(AirbrakeMcp::Client, project_id: nil) }

      it 'returns error' do
        response = described_class.call(group_id: 1001, server_context: server_context)

        expect(response.error?).to be true
        expect(response.content.first[:text]).to include('No project_id specified')
      end
    end
  end
end
