import { loadConfig, saveConfig } from '../config/store';

function coerceValue(s: string): any {
  if (/^(true|yes|on)$/i.test(s)) return true;
  if (/^(false|no|off)$/i.test(s)) return false;
  const num = Number(s);
  if (!isNaN(num)) return num;
  return s;
}

export function configCommand(subcommand: string, key?: string, value?: string): void {
  const config = loadConfig();

  switch (subcommand) {
    case 'list': {
      const settings = config.settings || {};
      if (Object.keys(settings).length === 0) { console.log('No settings configured.'); return; }
      for (const [k, v] of Object.entries(settings)) console.log(`${k} = ${v}`);
      break;
    }
    case 'get': {
      if (!key) { console.error('Usage: tributable config get <key>'); return; }
      const val = config.settings?.[key];
      if (val === undefined) console.log(`Setting '${key}' is not set.`);
      else console.log(val);
      break;
    }
    case 'set': {
      if (!key || !value) { console.error('Usage: tributable config set <key> <value>'); return; }
      config.settings = config.settings || {};
      config.settings[key] = coerceValue(value);
      saveConfig(config);
      console.log(`Set ${key} = ${config.settings[key]}`);
      break;
    }
    case 'unset': {
      if (!key) { console.error('Usage: tributable config unset <key>'); return; }
      if (config.settings && key in config.settings) { delete config.settings[key]; saveConfig(config); console.log(`Unset ${key}`); }
      else console.log(`Setting '${key}' is not set.`);
      break;
    }
    default:
      console.log('Usage: tributable config [list|get|set|unset]');
  }
}
