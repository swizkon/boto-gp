# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BotoGP.Repo.insert!(%BotoGP.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias BotoGP.Repo
alias BotoGP.Racer
alias BotoGP.Circuit

Repo.insert! %Racer{
    name: "Swizkon", 
    description: "A racer",
    number: "666"
}

Repo.insert! %Racer{
    name: "Malloc Frobnitz", 
    description: "A racer",
    number: "69"
}

Repo.insert! %Racer{
    name: "The Doctor", 
    description: "A racer",
    number: "46"
}


Repo.insert! %Racer{
    name: "Guy Martin", 
    description: "A racer",
    number: "23"
}

Repo.insert! %Circuit{
    name: "Le Mans", 
    width: 300,
    height: 200,
    scale: 3,
    checkpoints: "[[150,20],[130,20],[30,50],[50,80],[20,180]]"
}

Repo.insert! %Circuit{
    name: "Assen TT", 
    width: 300,
    height: 200,
    scale: 3,
    checkpoints: "[[150,20],[130,20]]"
}
#      add :datamap, :jsonb
