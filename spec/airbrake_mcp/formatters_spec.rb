# frozen_string_literal: true

RSpec.describe AirbrakeMcp::Formatters do
  describe '.format_projects' do
    it 'formats a list of projects' do
      projects = [
        { 'id' => 123, 'name' => 'Production App' },
        { 'id' => 456, 'name' => 'Staging App' }
      ]

      result = described_class.format_projects(projects)

      expect(result).to include('Found 2 projects')
      expect(result).to include('[123] Production App')
      expect(result).to include('[456] Staging App')
    end

    it 'handles empty list' do
      result = described_class.format_projects([])

      expect(result).to eq('No projects found')
    end
  end

  describe '.format_groups' do
    it 'formats error groups' do
      groups_data = fixture('groups')

      result = described_class.format_groups(groups_data)

      expect(result).to include('Found 2 error groups')
      expect(result).to include('[OPEN] #1001')
      expect(result).to include('[RESOLVED]')
      expect(result).to include('(muted)')
      expect(result).to include('RuntimeError')
      expect(result).to include('42 occurrences')
    end

    it 'handles empty groups' do
      result = described_class.format_groups({ 'groups' => [] })

      expect(result).to eq('No error groups found')
    end
  end

  describe '.format_group_detail' do
    it 'formats detailed error information' do
      group = fixture('group')

      result = described_class.format_group_detail(group)

      expect(result).to include('Error Group #1001')
      expect(result).to include('Status: Open')
      expect(result).to include('Muted: No')
      expect(result).to include('RuntimeError')
      expect(result).to include('Something went wrong')
      expect(result).to include('42')
      expect(result).to include('Backtrace:')
      expect(result).to include('app/models/user.rb:42')
      expect(result).to include('`save!`')
    end
  end

  describe '.format_notices' do
    it 'formats notice list' do
      notices_data = fixture('notices')

      result = described_class.format_notices(notices_data)

      expect(result).to include('Error occurrences')
      expect(result).to include('Notice #abc123')
      expect(result).to include('RuntimeError')
      expect(result).to include('https://example.com/users/42')
      expect(result).to include('user_123')
    end

    it 'handles empty notices' do
      result = described_class.format_notices({ 'notices' => [] })

      expect(result).to eq('No notices found')
    end
  end

  describe '.truncate' do
    it 'truncates long strings' do
      result = described_class.truncate('a' * 100, 10)

      expect(result).to eq('a' * 10 + '...')
    end

    it 'leaves short strings unchanged' do
      result = described_class.truncate('short', 10)

      expect(result).to eq('short')
    end

    it 'handles nil' do
      result = described_class.truncate(nil, 10)

      expect(result).to eq('')
    end
  end
end
