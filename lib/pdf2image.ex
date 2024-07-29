defmodule PDF2Image do
  @gs_devices [
    "jpeg",
    "jpegcmyk",
    "jpeggray",
    "png16",
    "png16m",
    "png16malpha",
    "png256",
    "png48",
    "pngalpha",
    "pnggray",
    "pngmono",
    "pngmonod",
    "tiff12nc",
    "tiff24nc",
    "tiff32nc",
    "tiff48nc",
    "tiff64nc",
    "tiffcrle",
    "tiffg3",
    "tiffg32d",
    "tiffg4",
    "tiffgray",
    "tifflzw",
    "tiffpack",
    "tiffscaled",
    "tiffscaled24",
    "tiffscaled32",
    "tiffscaled4",
    "tiffscaled8",
    "tiffsep",
    "tiffsep1"
  ]

  @schema [
    device: [
      type: {:in, @gs_devices},
      default: "pnggray",
      doc: "The ghostscript device (aka output format) to use (default: pnggray)"
    ],
    resolution: [
      type: :pos_integer,
      default: 150,
      doc: "The resolution of the output image in DPI (default: 150)"
    ],
    page: [
      type: :pos_integer,
      default: 1,
      doc: "The page number to convert (default: 1)"
    ],
    fit_page: [
      type: :boolean,
      default: true,
      doc:
        "Fit the page size of the current device. Sets `ghostscript` option `-dPDFFitPage`. (default: true)"
    ],
    crop: [
      type: :boolean,
      default: true,
      doc:
        "Crop the output to the bounding box. Sets `ghostscript` option `-dEPSCrop`. (default: true)"
    ]
  ]

  @type option() :: unquote(NimbleOptions.option_typespec(@schema))

  @doc "Convert a PDF file (on disk) to an image (in memory).\nSupported options:\n#{NimbleOptions.docs(@schema)}"
  @spec convert(binary(), option()) :: {:ok, Vix.Vips.Image.t()} | {:error, term()}
  def convert(path, opts \\ []) when is_binary(path) and is_list(opts) do
    if File.exists?(path) do
      case NimbleOptions.validate(opts, @schema) do
        {:ok, options} -> do_convert(path, options)
        {:error, reason} -> {:error, reason}
      end
    else
      {:error, "file does not exist"}
    end
  end

  defp do_convert(path, options) do
    with :ok <- validate_file_is_pdf(path),
         {:ok, args} <- generate_args(path, options),
         {:ok, executable} <- get_gs_exec(),
         {data, 0} <- System.cmd(executable, args) do
      Image.from_binary(data)
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp validate_file_is_pdf(path) do
    case File.open(path, [:binary]) do
      {:ok, file} ->
        case IO.binread(file, 5) do
          {:error, reason} -> {:error, reason}
          "%PDF-" -> :ok
          _ -> {:error, "not a PDF file"}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp generate_args(path, opts) do
    args = [
      "-sDEVICE=#{opts[:device]}",
      "-dFirstPage=#{opts[:page]}",
      "-dLastPage=#{opts[:page]}",
      "-dSAFER",
      "-dBATCH",
      "-dNOPAUSE",
      if(opts[:fit_page], do: "-dPDFFitPage", else: nil),
      "-o",
      "-",
      "-r#{opts[:resolution]}",
      if(opts[:crop], do: "-dEPSCrop", else: nil),
      "-q",
      path
    ]

    {:ok, args |> Enum.filter(&(&1 != nil))}
  end

  defp get_gs_exec() do
    case System.find_executable("gs") do
      path when is_binary(path) -> {:ok, path}
      _ -> {:error, "ghostscript executable not in PATH"}
    end
  end
end
