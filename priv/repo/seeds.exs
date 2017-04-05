# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     OpenPantry.Repo.insert!(%OpenPantry.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias OpenPantry.Facility
alias OpenPantry.Language
alias OpenPantry.Repo
alias OpenPantry.User
alias OpenPantry.UserCredit
alias OpenPantry.CreditType
import Ecto.Query
import OpenPantry.Factory


facility_params = [
  %{name: "Flatbush",
    max_occupancy: 100,
    location: %Geo.Point{coordinates: {-73.965288, 40.624061}},
    address1: "1372 Coney Island Ave",
    city: "Brooklyn",
    region: "NY",
    postal_code: "11230"
    },
  %{name: "Boro Park",
    max_occupancy: 20,
    location: %Geo.Point{coordinates: {-73.995519, 40.632360}},
    address1: "5402 New Utrecht Ave",
    city: "Brooklyn",
    region: "NY",
    postal_code: "11219"
    },
  %{name: "Queens",
    max_occupancy: 50,
    location: %Geo.Point{coordinates: {-73.858008, 40.728167}},
    address1: "98-08 Queens Blvd",
    city: "Queens",
    region: "NY",
    postal_code: "11374"
  }
]

credit_type_params = [
  %{name: "Proteinnoms",
    credits_per_period: 18,
    period_name: "Month"
    },
  %{name: "Veggienoms",
    credits_per_period: 18,
    period_name: "Month"
    },
  %{name: "Carbnoms",
    credits_per_period: 18,
    period_name: "Month"
  }
]

Enum.each(facility_params, fn(params) ->
  Facility.changeset(%Facility{}, params)
  |> Repo.insert!()
end)

Enum.each(credit_type_params, fn(params) ->
  CreditType.changeset(%CreditType{}, params)
  |> Repo.insert!()
end)

food_groups = for _ <- 1..20 do
  insert(:food_group)
end
foods = for food_group <- food_groups do
  insert(:food, food_group: food_group)
  insert(:food, food_group: food_group)
  insert(:food, food_group: food_group)
end

File.read!("priv/repo/languages.json")
|> Poison.Parser.parse!
|> Enum.each(
    fn(language) ->
      Language.changeset(%Language{}, %{iso_code: language["code"], english_name: language["name"], native_name: language["nativeName"] })
      |> Repo.insert!()
    end
  )

User.changeset(%User{}, %{name: "Anonymous",
                          family_members: 1,
                          primary_language_id: 184,
                          facility_id: 1,
                         })
|> Repo.insert!()

credit_types = CreditType |> Repo.all
user_credits = for credit_type <- credit_types do
  insert(:user_credit, credit_type: credit_type, user: (from u in User, where: u.id == 1) |> Repo.one )
end


facility = from f in Facility, where: f.id == 1
stocks = for food <- foods do
  insert(:stock, facility: facility, food: food)
end
