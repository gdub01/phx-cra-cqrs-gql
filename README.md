# Create React App and Phoenix

## Highlights

1. You don't need to eject create-react-app (CRA).. so you can keep up to date.
2. You get a lot of stuff for free with CRA like code splitting, testing, etc.
3. You get access to all the components in the react world that make front end work faster.

## ...but no SSR. 4 frontend practices make SSR with CRA difficult...

#### Common JS vs ES6 modules

The only react SSR parser I'm aware of is react-stdio which requires Common JS syntax to prerender the app.
CRA produces imports with the new ES6 module syntax.

So just getting SSR to work at all with CRA seems impossible unless you create a new webpack config, which kind of defeats the purpose of not ejecting a CRA app.

#### Code splitting

With CRA can/should? do code splitting to decrease your bundle size.
Getting SSR to work with code splitting seems to make importing harder.

#### Prefetching data

If you want to prefetch data to hydrate state when you respond via SSR, you need to recreate each route on the server side so you can specify the route's data dependencies... increasing dev time for creating and maintaining features.

#### Offline first

I had a tough time seeing where pre-fetching data for SSR and offline-first redux/state data stores intersect. There may be business trade-offs there and not absolute wins.

Really you only take the loading time hit once. After that with redux offline and the service worker, it's almost instant. Then using phoenix channels (perhaps look at absinthe graphql subscriptions?), you can get live updates to the data.

So the user gets almost instant loading with their last-seen data despite the app being not SSR'd.


## How to set it up:

#### Step 1: organize server and web folders to be at root of git repo

- mkdir appname
- cd appname
- mix phx.new appname --no-brunch --no-html
- mv appname server
- create-react-app appname
- mv appname web
- ... then merge the default .gitignores into one file at the base of the repo. You can look at the one in this repo for an idea of what files it might include.

#### Step 2: edit package.json

- near the top: `"proxy": "http://localhost:4000",`
- then under scripts replace `"build": "react-scripts build` with

`    
  "build": "react-scripts build && npm run post-build",
  "post-build": "rm -rf ../server/priv/build && mv build ../server/priv",
`

#### Step 3: Make it render on the server

- add this dep: `{:plug_static_index_html, "~> 1.0"}`
- In endpoint.ex replace app_name with ur appname:

`    
  plug Plug.Static.IndexHtml,
    at: "/"

  plug Plug.Static,
    at: "/", from: {:app_name, "priv/build"}, gzip: false,
    only: ~w(favicon.ico robots.txt manifest.json index.html)

  plug Plug.Static,
    at: "/static/js", from: {:app_name, "priv/build/static/js"}, gzip: true

  plug Plug.Static,
    at: "/static/css", from: {:app_name, "priv/build/static/css"}, gzip: true

  plug Plug.Static,
    at: "/static/media", from: {:app_name, "priv/build/static/media"}, gzip: false
`
- mix deps.get
- mix phx.server
- visit http://0.0.0.0:4000/
