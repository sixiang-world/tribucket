/**
 * Minimal i18n: detect system language and return localized strings.
 *
 * Detection priority:
 *   1. TRIBUCKET_LANG env var (forced override: "en" | "zh")
 *   2. LANG / LC_ALL / LC_MESSAGES / LANGUAGE env vars
 *   3. Windows: os-locale via `locale` module (Bun built-in)
 *   4. Fallback: English
 */

let _lang: 'en' | 'zh' | undefined;

function detectLang(): 'en' | 'zh' {
  if (_lang) return _lang;

  // 1. Forced override
  const forced = process.env.TRIBUCKET_LANG?.toLowerCase();
  if (forced === 'zh' || forced === 'zh_cn' || forced === 'zh_tw' || forced === 'chinese') {
    _lang = 'zh';
    return _lang;
  }
  if (forced === 'en' || forced === 'english') {
    _lang = 'en';
    return _lang;
  }

  // 2. POSIX locale env vars
  const envVars = [process.env.LANG, process.env.LC_ALL, process.env.LC_MESSAGES, process.env.LANGUAGE];
  for (const v of envVars) {
    if (!v) continue;
    if (/^(zh|zh_CN|zh_TW|zh_HK|zh_SG|Chinese)/i.test(v)) {
      _lang = 'zh';
      return _lang;
    }
  }

  // 3. Fallback: English
  _lang = 'en';
  return _lang;
}

// ---------- Translation table ----------

type Vars = Record<string, string | number>;

const EN: Record<string, string | ((v: Vars) => string)> = {};
const ZH: Record<string, string | ((v: Vars) => string)> = {};

// Helper: define both languages in one call
function def(key: string, en: string, zh: string) {
  EN[key] = en;
  ZH[key] = zh;
}

// -- Common --
def('ok_installed', 'Installed: {path}', '已安装: {path}');
def('not_in_path', 'Not in PATH. Options:', '不在 PATH 中。可选操作：');
def('add_to_path', '  1. Add to PATH:  export PATH="{path}:$PATH"', '  1. 添加到 PATH:  export PATH="{path}:$PATH"');
def('reinstall_with_symlink', '  2. Reinstall with symlink:  tribucket install {name} --link', '  2. 使用符号链接重新安装:  tribucket install {name} --link');
def('no_packages_tracked', 'No packages tracked.', '尚未跟踪任何包。');

// -- Install / Update shared --
def('resolving_package', 'Resolving package: {name}', '正在解析包: {name}');
def('fetching_latest_release', 'Fetching latest release...', '正在获取最新版本...');
def('fetching_latest_release_for', 'Fetching latest release for {name}...', '正在获取 {name} 的最新版本...');
def('latest_release', 'Latest release: {tag}', '最新版本: {tag}');
def('could_not_fetch_release', 'Could not fetch latest release, using {version}', '无法获取最新版本，使用 {version}');
def('testing_mirrors', 'Testing mirrors...', '正在测试镜像源...');
def('mirror_selected', 'Mirror selected: {name} ({ms}ms)', '已选择镜像: {name} ({ms}ms)');
def('using_mirror', 'Using mirror: {name}', '使用镜像: {name}');
def('using_direct_download', 'Using direct download', '使用直连下载');
def('downloading', 'Downloading {filename}...', '正在下载 {filename}...');
def('download_complete', 'Download complete: {size} MB', '下载完成: {size} MB');
def('verifying_checksum', 'Verifying checksum...', '正在校验校验和...');
def('extracting_archive', 'Extracting archive...', '正在解压...');
def('checking_for_updates', 'Checking for updates...', '正在检查更新...');

// -- Network errors --
def('network_error_retrying', 'Network error ({code}), retrying ({n}/{total})...', '网络错误 ({code})，重试中 ({n}/{total})...');
def('rate_limited_retrying', 'Rate limited, retrying ({n}/{total})...', '被限流，重试中 ({n}/{total})...');
def('server_error_retrying', 'Server error, retrying ({n}/{total})...', '服务器错误，重试中 ({n}/{total})...');
def('cannot_check_remote_version', 'Cannot check remote version for {repo}', '无法检查 {repo} 的远程版本');
def('cannot_fetch_release_info', 'Cannot fetch release info for {repo}', '无法获取 {repo} 的发布信息');
def('cannot_determine_release_tag', 'Cannot determine release tag for {repo}', '无法确定 {repo} 的发布标签');
def('download_failed', 'Download failed', '下载失败');

