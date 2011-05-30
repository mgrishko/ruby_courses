require 'spec_helper'

context 'Поставщик вошел' do
    let (:user)  {
    User.destroy_all
    Factory(:supplier)
}
    let(:gpc) { Gpc.create( :code => '10000115',:name => 'Some Name') #Factory(:gpc)
     }
    let(:item){Item.create(:user_id => user.id)# Factory(:item, :user_id => user.id)
     }
    let(:country){Country.create(:code=>'RU',:description=>'')}
    let(:base_item) { Factory(:base_item,:user_id=>user.id,:item_id=> item.id,:country_of_origin_code=> country.code,:gpc_code=> gpc.code) }
    before do
        visit login_path
        fill_in('Gln', :with=>user.gln)
        fill_in('Password', :with=>user.password)
        click_button('Login')
    end
    context "Действия являющиеся Event" do
      before do
        visit base_item_path(base_item)
        fill_in('comment_content',:with =>'some comment')
        click_button('comment_submit')
      end
      context "Открывает страницу Events." do
        before do
          visit '/events'
        end
        it 'Видит событиe' do
          find('div[@class="event-comment"]').should_not be_nil
        end
      end

    end

end

