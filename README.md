# PDF2Image

[![hex.pm badge](https://img.shields.io/badge/Package%20on%20hex.pm-informational)](https://hex.pm/packages/pdf2image)
[![Documentation badge](https://img.shields.io/badge/Documentation-ff69b4)][docs]

[Online Documentation][docs].

A tiny library to convert PDF files into images. The output is an [Image](https://hex.pm/packages/image) object. This library works by calling out to `ghostscript`.

Usage example:

```elixir
{:ok, image} = PDF2Image.convert("some/path/file.pdf")
```

You can also specify some options:

```elixir
{:ok, image} = PDF2Image.convert("some/path/file.pdf", resolution: 300, device: "jpeg")
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `pdf2image` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:pdf2image, "~> 0.1.0"}
  ]
end
```

## Installation

You can install `pdf2image` by adding it to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:pdf2image, "~> 0.1.0"}
  ]
end
```

## License

Copyright 2024 Philip Pum

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  > https://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

[docs]: https://hexdocs.pm/pdf2image