// -- Error categories --
def('error_not_found', 'Package \'{name}\' not found in tribucket repo', '在 tribucket 仓库中未找到包 \'{name}\'');
def('error_already_installed', '\'{name}\' is already installed at {path}', '\'{name}\' 已安装在 {path}');
def('error_use_update', 'Use \'tribucket update {name}\' to update, or \'tribucket uninstall {name}\' first.', '使用 \'tribucket update {name}\' 更新，或先用 \'tribucket uninstall {name}\' 卸载。');
def('error_path_traversal', 'Path traversal detected: {name} resolves outside base directory', '检测到路径穿越: {name} 解析到基础目录之外');
def('error_forbidden_dir', 'Refusing to install into system directory: {path}', '拒绝安装到系统目录: {path}');
def('error_use_user_dir', 'Use --dir to specify a user directory, e.g.: --dir ~/apps', '使用 --dir 指定用户目录，例如: --dir ~/apps');
def('error_cannot_install_home', 'Cannot install into tribucket home directory: {path}', '不能安装到 tribucket 主目录: {path}');
def('error_use_different_dir', 'Use --dir to specify a different directory.', '使用 --dir 指定其他目录。');
def('error_dir_not_empty', 'Directory not empty: {path}', '目录非空: {path}');
def('error_use_force', 'Use --force to overwrite.', '使用 --force 强制覆盖。');
def('error_unsupported_platform', 'Unsupported platform', '不支持的平台');
def('error_no_asset', 'No asset available for {platform}', '{platform} 平台没有可用资源');
def('error_not_tracked', '\'{name}\' is not tracked.', '未跟踪 \'{name}\'。');
def('error_not_tracked_generic', '\'{name}\' is not tracked.', '未跟踪 \'{name}\'。');
def('error_package_not_found', 'Package \'{name}\' not found', '未找到包 \'{name}\'');
def('error_stale_path', 'Package path does not exist: {path}', '包路径不存在: {path}');
def('error_run_untrack', 'Run \'tribucket untrack {name}\' to remove stale entry.', '运行 \'tribucket untrack {name}\' 移除过期条目。');
def('error_config_missing', 'tribucket.json not found in {path}', '在 {path} 中未找到 tribucket.json');
def('error_symlink_failed', 'Failed to create symlink: {link} {arrow} {target}', '创建符号链接失败: {link} {arrow} {target}');
def('error_windows_symlink_hint', 'Windows requires Administrator rights or Developer Mode enabled to create symlinks. Enable Developer Mode in Settings, or rerun from an elevated shell.', 'Windows 需要管理员权限或开启开发者模式才能创建符号链接。请在设置中开启开发者模式，或以管理员身份运行。');
def('error_sha256_mismatch', 'SHA256 mismatch for {filename}', '{filename} 的 SHA256 校验不匹配');
def('error_integrity_expected', 'Expected: {expected}\nGot: {actual}', '预期: {expected}\n实际: {actual}');

// -- Self-update --
def('already_up_to_date', 'Already up to date ({version})', '已是最新版本 ({version})');
def('current_latest', 'Current: {current}  Latest: {latest}', '当前: {current}  最新: {latest}');
def('downloading_asset', 'Downloading {filename}...', '正在下载 {filename}...');
def('updated', 'Updated: {from} {arrow} {to}', '已更新: {from} {arrow} {to}');
def('restart_to_use', 'Restart tribucket to use the new version.', '重启 tribucket 以使用新版本。');
def('error_cannot_check_updates', 'Cannot check for updates: {message}', '无法检查更新: {message}');
def('error_cannot_determine_path', 'Cannot determine script path', '无法确定脚本路径');
def('error_binary_asset_not_found', 'Binary asset not found in release (expected {filename})', '发布中未找到二进制资源 (预期 {filename})');
def('error_sha256_corrupted', 'SHA256 mismatch — download may be corrupted', 'SHA256 不匹配 — 下载可能已损坏');
def('error_update_failed', 'Update failed: {message}', '更新失败: {message}');
def('restored_from_backup', 'Restored original binary from backup.', '已从备份恢复原始二进制文件。');

// -- List --
def('name', 'Name', '名称');
def('version', 'Version', '版本');
def('remote', 'Remote', '远程');
def('status_latest', 'Status', '状态');
def('path', 'Path', '路径');
def('latest', 'latest', '最新');
def('outdated', 'outdated', '过期');
def('not_found', 'not found', '未找到');
def('offline', 'offline', '离线');
def('dangling_symlinks', 'Found {count} dangling symlink(s):', '发现 {count} 个悬空符号链接:');
def('stale_entries', 'Found {count} stale entry(ies): {names}', '发现 {count} 个过期条目: {names}');
def('run_clean', 'Run \'tribucket clean\' to remove them.', '运行 \'tribucket clean\' 清理它们。');

// -- Update result --
def('already_up_to_date_pkg', '{name}: {version} — already up to date', '{name}: {version} — 已是最新版本');

// -- Track --
def('tracked', 'Tracked: {name} at {path}', '已跟踪: {name} 于 {path}');
def('untracked', 'Untracked: {name}', '已取消跟踪: {name}');
def('path_does_not_exist', 'path does not exist: {path}', '路径不存在: {path}');

