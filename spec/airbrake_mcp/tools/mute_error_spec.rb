# frozen_string_literal: true

RSpec.describe AirbrakeMcp::Tools::MuteError do
  let(:client) { instance_double(AirbrakeMcp::Client, project_id: 123) }
  let(:server_context) { { client: client } }

  describe '.call' do
    context 'when muting' do
      it 'mutes error notifications' do
        allow(client).to receive(:mute_group).with(1001, project_id: 123).and_return(true)

        response = described_class.call(group_id: 1001, server_context: server_context)

        expect(response.error?).to be false
        expect(response.content.first[:text]).to include('muted')
      end
    end

    context 'when unmuting' do
      it 'unmutes error notifications' do
        allow(client).to receive(:unmute_group).with(1001, project_id: 123).and_return(true)

        response = described_class.call(group_id: 1001, mute: false, server_context: server_context)

        expect(response.error?).to be false
        expect(response.content.first[:text]).to include('unmuted')
      end
    end

    context 'when group is not found' do
      it 'returns error response' do
        allow(client).to receive(:mute_group).and_raise(AirbrakeMcp::Client::NotFoundError)

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
