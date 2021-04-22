require 'rails_helper'

RSpec.describe "Users", type: :system do
  include LoginSupport
  let(:user) { build(:user) }
  let(:task) { create(:task) }

  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      before do
        visit root_path
        click_link "SignUp"
      end

      context 'フォームの入力値が正常' do
        before do
          sign_up_as(user)
        end

        it 'ユーザーの新規作成が成功する' do
          expect(current_path).to eq login_path
          expect(page).to have_content "Login"
          expect(page).to have_content "User was successfully created."
        end
      end

      context 'メールアドレスが未入力' do
        before do
          fill_in "Email", with: ""
          fill_in "Password", with: user.password
          fill_in "Password confirmation", with: user.password_confirmation
          click_button "SignUp"
        end

        it 'ユーザーの新規作成が失敗する' do
          expect(current_path).to eq users_path
          expect(page).to have_content "SignUp"
          expect(page).to have_content '1 error prohibited this user from being saved'
          expect(page).to have_content "Email can't be blank"
        end
      end

      context '登録済のメールアドレスを使用' do
        before do
          @existed_user = create(:user)

          fill_in "Email", with: @existed_user.email
          fill_in "Password", with: user.password
          fill_in "Password confirmation", with: user.password_confirmation
          click_button "SignUp"
        end

        it 'ユーザーの新規作成が失敗する', focus: true do
          expect(current_path).to eq users_path
          expect(page).to have_content "SignUp"
          expect(page).to have_content '1 error prohibited this user from being saved'
          expect(page).to have_content 'Email has already been taken'
          expect(page).to have_field 'Email', with: @existed_user.email
        end
      end
    end

    describe 'マイページ' do
      context 'ログインしていない状態' do
        before do
          user = create(:user)
          visit user_path(user)
        end

        it 'マイページへのアクセスが失敗する' do
          expect(current_path).to eq login_path
          expect(page).to have_content "Login"
          expect(page).to have_content "Login required"
        end
      end
    end
  end

  describe 'ログイン後' do
    before do
      sign_up_as(user)
      login_as(user)
    end

    describe 'ユーザー編集' do
      before do
        visit users_path
        click_link "Edit"
      end

      context 'フォームの入力値が正常' do
        before do
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          fill_in "Password confirmation", with: user.password_confirmation
          click_button "Update"
        end

        it 'ユーザーの編集が成功する'do
          expect(current_path).to eq user_path(1)
          expect(page).to have_content user.email
          expect(page).to have_content "User was successfully updated."
        end
      end

      context 'メールアドレスが未入力' do
        before do
          fill_in "Email", with: ""
          fill_in "Password", with: user.password
          fill_in "Password confirmation", with: user.password_confirmation
          click_button "Update"
        end

        it 'ユーザーの編集が失敗する' do
          expect(current_path).to eq user_path(1)
          expect(page).to have_content "Editing User"
          expect(page).to have_content "can't be blank"
        end
      end

      context '登録済のメールアドレスを使用' do
        before do
          @another_user = create(:user)
          fill_in "Email", with: @another_user.email
          fill_in "Password", with: user.password
          fill_in "Password confirmation", with: user.password_confirmation
          click_button "Update"
        end

        it 'ユーザーの編集が失敗する' do
          expect(current_path).to eq user_path(1)
          expect(page).to have_content "Editing User"
          expect(page).to have_content "has already been taken"
        end
      end

      context '他ユーザーの編集ページにアクセス' do
        before do
          @another_user = create(:user)
          visit edit_user_path(@another_user)
        end

        it '編集ページへのアクセスが失敗する' do
          expect(current_path).to eq user_path(1)
          expect(page).to have_content user.email
          expect(page).to have_content "Forbidden access."
        end
      end
    end
  end
end