// -- Clean --
def('removed_stale_entries', 'Removed {count} stale entry(ies):', '已移除 {count} 个过期条目:');
def('removing_dangling_symlinks', 'Removing {count} dangling symlink(s):', '正在移除 {count} 个悬空符号链接:');
def('no_stale_entries', 'No stale entries found.', '未发现过期条目。');
def('nothing_to_clean', 'Nothing to clean.', '无需清理。');

// -- Uninstall --
def('deleted', 'Deleted: {path}', '已删除: {path}');
def('removed_symlink', 'Removed symlink: {path}', '已移除符号链接: {path}');
def('removed_backup', 'Removed backup: {path}', '已移除备份: {path}');
def('untrack_failed', 'Warning: Failed to remove \'{name}\' from config. Run \'tribucket untrack {name}\' manually.', '警告: 无法从配置中移除 \'{name}\'。请手动运行 \'tribucket untrack {name}\'。');

// -- Config --
def('no_settings', 'No settings configured.', '未配置任何设置。');
def('setting_not_set', 'Setting \'{key}\' is not set.', '设置 \'{key}\' 未配置。');
def('config_usage', 'Usage: tribucket config [list|get|set|unset]', '用法: tribucket config [list|get|set|unset]');
def('set', 'Set {key} = {value}', '已设置 {key} = {value}');
def('unset', 'Unset {key}', '已取消设置 {key}');

// -- Interrupt --
def('interrupted', 'Interrupted. Partial download saved. Run the same command again to resume.', '已中断。部分下载已保存。再次运行相同命令即可续传。');
def('interrupted_sigint', 'Interrupted.', '已中断。');
def('error_self_update_dev', 'Cannot self-update in development mode.', '开发模式下无法自更新。');
def('error_self_update_dev_hint', 'Run the compiled binary (tribucket) instead of `bun run src/index.ts`.', '请运行编译后的二进制文件 (tribucket)，而不是 `bun run src/index.ts`。');


// -- Info command --
def('info_name', 'Name', '名称');
def('info_repo', 'Repo', '仓库');
def('info_description', 'Description', '描述');
def('info_binary', 'Binary', '二进制');
def('info_license', 'License', '许可证');
def('info_homepage', 'Homepage', '主页');
def('info_install_type', 'Install type', '安装类型');
def('info_installed_path', 'Installed at', '安装位置');
def('info_version', 'Version', '版本');
def('info_tracked_at', 'Tracked at', '跟踪时间');
def('info_stale', 'Path no longer exists — package is stale', '路径已不存在 — 包已过期');

// -- Confirmation prompts --
def('confirm_uninstall', 'Are you sure you want to uninstall \'{name}\'?', '确定要卸载 \'{name}\' 吗？');
def('confirm_force_install', 'Directory {path} already exists and is not empty. Overwrite?', '目录 {path} 已存在且非空。是否覆盖？');
def('confirm_update_all', 'Update all {count} packages?', '更新全部 {count} 个包？');
def('skipped_confirmation', 'Skipping confirmation (non-interactive)', '跳过确认（非交互模式）');

// -- Check progress --
def('checking_packages', 'Checking packages... ({done}/{total})', '正在检查包... ({done}/{total})');
def('packages_check_complete', 'Check complete: {ok} up-to-date, {outdated} outdated, {errors} errors', '检查完成：{ok} 个最新，{outdated} 个过期，{errors} 个错误');

// -- Update progress --
def('updating_packages', 'Updating packages... ({done}/{total})', '正在更新包... ({done}/{total})');
def('update_summary', '{ok} updated, {failed} failed.', '{ok} 个更新成功，{failed} 个失败。');

// -- Restore messages (previously hardcoded English) --
def('restore_from_backup', 'Update failed, restoring from backup...', '更新失败，正在从备份恢复...');
def('restore_success', 'Restore successful.', '恢复成功。');
def('restore_failed', 'Restore also failed: {error}', '恢复也失败了: {error}');

// ---------- Public API ----------

/**
 * Translate a message key with optional variable substitution.
 *
 * Usage:
 *   t('resolving_package', { name: 'ccx' })
 *   => English: "Resolving package: ccx"
 *   => Chinese:  "正在解析包: ccx"
 */
export function t(key: string, vars?: Vars): string {
  const lang = detectLang();
  const table = lang === 'zh' ? ZH : EN;
  let tmpl = table[key] as string | undefined;
  if (tmpl === undefined) {
    // Fallback: try the other language, or return the key itself
    tmpl = (lang === 'zh' ? EN : ZH)[key] as string | undefined;
    if (tmpl === undefined) return key;
  }
  // Simple {var} substitution
  if (vars) {
    for (const [k, v] of Object.entries(vars)) {
      tmpl = tmpl!.replace(new RegExp(`\\{${k}\\}`, 'g'), String(v));
    }
  }
  return tmpl!;
}

/**
 * Returns the current detected language code.
 */
export function getLang(): 'en' | 'zh' {
  return detectLang();
}
