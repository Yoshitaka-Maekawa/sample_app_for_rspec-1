require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  include LoginSupport
  let(:user) { build(:user) }
  let(:task) { build(:task) }

  before do
    sign_up_as(user)
  end

  describe 'ログイン前' do
    context 'フォームの入力値が正常' do
      before do
        login_as(user)
      end

      it 'ログイン処理が成功する' do
        expect(current_path).to eq root_path
        expect(page).to have_content "Tasks"
        expect(page).to have_content "Login successful"
      end
    end

    context 'フォームが未入力' do
      before do
        fill_in "Email", with: ""
        fill_in "Password", with: user.password
        click_button "Login"
      end

      it 'ログイン処理が失敗する' do
        expect(current_path).to eq login_path
        expect(page).to have_content "Login"
        expect(page).to have_content "Login failed"
      end
    end
  end

  describe 'ログイン後' do
    before do
      login_as(user)
    end

    context 'ログアウトボタンをクリック' do
      before do
        click_link "Logout"
      end

      it 'ログアウト処理が成功する' do
        expect(current_path).to eq root_path
        expect(page).to have_content "Tasks"
        expect(page).to have_content "Logged out"
      end
    end
  end
end
