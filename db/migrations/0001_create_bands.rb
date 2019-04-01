Sequel.migration do
  change do
    create_table :bands do
      primary_key :id
      String :bandname, null: false
      String :manager
      String :gimmick
      String :style
      String :country_origin
      Date :bandformed
    end

    create_table :girls do
      primary_key :id
      String :firstname
      String :surname
      String :nickname
      String :quirk
      Date :dob
    end

    create_table :lineups do
      primary_key :id
      Integer :girl_id
      Integer :band_id
      String :bandrole
      String :instrument
    end

  end
end
