import { loadConfig, saveConfig } from '../config/store';
import { t } from '../utils/locale';

function coerceValue(s: string): any {
  if (/^(true|yes|on)$/i.test(s)) return true;
  if (/^(false|no|off)$/i.test(s)) return false;
  if (s === '') return s;
  const num = Number(s);
  if (!isNaN(num)) return num;
  return s;
}

export function configCommand(subcommand: string, key?: string, value?: string): void {
  const config = loadConfig();

  switch (subcommand) {
    case 'list': {
      const settings = config.settings || {};
      if (Object.keys(settings).length === 0) { console.log(t('no_settings')); return; }
      for (const [k, v] of Object.entries(settings)) console.log(`${k} = ${v}`);
      break;
    }
    case 'get': {
      if (!key) { console.error(`Usage: tribucket config get <key>`); return; }
      const val = config.settings?.[key];
      if (val === undefined) console.log(t('setting_not_set', { key }));
      else console.log(val);
      break;
    }
    case 'set': {
      if (!key || !value) { console.error(`Usage: tribucket config set <key> <value>`); return; }
      config.settings = config.settings || {};
      config.settings[key] = coerceValue(value);
      saveConfig(config);
      console.log(t('set', { key, value: config.settings[key] }));
      break;
    }
    case 'unset': {
      if (!key) { console.error(`Usage: tribucket config unset <key>`); return; }
      if (config.settings && key in config.settings) { delete config.settings[key]; saveConfig(config); console.log(t('unset', { key })); }
      else console.log(t('setting_not_set', { key }));
      break;
    }
    default:
      console.log(t('config_usage'));
  }
}
