require 'spec_helper'

context 'Поставщик.' do


      let(:user) {       User.destroy_all
      Factory(:supplier)
      }


    context "Входит на страницу логина. Вводит верные данные для логина." do
      before(:each) do
        visit login_path
        fill_in('Gln', :with=>user.gln)
        fill_in('Password', :with=>user.password)
        click_button('Login')
      end
      it 'Bход происходит' do
        page.should have_xpath('//a', :text => 'Log off')
      end
    end

    context "Входит на страницу логина. Вводит неверные данные для логина." do
      before(:each) do
        visit login_path
        fill_in('Gln', :with=>user.gln)
        fill_in('Password', :with=>'wrongpassword')
        click_button('Login')
      end
      it 'Вход не происходит.' do
        page.should have_xpath("//div[@id='errorExplanation']")
      end
    end

    context "Залогинен." do
      before(:each) do
        visit login_path
        fill_in('Gln', :with=>user.gln)
        fill_in('Password', :with=>user.password)
        click_button('Login')
      end
      context "Производит выход." do
        before(:each) do
          click_link('Log off')
        end
        it 'Происходит редирект на страницу логина.' do
          page.should have_xpath("//input[@id='user_session_submit']")
        end
      end
    end
end

