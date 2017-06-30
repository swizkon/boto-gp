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
    name: "Jonas", 
    description: "A racer"
}