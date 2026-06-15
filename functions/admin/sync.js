/**
 * functions/admin/sync.js — POST /admin/sync
 *
 * Protected endpoint that accepts batch writes to EdgeOne KV.
 * Used by the CI pipeline to sync packages/Formula/bucket data.
 *
 * Auth: Bearer token matching context.env.ADMIN_SYNC_KEY
 *
 * Request body (JSON):
 * {
 *   "items": [
 *     { "key": "tri_p_fzf",        "value": "{...}" },
 *     { "key": "tri_f_fzf",        "value": "class Fzf < Formula ..." },
 *     { "key": "tri_b_fzf",        "value": "{...}" },
 *     ...
 *   ],
 *   "index": [...]  // tri_packages_idx value (written last)
 * }
 */

const CORS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'POST,OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization',
};

const KEY_REGEX = /^[0-9a-zA-Z_]{1,512}$/;

export async function onRequestPost(context) {
  const { request } = context;

  // ── Verify auth ──
  const auth = request.headers.get('Authorization') || '';
  const token = auth.replace('Bearer ', '').trim();
  const expected = context.env?.ADMIN_SYNC_KEY;

  if (!expected || token !== expected) {
    return new Response(JSON.stringify({ error: 'Unauthorized' }), {
      status: 401,
      headers: { ...CORS, 'Content-Type': 'application/json' },
    });
  }

  // ── Parse body ──
  let body;
  try {
    body = await request.json();
  } catch {
    return new Response(JSON.stringify({ error: 'Invalid JSON body' }), {
      status: 400,
      headers: { ...CORS, 'Content-Type': 'application/json' },
    });
  }

  const { items, index } = body;
  if (!Array.isArray(items)) {
    return new Response(JSON.stringify({ error: 'items must be an array' }), {
      status: 400,
      headers: { ...CORS, 'Content-Type': 'application/json' },
    });
  }

  // ── Validate keys ──
  for (const item of items) {
    if (!item.key || !KEY_REGEX.test(item.key)) {
      return new Response(
        JSON.stringify({ error: `Invalid key: ${item.key || '(empty)'}` }),
        { status: 400, headers: { ...CORS, 'Content-Type': 'application/json' } },
      );
    }
  }

  // ── Write all items (parallel batches to avoid function timeout) ──
  try {
    const BATCH_SIZE = 20;
    for (let i = 0; i < items.length; i += BATCH_SIZE) {
      const batch = items.slice(i, i + BATCH_SIZE);
      await Promise.all(batch.map((item) => TRIBUCKET_KV.put(item.key, item.value)));
    }

    // Write index last so readers never see a partially-updated index
    if (index !== undefined) {
      await TRIBUCKET_KV.put('tri_packages_idx', JSON.stringify(index));
    }

    return new Response(
      JSON.stringify({ ok: true, count: items.length }),
      { status: 200, headers: { ...CORS, 'Content-Type': 'application/json' } },
    );
  } catch (e) {
    return new Response(
      JSON.stringify({ error: 'KV write failed' }),
      { status: 500, headers: { ...CORS, 'Content-Type': 'application/json' } },
    );
  }
}

export async function onRequestOptions() {
  return new Response(null, { status: 204, headers: CORS });
}
