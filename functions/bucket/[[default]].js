/**
 * functions/bucket/[[default]].js — GET /bucket/<name>.json
 *
 * Serves Scoop bucket JSON from EdgeOne KV.
 * Key format: b_<name> (hyphens converted to underscores).
 *
 * Used by:
 *   - Scoop when users add the tribucket bucket
 *   - CLI (src/utils/software-source.ts) for remote version checking
 */

const CORS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET,OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
};

const KEY_REGEX = /^[0-9a-zA-Z_]{1,512}$/;

function nameToKey(name) {
  return 'tri_b_' + name.replace(/-/g, '_');
}

export async function onRequestGet(context) {
  try {
    const url = new URL(context.request.url);
    let name = url.pathname.replace('/bucket/', '').replace('.json', '');

    if (name.includes('/') || name.includes('\\') || name.includes('..')) {
      return new Response(JSON.stringify({ error: 'Invalid package name' }), { status: 400, headers: { ...CORS, 'Content-Type': 'application/json' }, });
    }
    if (!name || !KEY_REGEX.test(nameToKey(name))) {
      return new Response(JSON.stringify({ error: 'Invalid package name' }), {
        status: 400,
        headers: { ...CORS, 'Content-Type': 'application/json' },
      });
    }

    const val = await TRIBUCKET_KV.get(nameToKey(name), 'json');
    if (val === null) {
      return new Response(JSON.stringify({ error: 'Not found' }), {
        status: 404,
        headers: { ...CORS, 'Content-Type': 'application/json' },
      });
    }

    return new Response(JSON.stringify(val), {
      status: 200,
      headers: {
        ...CORS,
        'Content-Type': 'application/json; charset=utf-8',
        'Cache-Control': 'public, max-age=3600, must-revalidate',
      },
    });
  } catch (e) {
    return new Response(JSON.stringify({ error: 'Internal error' }), {
      status: 500,
      headers: { ...CORS, 'Content-Type': 'application/json' },
    });
  }
}

export async function onRequestOptions() {
  return new Response(null, { status: 204, headers: CORS });
}
