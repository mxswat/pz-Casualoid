Casualoid.Settings = {}
Casualoid.Settings.FilePath = 'casualoid-settings.json';

function Casualoid.Settings.loadSettings()
  local settings = Casualoid.File.Load(Casualoid.Settings.FilePath);

  return settings or {}
end

function Casualoid.Settings.saveSettings(settings)
  Casualoid.File.Save(Casualoid.Settings.FilePath, settings);
end