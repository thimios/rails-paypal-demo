ActiveAdmin.register Order do
  actions :all, :except => [:destroy, :new]
end
