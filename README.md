![Scriptdrop](https://cdn.filepicker.io/api/file/DcyeWRHZTRSIKVeIXJ3l)

# Thoughts

## How is it went ?

Since I had my hands dirty with Elixir and Phoenix when a coded the first challenge I never stopped studying them. When I first read the new challenge I knew for sure that I could do it using Elixir without much problems and in just a few hours. I quickly finished the CLI in about 2 hours or so but, I used a bit over 2 extra hours to polish things, mostly user interface, I did not try to improve and polish the core of the code following what was oriented, thinking that will be interesting learn at the pair programming interview. I had a lot of better ways to implement some chunks of code using a more functional approach, but I didn't because I was going to expend too much time figuring it out.
I am particularly proud of the fact that I am a lot more comfortable with the language, especially pattern matching, I am now quick to find solutions on the docs, and understand error messages. Building CLIs and developer tools are something that I love to do and I am excited about the pair programming interview dreaming of learning a lot about Elixir and a better way to implement this CLI.

# List of future enhancements I’d like to make

- [ ] Add Code Documentation (The code is self-documented, but I am lacking in minimum documentation)
- [ ] Improve CLI Options Parser (I dont know if I did everythig like I should)
- [ ] Double check some CLI principles like stdio, return code, etc, so DevOps people will be Happy (I believe is everything right but I did not execute enough test)
- [ ] Improve CLI outputs
- [ ] Handle Invalid Json File (I could not handle Pattern Matching erros)
- [ ] Improve App Architecture (I did not Refactor anything, so I belive there are code breaking best practices)
- [ ] Improve Suggestions Output Algo to taking in consideration not just temperature
- [ ] Add Authentication
- [ ] Add new feature: Look up for Zip Code (I couldo do it, but I did note have the time)
- [ ] Add new feature: Look up for GPS coordinates (I couldo do it, but I did note have the time)

## English Note

I did not have time to ask anyone to review my English because my Weekend is Already full of activities but, and I am going to do this Monday for sure.

# Installation

- Download and Install Elixir

- Download App source code from GIT

- From root directory run:
  1. $ mix deps.get
  2. $ mix escript.build
  3. $ ./sweatercli --help
