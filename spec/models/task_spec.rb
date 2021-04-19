require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { create(:user) }

  context 'タスクのタイトルが存在しない場合' do
    before do
      @task_without_title = user.tasks.create(title: nil, status: 0)
    end

    it 'バリデーションエラーが発生する' do
      expect(@task_without_title).to be_invalid
    end

    it 'エラーメッセージを返す' do
      @task.valid?
      expect(@task_without_title.errors[:title]).to include("can't be blank")
    end
  end

  context 'タスクのタイトルが重複している場合' do
    before do
      user.tasks.create(title: 'テストタスク', status: 0)
      @task_with_duplicated_title = user.tasks.build(title: 'テストタスク', status: 1)
    end

    it 'バリデーションエラーが発生する' do
      expect(@task_with_duplicated_title).to be_invalid
    end

    it 'エラーメッセージを返す' do
      @task_with_duplicated_title.valid?
      expect(@task_with_duplicated_title.errors[:title]).to include("has already been taken")
    end
  end

  context 'タスクの状態が存在しない場合' do
    before do
      @task_without_status = user.tasks.create(title:'テストタスク', status: nil)
    end

    it 'バリデーションエラーが発生する' do
      expect(@task_without_status).to be_invalid
    end

    it 'エラーメッセージを返す' do
      @task.valid?
      expect(@task_without_status.errors[:status]).to include("can't be blank")
    end
  end
end
