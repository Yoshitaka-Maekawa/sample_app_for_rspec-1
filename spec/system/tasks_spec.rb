require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  include LoginSupport
  include CreateTaskSupport
  let(:user) { build(:user) }
  let(:task) { build(:task) }

  describe 'ログイン前' do
    describe 'タスク新規作成ページ' do
      context 'ログインしていない状態' do
        it 'タスクの新規作成ページへのアクセスが失敗する' do
          visit new_task_path

          expect(current_path).to eq login_path
          expect(page).to have_content "Login"
          expect(page).to have_content "Login required"
        end
      end
    end

    describe 'タスク編集ページ' do
      context 'ログインしていない状態' do
        it 'タスクの編集ページへのアクセスが失敗する' do
          task = create(:task)
          visit edit_task_path(task)

          expect(current_path).to eq login_path
          expect(page).to have_content "Login"
          expect(page).to have_content "Login required"
        end
      end
    end

  describe 'ログイン後' do
    before do
      sign_up_as(user)
      login_as(user)
    end

    describe 'タスク作成' do
      context 'フォームの入力値が正常' do
        before do
          click_link "New task"
          fill_in "Title", with: task.title
          fill_in "Content", with: task.content
          select task.status, from: "Status"
          fill_in "Deadline", with: DateTime.new(2020, 6, 1, 10, 30)
          click_button "Create Task"
        end

        it '新規作成したタスクが表示される' do
          expect(current_path).to eq task_path(1)
          expect(page).to have_content "Title: #{task.title}"
          expect(page).to have_content "Content: #{task.content}"
          expect(page).to have_content "Status: #{task.status}"
          expect(page).to have_content 'Deadline: 2020/6/1 10:30'
          expect(page).to have_content "Task was successfully created."
        end
      end
    end

    describe 'タスク編集' do
      before do
        create_task(task)
      end

      context 'フォームの入力値が正常' do
        before do
          click_link "Edit"
          fill_in "Title", with: task.title
          fill_in "Content", with: task.content
          select task.status, from: "Status"
          fill_in "Deadline", with: task.deadline
          click_button "Update Task"
        end

        it 'タスクの編集が成功する' do
          expect(current_path).to eq task_path(1)
          expect(page).to have_content "Title: #{task.title}"
          expect(page).to have_content "Content: #{task.content}"
          expect(page).to have_content "Status: #{task.status}"
          expect(page).to have_content "Task was successfully updated."
        end
      end

      context '他ユーザーのタスクの編集ページにアクセス' do
        before do
          @another_user = create(:user)
          @another_task = create(:task, user: @another_user)
          visit edit_task_path(@another_task)
        end

        it 'タスク編集ページへのアクセスが失敗する' do
          expect(current_path).to eq root_path
          expect(page).to have_content "Tasks"
          expect(page).to have_content "Forbidden access."
        end
      end
    end

    describe 'タスク削除' do
      before do
        create_task(task)
      end

      context 'タスク削除ボタンをクリックする' do
        before do
          click_link "Task list"
          click_link "Destroy"
          page.driver.browser.switch_to.alert.accept
        end

        it 'タスクの削除が成功する' do
          expect(current_path).to eq tasks_path
          expect(page).to have_content "Tasks"
          expect(page).to have_content "Task was successfully destroyed."
        end
      end
    end
  end
end
