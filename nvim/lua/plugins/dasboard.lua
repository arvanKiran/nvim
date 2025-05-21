return {
  "goolord/alpha-nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "rcarriga/nvim-notify" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")
    local notify = require("notify")

    local function trim(s)
      if s == nil then return "" end
      return s:match("^%s*(.-)%s*$")
    end

    local followers, repos = "?", "?"

    -- 🎌 Kata-kata hari ini

local daily_words = {

  -- Indonesian
  "[Soekarno]\nBekerja keras untuk mewujudkan mimpi.",
  "[B.J. Habibie]\nKetelitian menghasilkan karya hebat.",
  "[R.A. Kartini]\nPendidikan membuka jendela dunia.",
  "[Taufik Hidayat]\nTekad membangun prestasi.",
  "[Chairul Tanjung]\nImpian besar butuh aksi nyata.",
  "[Anies Baswedan]\nBangkit dari kegagalan lebih kuat.",
  "[Najwa Shihab]\nSuaramu punya kekuatan.",
  "[Ridwan Kamil]\nLangkah kecil ubah banyak hal.",
  "[Susi Pudjiastuti]\nKeberanian mengubah dunia.",
  "[Iwan Fals]\nLagu hidupmu adalah kisahmu.",
  "[Deddy Corbuzier]\nDisiplin jembatan kesuksesan.",
  "[Nadiem Makarim]\nInovasi lahir dari rasa ingin tahu.",
  "[Warren Buffet]\nRisiko datang dari ketidaktahuan.",
  "[Soeharto]\nKonsistensi kunci keberhasilan.",
  "[B.J. Habibie]\nImpian besar dimulai dari langkah kecil.",
  "[Sukarno]\nBermimpilah setinggi langit.",
  "[B.J. Habibie]\nInovasi melahirkan kemajuan.",
  "[Pramudya]\nKarya terbaik lahir dari kesederhanaan.",
  "[Gus Dur]\nToleransi membangun kekuatan bangsa.",
  "[Gita Wirjawan]\nBelajarlah sepanjang hayat.",
  "[Tarra Budiman]\nSetiap detik berharga.",
  "[Maudy Ayunda]\nPendidikan adalah investasi tertinggi.",
  "[Raditya Dika]\nHumor menguatkan semangat.",
  "[Fiersa Besari]\nKisahmu bisa menginspirasi banyak jiwa.",
  "[Ustadz Abdul Somad]\nIlmu tanpa amal bagai pohon tak berbuah.",
  "[Najwa Shihab]\nPertanyaan baik membuka wawasan.",
  "[Ridwan Kamil]\nDesain kehidupan dengan visi.",
  "[Susi Pudjiastuti]\nLautan tantangan butuh keberanian.",
  "[B.J. Habibie]\nTeknologi memuliakan yang gigih.",
  "[Soeharto]\nBangun karakter lewat tindakan.",
  "[Iwan Fals]\nKebenaran lahir dari keberanian.",
  "[Chairul Tanjung]\nLayanan terbaik jadi pembeda.",
  "[Anies Baswedan]\nPikiran positif ciptakan solusi.",
  "[Habibie]\nImpian dan kerja keras bersatu.",
  "[Soehoktoko]\nInovasi tanpa batas imajinasimu.",
  "[Alfian Habibi]\nKreativitas bentuk masa depan.",
  "[Raffi Ahmad]\nSemangat pagi, produktivitas maksimal.",
  "[Cinta Laura]\nPercaya diri wujudkan impian.",
  "[Dian Sastrowardoyo]\nKeindahan lahir dari kesederhanaan.",
  "[Raisa]\nSuara hati panggilan semangat.",
  "[Agnez Mo]\nMusic menghidupkan semangat.",
  "[Giring]\nPolitik pun butuh kreativitas.",
  "[Tulus]\nLagu kecil bikin hari besar.",
  "[Maia Estianty]\nKeluarga adalah kekuatan utama.",
  "[Raditya Dika]\nTertawalah untuk melawan lelah.",
  "[Wikan Satriatama]\nKajian dalam membentuk tindakan.",
  "[Yusril Ihza Mahendra]\nHukum dan etika sejalan.",
}

math.randomseed(os.time())
local quote = daily_words[math.random(#daily_words)]

-- Tampilkan dengan nvim-notify
local notify = require("notify")
notify(quote, "info", { title = "Remember" })

    -- Ambil data GitHub
    local function fetch_github_data()
      local stdout1 = vim.loop.new_pipe(false)
      vim.loop.spawn("gh", {
        args = { "api", "users/arvanKiran", "--jq", ".followers" },
        stdio = { nil, stdout1, nil },
      }, vim.schedule_wrap(function()
        stdout1:read_start(function(_, data)
          if data then followers = trim(data) end
        end)
      end))

      local stdout2 = vim.loop.new_pipe(false)
      vim.loop.spawn("gh", {
        args = { "api", "users/arvanKiran", "--jq", ".public_repos" },
        stdio = { nil, stdout2, nil },
      }, vim.schedule_wrap(function()
        stdout2:read_start(function(_, data)
          if data then repos = trim(data) end
        end)
      end))
    end

    fetch_github_data()

    dashboard.section.header.val = {

    }

    dashboard.section.buttons.val = {}
    dashboard.section.buttons.opts.hl = "DashboardHeader"

    local fortune = vim.fn.systemlist("fortune -s")
    if vim.tbl_isempty(fortune) then fortune = { "Have fun coding! 💻" } end
    dashboard.section.footer.val = fortune
    dashboard.section.footer.opts.hl = "DashboardFooter"

    local config = dashboard.config
    config.layout = {
      { type = "padding", val = 1 },
      dashboard.section.header,
      { type = "padding", val = 1 },
      dashboard.section.footer,
    }

    config.opts.noautocmd = true
    alpha.setup(config)
  end,
  event = "VimEnter"
}

