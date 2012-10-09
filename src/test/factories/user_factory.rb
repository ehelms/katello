FactoryGirl.define do
  factory :user do

    factory :batman do
      username "batman"
      password "ihaveaterriblepassword"
      email    "batman@wayne.ent.com"
    end

    factory :admin do
      username "admin"
      password "nimda"
      email    "admin@wayne.ent.com"

      roles { |roles| [roles.association(:administrator)] }
    end

    factory :alfred do
      username  "Alfred"
      password  Password.update('Alfred')
      email     "alfred@wayne.ent.co"
    end

    factory :disabled_user do
      username  "disabled_user"
      password  "disabled_user_password"
      email     "disabled@user.com"
      disabled  true
    end

  end
end
