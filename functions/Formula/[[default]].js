/**
 * functions/Formula/[[default]].js — GET /Formula/<name>.rb
 *
 * Serves Homebrew Formula (.rb) files from EdgeOne KV.
 * Key format: f_<name> (hyphens converted to underscores).
 *
 * Used by Homebrew when users tap the tribucket repository.
 */

const CORS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET,OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
};

const KEY_REGEX = /^[0-9a-zA-Z_]{1,512}$/;

function nameToKey(name) {
  return 'tri_f_' + name.replace(/-/g, '_');
}

export async function onRequestGet(context) {
  try {
    const url = new URL(context.request.url);
    let name = url.pathname.replace('/Formula/', '').replace('.rb', '');

    if (!name || !KEY_REGEX.test(nameToKey(name))) {
      return new Response('Invalid package name', {
        status: 400,
        headers: CORS,
      });
    }

    const val = await TRIBUCKET_KV.get(nameToKey(name));
    if (val === null) {
      return new Response('Not found', {
        status: 404,
        headers: CORS,
      });
    }

    return new Response(val, {
      status: 200,
      headers: {
        ...CORS,
        'Content-Type': 'text/plain; charset=utf-8',
        'Cache-Control': 'public, max-age=3600, must-revalidate',
      },
    });
  } catch (e) {
    return new Response('Internal error', {
      status: 500,
      headers: CORS,
    });
  }
}

export async function onRequestOptions() {
  return new Response(null, { status: 204, headers: CORS });
}
