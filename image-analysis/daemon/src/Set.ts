export default class Set<T> {
  map = new Map<string, any>();

  constructor(public keygen: (x: T) => string) {}

  add(key: T, val: any = null) {
    this.map.set(this.keygen(key), val);
  }

  delete(key: T) {
    this.map.delete(this.keygen(key));
  }

  has(key: T) {
    return this.map.has(this.keygen(key));
  }

  get(key: T) {
    return this.map.get(this.keygen(key));
  }

  size() {
    return this.map.size;
  }
}
