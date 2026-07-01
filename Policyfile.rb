# frozen_string_literal: true

name 'ark'

run_list 'recipe[test::default]'

cookbook 'ark', path: '.'
cookbook 'seven_zip', git: 'https://github.com/sous-chefs/seven_zip.git', branch: 'main'
cookbook 'ark_spec', path: './spec/fixtures/cookbooks/ark_spec'
cookbook 'test', path: './test/cookbooks/test'

Dir.children('./spec/fixtures/cookbooks/ark_spec/recipes').grep(/\.rb\z/).sort.each do |recipe|
  recipe_name = File.basename(recipe, '.rb')

  named_run_list recipe_name.to_sym, 'recipe[ark_spec::' + recipe_name + ']'
end

Dir.children('./test/cookbooks/test/recipes').grep(/\.rb\z/).sort.each do |recipe|
  recipe_name = File.basename(recipe, '.rb')

  named_run_list recipe_name.to_sym, 'recipe[test::' + recipe_name + ']'
end
