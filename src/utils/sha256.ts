export function computeSha256(filepath: string): Promise<string> {
  const file = Bun.file(filepath);
  return Bun.CryptoHasher.hash('sha256', file).toString();
}
