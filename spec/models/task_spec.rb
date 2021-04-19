require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { FactoryBot.create(:user) }

  context 'タスクのタイトルが存在しない場合' do
    before do
      @task = user.tasks.create(title: nil, status: 0)
    end

    it 'バリデーションエラーが発生する' do
      expect(@task).to be_invalid
    end

    it 'エラーメッセージを返す' do
      @task.valid?
      expect(@task.errors[:title]).to include("can't be blank")
    end
  end

  context 'タスクのタイトルが重複している場合' do
    before do
      task1 = user.tasks.create(title: 'テストタスク', status: 0)
      @task2 = user.tasks.build(title: 'テストタスク', status: 1)
    end

    it 'バリデーションエラーが発生する' do
      expect(@task2).to be_invalid
    end

    it 'エラーメッセージを返す' do
      @task2.valid?
      expect(@task2.errors[:title]).to include("has already been taken")
    end
  end

  context 'タスクの状態が存在しない場合' do
    before do
      @task = user.tasks.create(title:'テストタスク', status: nil)
    end

    it 'バリデーションエラーが発生する' do
      expect(@task).to be_invalid
    end

    it 'エラーメッセージを返す' do
      @task.valid?
      expect(@task.errors[:status]).to include("can't be blank")
    end
  end
end
