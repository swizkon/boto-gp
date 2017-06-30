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
