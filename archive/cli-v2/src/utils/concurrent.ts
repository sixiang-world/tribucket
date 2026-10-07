/**
 * Concurrent task runner — like Python's ThreadPoolExecutor with as_completed.
 * Runs up to `workers` tasks concurrently, starting new ones as others finish.
 * Returns results in the same order as input items.
 *
 * @param items       Array of items to process.
 * @param fn          Async function applied to each item.
 * @param workers     Max concurrency (default 4).
 * @param onProgress  Optional callback fired after each task completes.
 *                    Receives (done, total, item) for live progress display.
 */
export async function concurrentMap<T, R>(
  items: T[],
  fn: (item: T, index: number) => Promise<R>,
  workers = 4,
  onProgress?: (done: number, total: number, item: T) => void,
): Promise<R[]> {
  const results: R[] = new Array(items.length);
  let nextIndex = 0;
  let completed = 0;

  async function worker(): Promise<void> {
    while (nextIndex < items.length) {
      const i = nextIndex++;
      results[i] = await fn(items[i], i);
      completed++;
      if (onProgress) {
        onProgress(completed, items.length, items[i]);
      }
    }
  }

  const poolSize = Math.min(workers, items.length);
  const workers_arr: Promise<void>[] = [];
  for (let w = 0; w < poolSize; w++) {
    workers_arr.push(worker());
  }
  await Promise.all(workers_arr);
  return results;
}
