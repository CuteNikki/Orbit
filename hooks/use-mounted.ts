'use client';

import { useSyncExternalStore } from 'react';

const subscribe = () => () => {};

// False while server rendering and hydrating, true once running in the
// browser, for anything that can't render on the server (portals, the
// theme, which is only known client side) without a hydration mismatch.
export function useMounted() {
  return useSyncExternalStore(
    subscribe,
    () => true,
    () => false,
  );
}
