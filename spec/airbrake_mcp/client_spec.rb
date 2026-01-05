# frozen_string_literal: true

RSpec.describe AirbrakeMcp::Client do
  let(:client) { described_class.new(user_key: 'test_key', project_id: 123) }

  describe '#projects' do
    it 'fetches all projects' do
      stub_request(:get, 'https://api.airbrake.io/projects')
        .with(query: hash_including(key: 'test_key'))
        .to_return(status: 200, body: fixture('projects').to_json)

      result = client.projects

      expect(result).to eq(fixture('projects')['projects'])
      expect(result.length).to eq(2)
      expect(result.first['name']).to eq('Production App')
    end
  end

  describe '#groups' do
    it 'fetches error groups for a project' do
      stub_request(:get, 'https://api.airbrake.io/projects/123/groups')
        .with(query: hash_including(key: 'test_key', page: '1', limit: '20'))
        .to_return(status: 200, body: fixture('groups').to_json)

      result = client.groups

      expect(result['groups'].length).to eq(2)
      expect(result['count']).to eq(2)
    end

    it 'supports pagination parameters' do
      stub_request(:get, 'https://api.airbrake.io/projects/123/groups')
        .with(query: hash_including(page: '2', limit: '50'))
        .to_return(status: 200, body: { groups: [], count: 0 }.to_json)

      result = client.groups(page: 2, limit: 50)

      expect(result['groups']).to eq([])
    end
  end

  describe '#group' do
    it 'fetches a single error group' do
      stub_request(:get, 'https://api.airbrake.io/projects/123/groups/1001')
        .with(query: hash_including(key: 'test_key'))
        .to_return(status: 200, body: fixture('group').to_json)

      result = client.group(1001)

      expect(result['id']).to eq(1001)
      expect(result['errors'].first['type']).to eq('RuntimeError')
    end

    context 'when group is not found' do
      it 'raises NotFoundError' do
        stub_request(:get, 'https://api.airbrake.io/projects/123/groups/9999')
          .with(query: hash_including(key: 'test_key'))
          .to_return(status: 404, body: { error: 'Not found' }.to_json)

        expect { client.group(9999) }.to raise_error(AirbrakeMcp::Client::NotFoundError)
      end
    end
  end

  describe '#notices' do
    it 'fetches notices for an error group' do
      stub_request(:get, 'https://api.airbrake.io/projects/123/groups/1001/notices')
        .with(query: hash_including(key: 'test_key'))
        .to_return(status: 200, body: fixture('notices').to_json)

      result = client.notices(1001)

      expect(result['notices'].length).to eq(2)
    end
  end

  describe '#resolve_group' do
    it 'marks a group as resolved' do
      stub_request(:put, 'https://api.airbrake.io/projects/123/groups/1001/resolved?key=test_key')
        .to_return(status: 200, body: '')

      result = client.resolve_group(1001)

      expect(result).to be true
    end
  end

  describe '#unresolve_group' do
    it 'marks a group as unresolved' do
      stub_request(:put, 'https://api.airbrake.io/projects/123/groups/1001/unresolved?key=test_key')
        .to_return(status: 200, body: '')

      result = client.unresolve_group(1001)

      expect(result).to be true
    end
  end

  describe '#mute_group' do
    it 'mutes a group' do
      stub_request(:put, 'https://api.airbrake.io/projects/123/groups/1001/muted?key=test_key')
        .to_return(status: 200, body: '')

      result = client.mute_group(1001)

      expect(result).to be true
    end
  end

  describe '#unmute_group' do
    it 'unmutes a group' do
      stub_request(:put, 'https://api.airbrake.io/projects/123/groups/1001/unmuted?key=test_key')
        .to_return(status: 200, body: '')

      result = client.unmute_group(1001)

      expect(result).to be true
    end
  end

  describe 'error handling' do
    it 'raises AuthenticationError on 401' do
      stub_request(:get, 'https://api.airbrake.io/projects')
        .with(query: hash_including(key: 'test_key'))
        .to_return(status: 401, body: '')

      expect { client.projects }.to raise_error(AirbrakeMcp::Client::AuthenticationError)
    end

    it 'raises RateLimitError on 429' do
      stub_request(:get, 'https://api.airbrake.io/projects')
        .with(query: hash_including(key: 'test_key'))
        .to_return(status: 429, body: '')

      expect { client.projects }.to raise_error(AirbrakeMcp::Client::RateLimitError)
    end

    it 'raises ApiError on other errors' do
      stub_request(:get, 'https://api.airbrake.io/projects')
        .with(query: hash_including(key: 'test_key'))
        .to_return(status: 500, body: '')

      expect { client.projects }.to raise_error(AirbrakeMcp::Client::ApiError)
    end
  end
end
