/**
 * functions/api/packages.js — GET /api/packages.json
 *
 * Returns the full package index (name, repo, description, homepage, license)
 * from EdgeOne KV. Used by the website's client-side JS to populate the
 * searchable package table.
 */

const CORS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET,OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
};

export async function onRequestGet(context) {
  try {
    const data = await TRIBUCKET_KV.get('tri_packages_idx', 'json');
    return new Response(JSON.stringify(data || []), {
      status: 200,
      headers: {
        ...CORS,
        'Content-Type': 'application/json; charset=utf-8',
        'Cache-Control': 'public, max-age=300, must-revalidate',
      },
    });
  } catch (e) {
    return new Response(JSON.stringify({ error: 'Internal error' }), {
      status: 500,
      headers: {
        ...CORS,
        'Content-Type': 'application/json',
      },
    });
  }
}

export async function onRequestOptions() {
  return new Response(null, { status: 204, headers: CORS });
}
