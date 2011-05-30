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
    context "открывает страницу base_item'a." do
      before do
        visit base_item_path(base_item)
      end
      it 'видит верный gtin.' do

        page.should have_content(base_item.gtin)
      end
      it 'видит верный brand.' do
        page.should have_content(base_item.brand)
      end
      context 'клик по ссылке "Сменить изображение"' do
        before do
          click_link("link_upload")
        end
        it 'Видит форму загрузки фото ' do
          find_button('Загрузить').should be_visible
        end
        context 'Загружает картинку с локального диска' do
          before do
            path = File.join(::Rails.root,'spec','images', "test.jpg")
            @old = find("img[@id='item_image']")
            attach_file("image", path)
            click_button("Загрузить")
            visit base_item_path(base_item)
          end

          it 'На странице должен измениться адрес картинки' do
            find("img[@id='item_image']").should_not be_equal(@old)
          end

          it 'На сервере должна появиться картинка' do
            find("a[@id='iil']").click
            find('div[@id="lightbox-container-image"]').should be_visible
#            page.driver.response.status.should be_equal(200)
          end
        end

      end
    end
end

