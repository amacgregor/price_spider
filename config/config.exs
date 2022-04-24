# General application configuration
import Config

config :crawly,
  pipelines: [
    Crawly.Pipelines.JSONEncoder,
    {Crawly.Pipelines.WriteToFile, extension: "json", folder: "/tmp"}
  ],
  middlewares: [
    {Crawly.Middlewares.UserAgent,
     user_agents: [
       "Opera/9.80 (Windows NT 6.1; WOW64) Presto/2.12.388 Version/12.18"
     ]}
  ]
