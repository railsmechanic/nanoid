Benchee.run(
  %{
    "generate" => fn -> Nanoid.NonSecure.generate() end
  },
  profile_after: true
)
